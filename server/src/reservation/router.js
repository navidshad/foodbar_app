let Router = require('koa-router');
const { reply, getCollection, validator, PermissionTypes, middleware } = require('@modular-rest/server');

let name = 'reservation';

let service = require('./service');
let reservation = new Router();

// reservation.use('/', middleware.auth, async (ctx, next) => {
//   let body = ctx.request.body;
//   // console.log(ctx.state.user);
//   let key = ctx.state.user.permission[PermissionTypes.anonymous_access];

//   // if (key == false && body.type == 'user')
//   //   key = user.hasPermission(PermissionTypes.customer_access);

//   if (key == false) ctx.throw(403, "you don't have permission");
//   else await next();
// });

function checkUserPermission(user, permissionType) {
  let key = user.permission[permissionType];
  return !!key;
}

reservation.get('/getScheduleOptions', async (ctx) => {

  let result;

  await service.getScheduleOptions()
    .then(op => result = reply('s', {
      'options': op
    }))
    .catch(err => {
      ctx.status = err.status || 500;
      result = reply('e', {
        'e': err
      });
    });

  ctx.body = result;
});

reservation.get('/getTables', async (ctx) => {
  let result;

  await service.getTables()
    .then(op => result = reply('s', {
      'tables': op
    }))
    .catch(err => {
      ctx.status = err.status || 500;
      result = reply('e', {
        'e': err
      });
    });

  ctx.body = result;
});

reservation.post('/getReservedTimes', async (ctx) => {
  let body = ctx.request.body;
  let result;

  // validate
  let bodyValidate = validator(body, 'isoDate tableId');

  if (!bodyValidate.isValid) {
    ctx.status = 412;
    ctx.body = reply('f', {
      'm': 'some fileds required.',
      'e': bodyValidate.requires
    });
    return;
  }

  await service.getReservedTimes(body.isoDate, body.tableId)
    .then(list => {
      result = reply('s', {
        'times': list
      });
    }).catch(err => {
      ctx.status = err.status || 500;
      result = reply('e', {
        'e': err
      });
    })

  ctx.body = result;
});

reservation.post('/getRemainPersons', async (ctx) => {
  let body = ctx.request.body;
  let result;

  // validate
  let bodyValidate = validator(body, 'isoDate tableId');

  if (!bodyValidate.isValid) {
    ctx.status = 412;
    ctx.body = reply('f', {
      'm': 'some fileds required.',
      'e': bodyValidate.requires
    });
    return;
  }

  await service.getRemainPersons(body.isoDate, body.tableId)
    .then(personsDetail => {
      result = reply('s', personsDetail);
    }).catch(err => {
      ctx.status = err.status || 500;
      result = reply('e', {
        'e': err
      });
    });

  ctx.body = result;
});

reservation.post('/reserveTable', middleware.auth, async (ctx) => {
  let body = ctx.request.body;
  let result;

  // validate
  let bodyValidate = validator(body, 'isoDate tableId persons');

  if (!bodyValidate.isValid) {
    ctx.status = 412;
    ctx.body = reply('f', {
      'm': 'some fields required.',
      'e': bodyValidate.requires
    });
    return;
  }

  if (!checkUserPermission(ctx.state.user, PermissionTypes.user_access)) {
    ctx.throw(403, "you don't have permission");
  }

  await service.reserve(ctx.state.user.id, body.isoDate, body.tableId, body.persons)
    .then(detail => {
      result = reply('s', detail);
    }).catch(err => {
      ctx.status = err.status || 500;
      result = reply('e', {
        'e': err
      });
    });

  ctx.body = result;
});

reservation.post('/cancel', middleware.auth, async (ctx) => {
  let body = ctx.request.body;
  let result;

  // validate
  let bodyValidate = validator(body, 'reservedId');

  if (!bodyValidate.isValid) {
    ctx.status = 412;
    ctx.body = reply('f', {
      'm': 'some fileds required.',
      'e': bodyValidate.requires
    });
    return;
  }

  if (!checkUserPermission(ctx.state.user, PermissionTypes.user_access)) {
    ctx.throw(403, "you don't have permission");
  }

  await service.cancel(body.reservedId)
    .then(() => {
      result = reply('s');
    }).catch(err => {
      ctx.status = err.status || 500;
      result = reply('e', {
        'e': err
      });
    });

  ctx.body = result;
})

module.exports.name = name;
module.exports.main = reservation;