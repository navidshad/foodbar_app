const Schema = require('mongoose').Schema;
let { AccessDefinition, PermissionAccess, Types } = require('./../../../class/accsess_definition');
let { Currency } = require('./../../../class/getway');

let Triggers = require('./../treiggers');
let extraMethods = require('./schema_methods');

module.exports.getModels = (connection) => {
    let models = {};

    // models['language_config'] = connection.model('language_config', new Schema({
    //     code: String,
    //     direction: String,
    //     isActive: { type: Boolean, default: false },
    //     isDefault: { type: Boolean, default: false },
    //     title: String,
    //     title_en: String,    
    // }));

    // let languageStrSchema = new Schema({
    //     title: String,
    //     local_str: Object   
    // });

    // languageStrSchema.index({ title: 1 }, { unique: true });
    // models['languageStr'] = connection.model('languageStr', languageStrSchema);

    let ImageSchema = new Schema({
        type: String,
        imgStamp: String
    });

    let permissionSchema = new Schema({
        advanced_settings: { type: Boolean, default: false },
        content_producer: { type: Boolean, default: false },
        customer_access: { type: Boolean, default: false },
        anonymous_access: { type: Boolean, default: false },
        user_manager: { type: Boolean, default: false },
        isDefault: { type: Boolean, default: false },
        isAnonymous: { type: Boolean, default: false },
        title: String,
    });
    
    permissionSchema.index({ title: 1 }, { unique: true });
    models['permission'] = connection.model('permission', permissionSchema);

    let authSchema = new Schema({
        permission: { type: Schema.Types.ObjectId, ref: 'permission', required: false },
        email: String,
        phone: String,
        password: String,
        type: { type: String, default: 'user', enum: ['user', 'anonymous'] }
    });
    authSchema.index({ email: 1 }, { unique: true });
    models['auth'] = connection.model('auth', authSchema);

    let foodCategorySchema = new Schema({
        title: String,
        description: String,
        image: ImageSchema,
    });
    foodCategorySchema.index({ title: 1 }, { unique: true });
    models['foodCategory'] = connection.model('foodCategory', foodCategorySchema);

    let priceSchema = new Schema({
        price: { type: Number, required: true },
        currencyCode: { type: String, enum: Currency.getAllCodes() }
    });
    let foodSchema = new Schema({
        category: { type: Schema.Types.ObjectId, ref: 'foodCategory', required: true },
        title: String,
        subTitle: String,
        description: String,
        prices: [priceSchema],
        image: ImageSchema,
    });
    foodSchema.index({ title: 1, category: 1 }, { unique: true });
    models['food'] = connection.model('food', foodSchema);

    let tableSchema = new Schema({
        title: String,
        persons: { type: Number, default: 2 },
        count: { type: Number, default: 1 },
        type: { type: String, enum: ['Board', 'RollBand'], required: true },
        image: ImageSchema,
    });
    tableSchema.index({ title: 1 }, { unique: true });
    models['table'] = connection.model('table', tableSchema);

    let settingsSchema = new Schema({
        title: String,
        slagon: String,

        // menuLabel: String,
        // cartLabel: String,
        // reservationLabel: String,

        // mainColor: String,
        // secondColor: String,
        // disabledColor: String,
        // backlightColor: String,
        // textOnMainColor: String,
        // textOnSecondColor: String,

        menuType: { type: String, default: 'twoPage', enum: ['onePage', 'twoPage'] },

        deliveryCharges: { type: Number, default: 0 },
        totalAllowedDaysForReservation: { type: Number, default: 7 },
        timeDividedPerMitutes: { type: Number, default: 30 },
        timeToDeliveryFromNowByMinutes: { type: Number, default: 60 },
        timeToDeliveryBeforClosedResturantByMinutes: { type: Number, default: 60 },

        vertivalImage: ImageSchema,
        horizontalImage: ImageSchema,
    });
    models['settings'] = connection.model('settings', settingsSchema);

    let timeSchema = new Schema({
        houre: { type: Number, default: 0 },
        minutes: { type: Number, default: 0 },
    });

    let periodSchema = new Schema({
        from: timeSchema,
        to: timeSchema,
        //dividedPerMinutes: Number,
    });
    models['period'] = connection.model('period', periodSchema);

    let introSliderSchema = new Schema({
        title: String,
        description: String,
        image: ImageSchema,
    });
    models['introSlider'] = connection.model('introSlider', introSliderSchema);

    return models;
}

module.exports.accessDefinitions =
    [
        new AccessDefinition('cms', 'auth',
            [
                new PermissionAccess(Types.advanced_settings, { read: true, write: true }),
            ]),

        new AccessDefinition('cms', 'permission',
            [
                new PermissionAccess(Types.advanced_settings, { read: true, write: true }),
            ]),

        new AccessDefinition('cms', 'foodCategory',
            [
                new PermissionAccess(Types.content_producer, { read: true, write: true }),
                new PermissionAccess(Types.anonymous_access, { read: true, write: false })
            ]),

        new AccessDefinition('cms', 'food',
            [
                new PermissionAccess(Types.content_producer, { read: true, write: true }),
                new PermissionAccess(Types.anonymous_access, { read: true, write: false })
            ]),

        new AccessDefinition('cms', 'table',
            [
                new PermissionAccess(Types.content_producer, { read: true, write: true }),
                new PermissionAccess(Types.anonymous_access, { read: true, write: false })
            ]),

        new AccessDefinition('cms', 'settings',
            [
                new PermissionAccess(Types.advanced_settings, { read: true, write: true }),
                new PermissionAccess(Types.anonymous_access, { read: true, write: false })
            ]),

        new AccessDefinition('cms', 'introSlider',
            [
                new PermissionAccess(Types.content_producer, { read: true, write: true }),
                new PermissionAccess(Types.anonymous_access, { read: true, write: false })
            ]),

        new AccessDefinition('cms', 'period',
            [
                new PermissionAccess(Types.content_producer, { read: true, write: true }),
                new PermissionAccess(Types.anonymous_access, { read: true, write: false })
            ]),

        new AccessDefinition('cms', 'coupen',
            [
                new PermissionAccess(Types.content_producer, { read: true, write: true }),
                new PermissionAccess(Types.customer_access, { read: true, write: false })
            ]),

        // new AccessDefinition('cms', 'language_config', 
        //     [
        //         new PermissionAccess(Types.advanced_settings, { read: true, write: true }),
        //         new PermissionAccess(Types.anonymous_access, { read: true, write: false })
        //     ]),

        // new AccessDefinition('cms', 'languageStr', 
        //     [
        //         new PermissionAccess(Types.advanced_settings, { read: true, write: true }),
        //         new PermissionAccess(Types.anonymous_access, { read: true, write: false })
        //     ]),
    ];