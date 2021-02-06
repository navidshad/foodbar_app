const Schema = require('mongoose').Schema;
let {AccessDefinition, PermissionAccess, Types} = require('./../../../class/accsess_definition');

let Triggers = require('./../treiggers');
let extraMethods = require('./schema_methods');

module.exports.getModels = (connection) => 
{
    let models = {};

    let detailSchema = new Schema({
        fullname: String,
        imgStamp: String,
        refId: String,
    });
    detailSchema.index({ refId: 1 }, { unique: true });
    detailSchema.method('toJson', function () {
        return extraMethods.toJson(this, []);
    });
    models['detail'] = connection.model('detail', detailSchema);

//     let orderedFood = new Schema({
//         category: Object,
//         title: String,
//         subTitle: String,
//         description: String,
//         imageUrl: String,
//         price: Number,
//         total: Number,
//     });

//     let orderSchema = new Schema({
//         foods: [orderedFood],
//         deliveryCharges: Number,
//         refId: String,
//         date: Date,
//     });
//     //orderSchema.index({ refId: 1 }, { unique: true });
//     orderSchema.method('toJson', function () {
//         return extraMethods.toJson(this, []);
//     });
//     models['order'] = connection.model('order', orderSchema);

    let reservedTableSchema = new Schema({
        refId: String,
        from: Date,
        to: Date,
        tableId: String,
        persons: Number,
        totalPersonOnTable: Number,
        reservedId: Number,
    });
    //reservedTableSchema.index({from:1, to:1}, {unique: true});
    reservedTableSchema.method('toJson', function () {
        return extraMethods.toJson(this, []);
    });
    models['reservedTable'] = connection.model('reservedTable', reservedTableSchema);
    
    return models;
}

module.exports.accessDefinitions = 
[
    new AccessDefinition('user', 'detail', 
        [
            new PermissionAccess(Types.customer_access, { read: true, write: true, onlyOwnData: true}),
            new PermissionAccess(Types.user_manager,    { read: true, write: true}),
        ]),

    new AccessDefinition('user', 'factor', 
        [
            new PermissionAccess(Types.customer_access, { read: true, write: true, onlyOwnData: true}),
            new PermissionAccess(Types.user_manager,    { read: true, write: true}),
        ]),

    new AccessDefinition('user', 'reservedTable', 
        [
            new PermissionAccess(Types.customer_access, { read: true, write: true, onlyOwnData: true}),
            new PermissionAccess(Types.user_manager,    { read: true, write: true}),
        ]),
];