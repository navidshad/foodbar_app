let {
  Gate,
  Currency
} = require('../../class/getway');
let idpay = require('./getways/idpay');
let yekpay = require('./getways/yekpay');

let _gates = [
  new Gate({
    title: 'idpay',
    currencies: [Currency.IRT],
    getPayLinkAsync: idpay.getPayLinkAsync,
    callback: idpay.callback,
  }),

  new Gate({
    title: 'yekpay',
    currencies: Currency.getAllCodes(),
    getPayLinkAsync: yekpay.getPayLinkAsync,
    callback: yekpay.callback,
  }),
]

function getCurrencies() {
  return Currency.getAll();
}

function getways() {
  let gewaysList = [];
  _gates.forEach(gate =>
    gewaysList.push({
      'title': gate.title,
      'currencies': gate.currencies
    }));

  return gewaysList;
}

function getway(title) {
  let temp;
  _gates.forEach(gate => {
    if (gate.title == title)
      temp = gate;
  });

  return temp;
}

function getPaylink(factorid, gateTitle, orgin) {
  let gate = getway(gateTitle);
  let getPayLinkAsync = gate.getPayLinkAsync;

  return new Promise(async (done, reject) => {
    let factorModel = global.services.contentProvider.getCollection('user', 'factor');
    let factor = await factorModel.findOne({
      _id: factorid,
      isPaid: false
    }).exec().catch(reject);

    if (!factor) {
      reject('factor not found');
      return;
    } else if (gate.currencies.indexOf(factor.currency) < 0) {
      reject(`the currency of the factor is not match to the getway | factor ${factor.currency} , gate ${gate.currencies}, ${gate.currencies.indexOf(factor.currency)}`);
      return;
    } else if (!getPayLinkAsync) {
      reject('getway not found');
      return;
    }

    getPayLinkAsync(factor, orgin).then(done).catch(reject);
  });
}

function getAmount(list = []) {
  let amount = 0;
  list.forEach(item => amount += item.price);
  return amount;
}

async function getNewFnumber() {
  let factorCouner = global.services.contentProvider.getCollection('user', 'factor_counter');
  let doc = await factorCouner.findOne({}).exec().then();

  if (doc) {
    doc.last++;
    await doc.save().then();
  } else {
    doc = await new factorCouner({
      'last': 100
    }).save().then();
  }
  //console.log('fnumber',doc);
  return doc.last;
}

function createFactor(factorDetail, user, coupen) {
  return new Promise(async (done, reject) => {
    let coupenModel = global.services.contentProvider.getCollection('cms', 'coupen');
    let factorModel = global.services.contentProvider.getCollection('user', 'factor');

    let orders = factorDetail.orders;
    let currency = factorDetail.currency;
    let otherCosts = factorDetail.otherCosts || [];

    let fnumber = await getNewFnumber();

    let factor = new factorModel({
      '_id': fnumber,
      'refId': user.id.toString(),
      'amount': getAmount(orders) + getAmount(otherCosts),
      'currency': currency,
      'orders': orders,
      'otherCosts': otherCosts,
    });

    if (coupen && coupen.discount_percent > 0) {
      let unit = factor.amount / 100;
      let subtract = unit * coupen.discount_percent;
      factor.amount -= subtract;
      factor.discount = coupen.discount_percent;
      factor.coupenId = coupen._id;

      coupenModel.updateOne({
        _id: coupen._id
      }, {
        $inc: {
          total: -1
        }
      }).exec();
    }

    factor.save()
      .then(done).catch(reject);

  });
}

function getCoupen(code) {
  let coll = global.services.contentProvider.getCollection('cms', 'coupen');
  return coll.findOne({
    'code': code
  }).exec()
    .then(coupen => {
      console.log('coupen', coupen);
      return coupen;
    });
}
module.exports = {
  getways,
  getway,
  getPaylink,
  createFactor,
  getCoupen,
  getCurrencies
}