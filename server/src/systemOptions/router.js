let Router = require('koa-router');
const { reply, validator, PermissionTypes, middleware } = require('@modular-rest/server');

let name = 'systemOptions';
let service = require('./service');
let systemOptions = new Router();

// systemOptions.use('/', middleware.auth, async (ctx, next) => {
//     let body = ctx.request.body;
//     // console.log(ctx.state.user);
//     let key = ctx.state.user.permission[PermissionTypes.anonymous_access];

//     // if (key == false && body.type == 'user')
//     //     key = user.hasPermission(PermissionTypes.user_access);

//     if (key == false) ctx.throw(403, "you don't have permission");
//     else await next();
// });

function checkUserPermission(user, permissionType) {
    let key = user.permission[permissionType];
    return !!key;
}

systemOptions.get('/getAll', async (ctx) => {
    let result;

    await service.getOptions.then((options) => {
        result = reply('s', { 'options': options });
    }).catch(err => {
        ctx.status = err.status || 500;
        result = err;
    });

    ctx.body = result;
});

systemOptions.post('/getOne', async (ctx) => {
    let body = ctx.request.body;

    // validate
    let bodyValidate = validator(body, 'title');

    let result;

    if (!bodyValidate.isValid) {
        ctx.status = 412;
        result = reply('f', { 'm': 'some fileds required.', 'e': bodyValidate.requires });
    }

    else {

        await service.getOption(body.title)
            .then((options) => {
                result = reply('s', { 'option': options });
            }).catch(err => {
                ctx.status = err.status || 500;
                result = err;
            });

    }

    ctx.body = result;
});

systemOptions.post('/set', middleware.auth, async (ctx) => {
    let body = ctx.request.body;

    // validate
    let bodyValidate = validator(body, 'options');

    let result;

    if (!bodyValidate.isValid) {
        ctx.status = 412;
        result = reply('f', { 'm': 'some fileds required.', 'e': bodyValidate.requires });
    }

    if (!checkUserPermission(ctx.state.user, PermissionTypes.god_access)) {
        ctx.throw(403, "you don't have permission");
    }

    else {
        await service.setOptions(body.options)
            .then((operationResult) => {
                result = reply('s', operationResult);
            }).catch(err => {
                ctx.status = err.status || 500;
                result = err;
            });
    }

    ctx.body = result;
});

module.exports.name = name;
module.exports.main = systemOptions;