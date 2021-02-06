/*
    IDPay gatway
    help: https://idpay.ir/web-service/v1.1/index.html?javascript#cee8b80267
*/

let rp = require('request-promise');

function getOptions(body, idPayUrl, orgin)
{
    //let port = global.config.serverport;

    // if(port != 80)
    //     body.callback = global.config.domain + ':' + port + '/getway/callback/idpay';
    // else body.callback = global.config.domain + '/getway/callback/idpay';

    if(orgin) body.callback = orgin + '/payment/callback/idpay';

    let rOptions = {
        method: 'POST',
        uri: idPayUrl,
        headers: {
            'Content-Type': 'application/json',
            'X-API-KEY': 'x',
            'X-SANDBOX': 0,
        },
        'body': body,
        // Automatically stringifies the body to JSON
        json: true
    };

    // get idpay module detail
    rOptions.headers["X-API-KEY"] = global.config.idPayApikey;

    return rOptions;
}

async function createTransaction(orgin, userid, fnumber, amount)
{
    let url = 'https://api.idpay.ir/v1.1/payment';
    let body = {
        'order_id': fnumber,
        'amount': amount,
        'name': userid,
    };

    let option = getOptions(body, url, orgin);
    return rp(option);
}

async function verifyTransaction(id, order_id)
{
    let url = 'https://api.idpay.ir/v1.1/payment/verify';
    let body = {
        'id': id,
        'order_id': order_id,
    };

    let option = getOptions(body, url);

    return rp(option);
}

async function getTransaction(id, fnumber)
{
    let url = 'https://api.idpay.ir/v1.1/payment/inquiry';
    let body = {
        'id': id,
        'order_id': fnumber,
    };

    let option = getOptions(body, url);

    return rp(option).catch((error) => { console.log('idpay error', error); });
}

function createSession(detail, fnumber)
{
    detail.order_id = fnumber;
    return new global.services.contentProvider.getCollection('user', 'idpay_session')(detail).save();
}

function getPayLinkAsync(factor, orgin)
{
    return new Promise( async (done, reject) => 
    {
      console.log('factor', factor);
      let transaction = await createTransaction(orgin, factor.refId, factor._id, factor.amount * 10).catch(reject);
      
      if(!transaction)
         return;
      
      let session = await createSession(transaction, factor._id).catch(reject);
      
      done(transaction.link);
    });
}

function callback(body)
{
  let sessionModel = global.services.contentProvider.getCollection('user', 'idpay_session');
  
  return new Promise( async (done, reject) => 
  {
      if(!body.status || !body.track_id) {
          reject('product detail is wrong');
          return;
      }
    
      //get idpay session
      var session = await sessionModel.findOne({'id'  : body.id}).exec().catch(reject);

      //no session found
      if(!session) {
          reject('payment detail has not been stored befor payment process, contact with us');
          return;
      }
    
      // varify transaction
      let result = await verifyTransaction(body.id, body.order_id).catch(reject);

      if(!result || result.status != 100)
      {
          reject('payment is not valid, code:', result.status);
          return;
      }
    
      //seccess payment
      // let updateQuery = {'_id':body.order_id};
      // let update = { $set: { isPaid: true } };
      // factorModel.updateOne(updateQuery, update).exec().then(done).catch(reject);
      
      global.event.emit('onPaidSuccess', body.order_id);
      done();
  });
}
module.exports = {
    createTransaction,
    verifyTransaction,
    getTransaction,
    getPayLinkAsync,
    callback,
}
