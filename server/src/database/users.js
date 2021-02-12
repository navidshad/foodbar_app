const { CollectionDefinition, Schema, Permission, PermissionTypes, DatabaseTrigger, } = require('@modular-rest/server');

let reservedTableSchema = new Schema({
    refId: String,
    from: Date,
    to: Date,
    tableId: String,
    persons: Number,
    totalPersonOnTable: Number,
    reservedId: Number,
});

module.exports = [
    new CollectionDefinition({
        db: 'user',
        collection: 'reservedTable',
        schema: reservedTableSchema,
        permissions: [
            new Permission({
                type: PermissionTypes.user_access,
                onlyOwnData: true,
                read: true,
                write: true,
            }),
            new Permission({
                type: PermissionTypes.god_access,
                read:true,
                write: false,
            })
        ],
    }),
];