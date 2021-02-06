var mongoose = require('mongoose');
var Schema = mongoose.Schema;

let ComponentCollection = require('../../class/component_collection');
let { Currency } = require('../../class/getway');

let factorCounter = new Schema({
    'last':  { type: Number, defualt: 100 },
});

let orderSchema = new Schema({
    refId: String,
    title: String,
    description: String,
    price: {type: Number, required: true},
});

let factorSchema = new Schema(
    {
        _id: Number,
        isPaid: { type: Boolean, default: false },
        refId: String,
        orders: [orderSchema],
        otherCosts: [orderSchema],
        amount: {type: Number, required: true},
        currency: {type: String, default: Currency.IRT, enum: Currency.getAllCodes()},        
        discount: {type: Number, default: 0},
        coupenId: String,
    }, 
    { timestamps: true }
);

let idpaySchema = new Schema({
    status      : Number,
    track_id    : Number,
    id          : String,
    order_id    : String,
    Date        : Date,
    link        : String,
});

let yekPaySchema = new Schema({
    OrderNo     : String,
    Authority   : Number,
    Code        : Number,
    Success     : Number,
    Description : String,
    Reference   : String,
    Tracking    : String,
    Gateway     : String,
    Amount      : String,
    origin      : String,
});

function createCurrenciesSchemaFromCurrencyClass()
{
  let base = {}  ;
  
  Currency.getAllCodes().forEach(cur => 
  {
    
    base[cur] = new Schema({
      isActive: { type: Boolean, default: false },
      price: { type: Number, default: 1000 },
    });
    
  });
  
  return new Schema(base);
}
    
let coupenSchema = new Schema({
  title       : { type: String, required: true },
  code        : { type: String, required: true },
  total       : { type: Number, default: 100 },
  discount_percent : { type: Number, default: 20 },
  isUnlimited : { type: Boolean, default: false },
});
  
coupenSchema.index({ code: 1}, { unique: true });



module.exports.coupen = new ComponentCollection('cms', 'coupen', coupenSchema);
module.exports.factor = new ComponentCollection('user', 'factor', factorSchema);
module.exports.factor_counter = new ComponentCollection('user', 'factor_counter', factorCounter);

// module.exports.idpay_session  = new ComponentCollection('user', 'idpay_session', idpaySchema);
// module.exports.yekpay_session = new ComponentCollection('user', 'yekpay_session', yekPaySchema);