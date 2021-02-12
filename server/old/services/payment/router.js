let Router = require('koa-router');
let tools = require('modular-rest-toolkit');
let name = 'payment';

let service = require('./service');
let {
  Currency
} = require('../../class/getway');
let middleware = require('./../../middlewares');

let payment = new Router();

payment.post('/createFactor', middleware.auth, async (ctx) => {
  let body = ctx.request.body;
  let bodyValidate = tools.validateObject(body, {
    currency: Currency.getAllasString(),
    orders: '',
  });

//   console.log(body);

  // fields validation
  if (!bodyValidate.isValid) {
    ctx.throw(412, JSON.stringify(
      tools.reply('e', {
        'e': bodyValidate.requires
      })));
  }

  // get coupen
  await service.getCoupen(body.coupen)
    // create fator
    .then(coupen => service.createFactor(body, ctx.state.user, coupen))
    // get factor paied if discount is 100%
    .then(factor => {
      if (factor.amount <= 0) {
        factor.isPaid = true;
        global.event.emit('onPaidSuccess', factor._id);
      }

      return factor;
    }) // result
    .then((factor) => {
      ctx.body = tools.reply('s', {
        'factor': factor
      });
    }) // catch error
    .catch(err => {
      ctx.status = err.status || 500;
      ctx.body = err.message || err;
    });
});

payment.get('/getways', middleware.auth, (ctx) => {
  ctx.body = tools.reply('s', {
    'getways': service.getways()
  });
});

payment.get('/getCurrencies', middleware.auth, (ctx) => {
  ctx.body = tools.reply('s', {
    'list': service.getCurrencies()
  });
});

payment.post('/getPayLink', middleware.auth, async (ctx) => {
  let body = ctx.request.body;
  let orgin = ctx.request.origin;

  orgin = orgin.replace('http:', 'https:');

  if (!orgin.includes('https'))
    orgin = 'https://melodyku.ir';

  // validate
  let bodyValidate = tools.validateObject(body, {
    'factorid': '',
    'getway': service.getways().map(gate => gate.title).join(' '),
  });

  if (!bodyValidate.isValid) {
    ctx.throw(412, JSON.stringify(
      tools.reply('e', {
        'e': bodyValidate.requires
      })));
  }

  await service.getPaylink(body.factorid, body.getway, orgin)
    .then((link) => {
      ctx.body = tools.reply('s', {
        'link': link
      });
    })
    .catch(err => {
      ctx.status = err.status || 500;
      ctx.body = err.message || err;
    });
});

payment.post('/callback/idpay', async (ctx) => {
  let body = ctx.request.body;

  await service.getway('idpay').callback(body)
    .then((r) => {
      //ctx.body = tools.reply('s');
      ctx.redirect(`/rd?factor=${body.order_id}`);
    })
    .catch(err => {
      //ctx.status = err.status || 500;
      //ctx.body = (err.message || err).toString() + '\n' + JSON.stringify(body);
      ctx.redirect(`/rd?factor=${body.order_id}`);
    });
});

payment.get('/callback/:gateTitle', async (ctx) => {
  ctx.body = 'you have to be redirected from ' + ctx.params.gateTitle + ' getway';
});

module.exports.name = name;
module.exports.main = payment;