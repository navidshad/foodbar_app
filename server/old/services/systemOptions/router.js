let Router = require('koa-router');
let tools = require('modular-rest-toolkit');
let name = 'systemOptions';

let PermissionTypes = require('./../../class/accsess_definition').Types;

let service = require('./service');
let middleware = require('./../../middlewares');
let systemOptions = new Router();

systemOptions.use('/', middleware.auth, async (ctx, next) => {
    let body = ctx.request.body;
    // console.log(ctx.state.user);
    let key = ctx.state.user.permission[PermissionTypes.archive_manager];

    if (key == false && body.type == 'user')
        key = user.hasPermission(PermissionTypes.customer_access);

    if (key == false) ctx.throw(403, "you don't have permission");
    else await next();
});

systemOptions.get('/getAll', async (ctx) => {
    let result;

    await service.getOptions.then((options) => {
        result = tools.reply('s', { 'options': options });
    }).catch(err => {
        ctx.status = err.status || 500;
        result = err;
    });

    ctx.body = result;
});

systemOptions.post('/getOne', async (ctx) => {
    let body = ctx.request.body;

    // validate
    let bodyValidate = tools.validateObject(body, 'title');

    let result;

    if (!bodyValidate.isValid) {
        ctx.status = 412;
        result = tools.reply('f', { 'm': 'some fileds required.', 'e': bodyValidate.requires });
    }

    else {

        await service.getOption(body.title)
            .then((options) => {
                result = tools.reply('s', { 'option': options });
            }).catch(err => {
                ctx.status = err.status || 500;
                result = err;
            });

    }

    ctx.body = result;
});

systemOptions.post('/set', async (ctx) => {
    let body = ctx.request.body;

    // validate
    let bodyValidate = tools.validateObject(body, 'options');

    let result;

    if (!bodyValidate.isValid) {
        ctx.status = 412;
        result = tools.reply('f', { 'm': 'some fileds required.', 'e': bodyValidate.requires });
    }

    else {
        await service.setOptions(body.options)
            .then((operationResult) => {
                result = tools.reply('s', operationResult);
            }).catch(err => {
                ctx.status = err.status || 500;
                result = err;
            });
    }

    ctx.body = result;
});

module.exports.name = name;
module.exports.main = systemOptions;