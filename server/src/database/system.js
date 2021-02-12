const { CollectionDefinition, Schema, Permission, PermissionTypes, DatabaseTrigger, } = require('@modular-rest/server');

let foodCategorySchema = new Schema({
    title: String,
    description: String,
    image: ImageSchema,
});
foodCategorySchema.index({ title: 1 }, { unique: true });


let foodSchema = new Schema({
    category: { type: Schema.Types.ObjectId, ref: 'foodCategory', required: true },
    title: String,
    subTitle: String,
    description: String,
    price: Number,
    image: ImageSchema,
});
foodSchema.index({ title: 1, category: 1 }, { unique: true });

let tableSchema = new Schema({
    title: String,
    persons: { type: Number, default: 2 },
    count: { type: Number, default: 1 },
    type: { type: String, enum: ['Board', 'RollBand'], required: true },
    image: ImageSchema,
});
tableSchema.index({ title: 1 }, { unique: true });

let settingsSchema = new Schema({
    title: String,
    slagon: String,

    menuType: { type: String, default: 'twoPage', enum: ['onePage', 'twoPage'] },

    deliveryCharges: { type: Number, default: 0 },
    totalAllowedDaysForReservation: { type: Number, default: 7 },
    timeDividedPerMitutes: { type: Number, default: 30 },
    timeToDeliveryFromNowByMinutes: { type: Number, default: 60 },
    timeToDeliveryBeforClosedResturantByMinutes: { type: Number, default: 60 },
});

let timeSchema = new Schema({
    houre: { type: Number, default: 0 },
    minutes: { type: Number, default: 0 },
});

let periodSchema = new Schema({
    from: timeSchema,
    to: timeSchema,
    //dividedPerMinutes: Number,
});

let introSliderSchema = new Schema({
    title: String,
    description: String,
    image: ImageSchema,
});
models['introSlider'] = connection.model('introSlider', introSliderSchema);

module.exports = [
    new CollectionDefinition({
        db: 'cms',
        collection: 'foodCategory',
        schema: foodCategorySchema,
        permissions: [
            new Permission({
                type: PermissionTypes.god_access,
                read: true,
                write: true,
            }),
            new Permission({
                type: PermissionTypes.anonymous_access,
                read:true,
                write: false,
            })
        ],
    }),

    new CollectionDefinition({
        db: 'cms',
        collection: 'food',
        schema: foodSchema,
        permissions: [
            new Permission({
                type: PermissionTypes.god_access,
                read: true,
                write: true,
            }),
            new Permission({
                type: PermissionTypes.anonymous_access,
                read:true,
                write: false,
            })
        ],
    }),

    new CollectionDefinition({
        db: 'cms',
        collection: 'table',
        schema: tableSchema,
        permissions: [
            new Permission({
                type: PermissionTypes.god_access,
                read: true,
                write: true,
            }),
            new Permission({
                type: PermissionTypes.anonymous_access,
                read:true,
                write: false,
            })
        ],
    }),

    new CollectionDefinition({
        db: 'cms',
        collection: 'settings',
        schema: settingsSchema,
        permissions: [
            new Permission({
                type: PermissionTypes.god_access,
                read: true,
                write: true,
            }),
            new Permission({
                type: PermissionTypes.anonymous_access,
                read:true,
                write: false,
            })
        ],
    }),

    new CollectionDefinition({
        db: 'cms',
        collection: 'period',
        schema: periodSchema,
        permissions: [
            new Permission({
                type: PermissionTypes.god_access,
                read: true,
                write: true,
            }),
            new Permission({
                type: PermissionTypes.anonymous_access,
                read:true,
                write: false,
            })
        ],
    }),

    new CollectionDefinition({
        db: 'cms',
        collection: 'introSlider',
        schema: introSliderSchema,
        permissions: [
            new Permission({
                type: PermissionTypes.god_access,
                read: true,
                write: true,
            }),
            new Permission({
                type: PermissionTypes.anonymous_access,
                read:true,
                write: false,
            })
        ],
    }),
];