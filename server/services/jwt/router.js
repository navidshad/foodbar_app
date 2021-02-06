let Router = require('koa-router');
let {reply, validateObject} = require('modular-rest-toolkit');

let name = 'varify';
let varify = new Router();

let service = require('./service').main;

varify.post('/token', async (ctx) => 
{
	let body = ctx.request.body;

	// validate result
	let bodyValidate = validateObject(body, 'token');

	// fields validation
    if(!bodyValidate.isValid)
    {	
    	ctx.status = 412;
        ctx.body = reply('e', {'e': bodyValidate.requires});
        return;
    }

	await service.verify(body.token)
    	.then((payload) => ctx.body = reply('s', {'peyload': payload}))
    	.catch(err => {
    		ctx.status = 412;
        	ctx.body = reply('e', {'e': err});
    	});
});

varify.post('/checkAccess', async (ctx) => 
{
	let body = ctx.request.body;

	// validate result
	let bodyValidate = validateObject(body, 'token permissionField');

	// fields validation
    if(!bodyValidate.isValid)
    {	
    	ctx.status = 412;
        ctx.body = reply('e', {'e': bodyValidate.requires});
        return;
	}
	
	let payload = await service.verify(body.token)
		.catch(err => {
            console.log(err);
            ctx.throw(412, err.message);
        });
    	
		
	let userid = payload.id;
	
	await global.services.userManager.main.getUserById(userid)
		.then((user) => 
		{
			let key = user.hasPermission(body.permissionField);
			ctx.body = reply('s', {'access': key});
		})
		.catch(err => {
			ctx.status = 412;
			ctx.body = reply('e', {'e': err});
		});
});

module.exports.name = name;
module.exports.main = varify;