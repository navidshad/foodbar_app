let Router = require('koa-router');
let tools = require('modular-rest-toolkit');
let name = 'reservation';

let PermissionTypes = require('./../../class/accsess_definition').Types;

let service = require('./service');
let middleware = require('./../../middlewares');
let reservation = new Router();

reservation.use('/', middleware.auth, async (ctx, next) => {
  let body = ctx.request.body;
  // console.log(ctx.state.user);
  let key = ctx.state.user.permission[PermissionTypes.archive_manager];

  if (key == false && body.type == 'user')
    key = user.hasPermission(PermissionTypes.customer_access);

  if (key == false) ctx.throw(403, "you don't have permission");
  else await next();
});

reservation.get('/getScheduleOptions', async (ctx) => {

  let result;

  await service.getScheduleOptions()
    .then(op => result = tools.reply('s', {
      'options': op
    }))
    .catch(err => {
      ctx.status = err.status || 500;
      result = tools.reply('e', {
        'e': err
      });
    });

  ctx.body = result;
});

reservation.get('/getTables', async (ctx) => {
  let result;

  await service.getTables()
    .then(op => result = tools.reply('s', {
      'tables': op
    }))
    .catch(err => {
      ctx.status = err.status || 500;
      result = tools.reply('e', {
        'e': err
      });
    });

  ctx.body = result;
});

reservation.post('/getReservedTimes', async (ctx) => {
  let body = ctx.request.body;
  let result;

  // validate
  let bodyValidate = tools.validateObject(body, 'isoDate tableId');

  if (!bodyValidate.isValid) {
    ctx.status = 412;
    ctx.body = tools.reply('f', {
      'm': 'some fileds required.',
      'e': bodyValidate.requires
    });
    return;
  }

  await service.getReservedTimes(body.isoDate, body.tableId)
    .then(list => {
      result = tools.reply('s', {
        'times': list
      });
    }).catch(err => {
      ctx.status = err.status || 500;
      result = tools.reply('e', {
        'e': err
      });
    })

  ctx.body = result;
});

reservation.post('/getRemainPersons', async (ctx) => {
  let body = ctx.request.body;
  let result;

  // validate
  let bodyValidate = tools.validateObject(body, 'isoDate tableId');

  if (!bodyValidate.isValid) {
    ctx.status = 412;
    ctx.body = tools.reply('f', {
      'm': 'some fileds required.',
      'e': bodyValidate.requires
    });
    return;
  }

  await service.getRemainPersons(body.isoDate, body.tableId)
    .then(personsDetail => {
      result = tools.reply('s', personsDetail);
    }).catch(err => {
      ctx.status = err.status || 500;
      result = tools.reply('e', {
        'e': err
      });
    });

  ctx.body = result;
});

reservation.post('/reserveTable', async (ctx) => {
  let body = ctx.request.body;
  let result;

  // validate
  let bodyValidate = tools.validateObject(body, 'isoDate tableId persons');

  if (!bodyValidate.isValid) {
    ctx.status = 412;
    ctx.body = tools.reply('f', {
      'm': 'some fileds required.',
      'e': bodyValidate.requires
    });
    return;
  }

  await service.reserve(ctx.state.user.id, body.isoDate, body.tableId, body.persons)
    .then(detail => {
      result = tools.reply('s', detail);
    }).catch(err => {
      ctx.status = err.status || 500;
      result = tools.reply('e', {
        'e': err
      });
    });

  ctx.body = result;
});

reservation.post('/cancel', async (ctx) => {
  let body = ctx.request.body;
  let result;

  // validate
  let bodyValidate = tools.validateObject(body, 'reservedId');

  if (!bodyValidate.isValid) {
    ctx.status = 412;
    ctx.body = tools.reply('f', {
      'm': 'some fileds required.',
      'e': bodyValidate.requires
    });
    return;
  }
  
  await service.cancel(body.reservedId)
    .then(() => {
      result = tools.reply('s');
    }).catch(err => {
      ctx.status = err.status || 500;
      result = tools.reply('e', {
        'e': err
      });
    });

  ctx.body = result;
})

module.exports.name = name;
module.exports.main = reservation;