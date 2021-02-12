/*
    IDPay gatway
    https://gate.yekpay.com/Yekpay-Payment-Manual-v1.6.pdf
*/
let { Currency } = require('../../../class/getway');
let rp = require('request-promise');

function getOptions(body, yekPayUrl, origin)
{
    // add callback by origin
    if(origin) body.callback = 'http://melodyku.ir/payment/callback/yekpay';
  
    body['merchantId'] = global.config.yekPayApikey;

    let rOptions = {
        'method': 'POST',
        'uri'   : yekPayUrl,
        'body'  : body,
        // Automatically stringifies the body to JSON
        'json'  : true
    };

    return rOptions;
}

function requestPeyment(origin, mobile, fnumber, amount, currencySKU)
{
  let url = 'https://gate.yekpay.com/api/payment/request';
  
  let bodyDetail = {
    'orderNumber'     : fnumber,
    'amount'          : amount,
    'fromCurrencyCode': getCurrencyCode(currencySKU),
    'toCurrencyCode'  : getCurrencyCode(currencySKU),//getCurrencyCode((currencySKU == Currency.IRT) ? currencySKU : Currency.EUR),
    'firstName'       : '-',
    'lastName'        : '-',
    'email'           : '-',
    'mobile'          : mobile,
    'address'         : '-',
    'postalCode'      : '-',
    'country'         : '-',
    'city'            : '-',
    'description'     : 'music subscription',    
  };

  let option = getOptions(bodyDetail, url, origin);
  
  console.log(option);
  
  return rp(option);
}

function verifyPayment(authority)
{
  let url = 'https://gate.yekpay.com/api/payment/verify';
  
  let bodyDetail = {
    'authority'     : authority,  
  };

  let option = getOptions(bodyDetail, url);
  return rp(option);
}

function createSession(detail, fnumber, origin)
{
    detail.OrderNo = fnumber;
    detail.origin = origin;
  
    return new global.services.contentProvider.getCollection('user', 'yekpay_session')(detail).save();
}

function getCurrencyCode(currency)
{
  let code = {
    EUR : 978,
    IRR : 364,
    CHF : 756,
    AED : 784,
    CNY : 156,
    GBP : 826,
    JPY : 392,
    RUB : 643,
    TRY : 949,
  };
  
  let sku = currency.toUpperCase();
  
  if(sku.toLowerCase() == Currency.IRT)
    sku = 'IRR';
  
  return code[sku];
}

function getAmount(factor)
{
  let amount = factor.amount;
  
  // if currency is IRT it musb be converted to IRR
  if(factor.currency == Currency.IRT) 
    amount *= 10;
  
  return amount;
}

function getPayLinkAsync(factor, origin)
{
    let authColl = global.services.contentProvider.getCollection('cms', 'auth');
  
    return new Promise( async (done, reject) => 
    {
      let authUser = await authColl.findOne({_id: factor.refId}).exec().then();
      
      let transaction = await requestPeyment(
        origin, authUser.phone, factor._id, getAmount(factor), factor.currency).catch(reject);
      
      if(transaction.Code != 100)
         reject(transaction);
      
      let session = await createSession(transaction, factor._id, origin).catch(reject);
      
      let link = `https://gate.yekpay.com/api/payment/start/${transaction.Authority}`;
      
      done(link);
    });
}

function callback(queryParams)
{
  let sessionModel = global.services.contentProvider.getCollection('user', 'yekpay_session');
  
  return new Promise( async (done, reject) => 
  {
      if(!queryParams.authority || queryParams.success == null) {
          reject('product detail is wrong');
          return;
      }
    
      //get idpay session
      var session = await sessionModel.findOne({'Authority'  : queryParams.authority}).exec().catch(reject);

      //no session found
      if(!session) {
          console.log('payment detail has not been stored befor payment process, contact with us');
          reject('payment detail has not been stored befor payment process, contact with us');
          return;
      }
    
      // varify transaction
      let result = await verifyPayment(session.Authority)
        .catch(e => {
         console.log(e);
         done(session);
        });

      if(!result || result.Success != 1)
      {
          console.log('payment is not valid, code:', result.status);
          done(session);
          return;
      }
    
      //seccess payment
       let updateQuery = {'Authority':session.Authority};
       let update = { $set: result };
    
       await sessionModel.updateOne(updateQuery, update).exec()
       .then((r) => { 
             global.event.emit('onPaidSuccess', session.OrderNo); })
       .then(() => done(session))
       .catch(e => {
         console.log(e);
         done(session);
       });      
  });
}

module.exports = {
  verifyPayment,
  getPayLinkAsync,
  callback,
}