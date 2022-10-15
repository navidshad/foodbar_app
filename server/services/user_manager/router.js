let Router = require('koa-router');
let {reply, validateObject} = require('modular-rest-toolkit');

let name = 'user';
let userManager = new Router();

let service = require('./service').main;

userManager.post('/register_submit_id', async (ctx) => 
{
	let body = ctx.request.body;

	let validateOption = {
		id: '',
		idType: 'phone email'
	};

	// validate result
	let bodyValidate = validateObject(body, validateOption);

	// fields validation
  	if(!bodyValidate.isValid)
	{	
		ctx.status = 412;
		ctx.body = reply('e', {'e': bodyValidate.requires});
		return;
	}
	
	let serial;
	
	await global.services.sender.sendVarificationCode(body.idType, body.id)
		.then(code => serial = code)
		.catch(err => ctx.throw(err.status || 500, err));

	if(serial) service.registerTemporaryID(body.id, body.idType, serial);

	ctx.body = reply('s');
});

userManager.post('/validateCode', async (ctx) => 
{
	let body = ctx.request.body;

	// validate result
	let bodyValidate = validateObject(body, 'id serial');

	// fields validation
  if(!bodyValidate.isValid)
  {	
  	ctx.status = 412;
    ctx.body = reply('e', {'e': bodyValidate.requires});
    return;
  }

  let isValid = service.isSerialValid(body.id, body.serial);

  if(!isValid)
  {	
  	ctx.status = 412;
    ctx.body = reply('e', {'e': 'Varification code is wrong'});
    return;
  }

  ctx.body = reply('s', {'isValid': isValid} );
});

userManager.post('/register_submit_pass', async (ctx) => 
{
	let body = ctx.request.body;

	// validate result
	let bodyValidate = validateObject(body, 'id password serial');

	// fields validation
  if(!bodyValidate.isValid)
  {	
  	ctx.status = 412;
    ctx.body = reply('e', {'e': bodyValidate.requires});
    return;
  }

  let registerResult = await service
  	.submitePasswordForTemporaryID(body.id, body.password, body.serial).then();

  if(registerResult == true) ctx.body = reply('s');
  else {
    ctx.status = 412;
    ctx.body = reply('f');
  }
});

userManager.post('/change_pass', async (ctx) => 
{
	let body = ctx.request.body;

	// validate result
	let bodyValidate = validateObject(body, 'id password serial');

	// fields validation
	if(!bodyValidate.isValid)
	{	
		ctx.status = 412;
		ctx.body = reply('e', {'e': bodyValidate.requires});
		return;
	}

	let registerResult = await service
		.changePasswordForTemporaryID(body.id, body.password, body.serial).then();

	if(registerResult == true) ctx.body = reply('s');
	else {
		ctx.status = 412;
		ctx.body = reply('f');
	}
});

userManager.post('/login', async (ctx) => 
{
	let body = ctx.request.body;
	
	let validateOption = {
		id: '',
		password: '',
		idType: 'phone email'
	}

	// validate result
	let bodyValidate = validateObject(body, validateOption);

	// fields validation
    if(!bodyValidate.isValid)
    {	
    	ctx.status = 412;
        ctx.body = reply('e', {'e': bodyValidate.requires});
        return;
    }

    await service.loginUser(body.id, body.idType, body.password)
    	.then((token) => ctx.body = reply('s', {'token': token}))
    	.catch(err => {
    		ctx.status = 412;
        	ctx.body = reply('e', {'e': err});
    	});
});

userManager.get('/loginAnonymous', async (ctx) => 
{
    await service.loginAnonymous()
        .then((token) => ctx.body = reply('s', {'token': token}))
        .catch(err => {
            ctx.status = 412;
            ctx.body = reply('e', {'e': err});
        });
});

userManager.post('/getPermission', async (ctx) => 
{	
	let body = ctx.request.body;

	// validate result
	let bodyValidate = validateObject(body, 'id');

	// fields validation
    if(!bodyValidate.isValid)
    {	
    	ctx.status = 412;
        ctx.body = reply('e', {'e': bodyValidate.requires});
        return;
	}
	
	let query = {_id: body.id};

	let permission = await global.services.contentProvider.getCollection('cms', 'permission')
		.findOne(query)
		.catch(err => {
            ctx.status = 412;
            ctx.body = reply('e', {'e': err});
        });

	ctx.body = reply('s', {'permission': permission});
});

module.exports.name = name;
module.exports.main = userManager;