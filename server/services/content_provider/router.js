let Mongoose = require('mongoose');
let { opTypes } = require('./../../class/accsess_definition');
let Router = require('koa-router');
let { validateObject, reply } = require('modular-rest-toolkit');
var nestedProperty = require("nested-property");

//let Types = require('./types.js');

let name = 'contentProvider';

let service = require('./service');
let middleware = require('./../../middlewares');

let contentProvider = new Router();

contentProvider.use('/', middleware.auth, async (ctx, next) => {
    let body = ctx.request.body;
    let bodyValidated = validateObject(body, 'database collection');
    
    // fields validation
    if (!bodyValidated.isValid) {
        ctx.throw(412, JSON.stringify(
            reply('e', { 'e': bodyValidated.requires })));
    }

    // type caster
    if (body.types && body.hasOwnProperty(body.bodyKey || ".")) {
        let bodyKey = body.bodyKey;
        for (const key in body.types) {
            if (
                body.types.hasOwnProperty(key)
                && typeof body.types[key] == "object"
            ) {
                let typeDetail = body.types[key];

                try {
                    let value = nestedProperty.get(body[bodyKey], typeDetail.path);
                    let newProperty = service.TypeCasters[typeDetail.type](value);
                    nestedProperty.set(body[bodyKey], typeDetail.path, newProperty);
                    console.log('newProperty', newProperty, JSON.stringify(body[bodyKey]));
                } catch (e) {
                    console.log('type caster error', e);
                }
            }
        }
    }

    await next();
});

contentProvider.post('/find', async (ctx, next) => {
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'database collection query');

    // fields validation
    if (!bodyValidate.isValid) {
        ctx.throw(412, JSON.stringify(
            reply('e', { 'e': bodyValidate.requires })));
    }

    // access validation
    let hasAccess = service.checkAccess(body.database, body.collection, opTypes.read, body.query, ctx.state.user);
    if (!hasAccess) {
      console.log(body);
      console.log(ctx.state.user.permission);
      ctx.throw(403, 'access denied');
    }

    // collection validation
    let collection = service.getCollection(body.database, body.collection);
    if (collection == null) {
        ctx.throw(412, JSON.stringify(
            reply('e', { 'e': 'wrong database or collection' })));
    }

    // operate on db
    await collection.find(body.query, body.projection, body.options).exec()
        .then(async docs => {
            ctx.state = docs;
            await next();
        })
        .catch(err => {
            ctx.status = err.status || 500;
            ctx.body = err.message;
        });
});

contentProvider.post('/findOne', async (ctx, next) => {
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'collection query');

    // fields validation
    if (!bodyValidate.isValid) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': bodyValidate.requires })), 412);
    }

    // access validation
    let hasAccess = service.checkAccess(body.database, body.collection, opTypes.read, body.query, ctx.state.user);
    if (!hasAccess) ctx.throw(403, 'access denied');

    // collection validation
    let collection = service.getCollection(body.database, body.collection);
    if (collection == null) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': 'wrong database or collection' })), 412);
    }

    // operate on db
    await collection.findOne(body.query, body.projection, body.options).exec()
        .then(async doc => {
            ctx.state = doc;
            await next();
        })
        .catch(err => {
            ctx.status = err.status || 500;
            ctx.body = err.message;
        });
});

contentProvider.post('/count', async (ctx) => {
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'database collection query');

    // fields validation
    if (!bodyValidate.isValid) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': bodyValidate.requires })), 412);
    }

    // access validation
    let hasAccess = service.checkAccess(body.database, body.collection, opTypes.read, body.query, ctx.state.user);
    if (!hasAccess) ctx.throw(403, 'access denied');

    // collection validation
    let collection = service.getCollection(body.database, body.collection);
    if (collection == null) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': 'wrong database or collection' })), 412);
    }

    // operate on db
    await collection.countDocuments(body.query).exec()
        .then(docs => ctx.body = docs)
        .catch(err => {
            ctx.status = err.status || 500;
            ctx.body = err.message;
        });
});

contentProvider.post('/updateOne', async (ctx) => {
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'database collection query update');

    // fields validation
    if (!bodyValidate.isValid) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': bodyValidate.requires })), 412);
    }

    // access validation
    let hasAccess = service.checkAccess(body.database, body.collection, opTypes.write, body.query, ctx.state.user);
    if (!hasAccess) ctx.throw(403, 'access denied');

    // collection validation
    let collection = service.getCollection(body.database, body.collection);
    if (collection == null) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': 'wrong database or collection' })), 412);
    }

    // get removing doc as output for triggers
    let output = await collection.findOne(body.query).exec().then();

    // operate on db
    await collection.updateOne(body.query, body.update, body.options).exec()
        .then((writeOpResult) => {
            service.triggers.call('updateOne', body.database, body.collection,
                { 'input': body.query, 'output': output });

            ctx.body = writeOpResult;
        })
        .catch(err => {
            ctx.status = err.status || 500;
            ctx.body = err.message;
        });
});

contentProvider.post('/insertOne', async (ctx, next) => {
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'database collection doc');

    // fields validation
    if (!bodyValidate.isValid) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': bodyValidate.requires })), 412);
    }

    // access validation
    let hasAccess = service.checkAccess(body.database, body.collection, opTypes.write, body.doc, ctx.state.user);
    if (!hasAccess) {
      console.log(body);
      console.log(ctx.state.user.permission);
      ctx.throw(403, 'access denied');
    }

    // collection validation
    let collection = service.getCollection(body.database, body.collection);
    if (collection == null) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': 'wrong database or collection' })), 412);
    }

    // operate on db
    await new collection(body.doc).save()
        .then(async (newDoc) => {
            service.triggers.call('insertOne', body.database, body.collection,
                { 'input': body.query, 'output': newDoc });

            ctx.state = newDoc;
            await next();
        })
        .catch(err => {
            ctx.status = err.status || 500;
            ctx.body = err.message;
        });
});

contentProvider.post('/removeOne', async (ctx) => {
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'database collection query');

    // fields validation
    if (!bodyValidate.isValid) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': bodyValidate.requires })), 412);
    }

    // access validation
    let hasAccess = service.checkAccess(body.database, body.collection, opTypes.write, body.query, ctx.state.user);
    if (!hasAccess) ctx.throw(403, 'access denied');

    // collection validation
    let collection = service.getCollection(body.database, body.collection);
    if (collection == null) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': 'wrong database or collection' })), 412);
    }

    // get removing doc as output for triggers
    let output = await collection.findOne(body.query).exec().then();

    // operate on db
    await collection.deleteOne(body.query).exec()
        .then(async (result) => {
            service.triggers.call('removeOne', body.database, body.collection,
                { 'input': body.query, 'output': output });

            ctx.body = result;
        })
        .catch(err => {
            ctx.status = err.status || 500;
            ctx.body = err.message;
        });
});

contentProvider.post('/aggregate', async (ctx, next) => {
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'database collection piplines accessQuery');

    // fields validation
    if (!bodyValidate.isValid) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': bodyValidate.requires })), 412);
    }

    // access validation
    let hasAccess = service.checkAccess(body.database, body.collection, opTypes.read, body.accessQuery, ctx.state.user);
    if (!hasAccess) ctx.throw(403, 'access denied');

    // collection validation
    let collection = service.getCollection(body.database, body.collection);
    if (collection == null) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': 'wrong database or collection' })), 412);
    }

    // operate on db
    await collection.aggregate(body.piplines).exec()
        .then(async (result) => {
            ctx.state = result;
            await next();
        })
        .catch(err => {
            ctx.status = err.status || 500;
            ctx.body = err.message;
        });
});

contentProvider.post('/getByIds', async (ctx, next) => {
    let body = ctx.request.body;
    let bodyValidate = validateObject(body, 'database collection IDs');

    // fields validation
    if (!bodyValidate.isValid) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': bodyValidate.requires })), 412);
    }

    // access validation
    let hasAccess = service.checkAccess(body.database, body.collection, opTypes.read, {}, ctx.state.user);
    if (!hasAccess) ctx.throw(403, 'access denied');

    // collection validation
    let collection = service.getCollection(body.database, body.collection);
    if (collection == null) {
        ctx.throw(JSON.stringify(
            reply('e', { 'e': 'wrong database or collection' })), 412);
    }

    let or = [];

    try {
        body.IDs.forEach(id => {
            let castedid = service.getAsID(id);
            or.push({ '_id': castedid });
        });
    } catch (e) {
        console.log('IDs.forEach', e);
    }

    let piplines = [
        {
            $match: { $or: or }
        },
        // {
        //     $sort: body.sort || { _id: 1 }
        // }
    ];

    // operate on db
    await collection.aggregate(piplines).exec()
        .then(async (result) => {
            ctx.state = result;
            await next();
        })
        .catch(err => {
            ctx.status = err.status || 500;
            ctx.body = err.message;
        });
});

contentProvider.use('/', async (ctx, next) => {

    // this event is responsible to covert whole mongoose doc to json form
    // inclouding getters, public propertise 
    // each mongoose doc must have a "toJson" method being defined on its own Schema.

    let state = ctx.state;
//     let result;

//     // array
//     if(!isNaN(state.length)) {
//         result = [];

//         for (let index = 0; index < state.length; index++) {
//             const element = state[index];
//             if(element.hasOwnProperty('toJson'))
//                 result.push(element.toJson());
//             else result.push(element);
//         }
//     }
//     // object
//     else {
//         result = state.toJson();
//     }

    ctx.body = state;
});

module.exports.name = name;
module.exports.main = contentProvider;