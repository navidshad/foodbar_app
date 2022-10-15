let name = 'contentProvider';
var colog = require('colog');
let opTypes = require('./../../class/accsess_definition').opTypes;

const Mongoose = require('mongoose');
// Mongoose.set('useCreateIndex', true);

let list_dbs = [{
        name: 'cms',
        path: './database/cms.js'
    },
    {
        name: 'user',
        path: './database/user.js'
    },
];

let connections = {};
let collections = {};
let Accessdefinitions = {};

let triggers = require('./treiggers');
let TypeCasters = require('./typeCasters');

function connect() {
    for (let i = 0; i < list_dbs.length; i++) {
        const dbmodule = list_dbs[i];
        let prefix = global.config.db_prefix;
        let name = dbmodule.name;

        let databaseDetail = require(dbmodule['path']);

        // conecting to database
        //
        let connectionString = global.config.mongoUrl + `/${prefix + name}`;
        let connection = Mongoose.createConnection(
            connectionString,
            global.config.mongoOption,
        );

        connection.on('connected', () => colog.info(`- ${prefix + name} database has been connected`));

        // get models
        collections[name] = databaseDetail.getModels(connection);

        // store connection
        connections[name] = connection;

        // get Access Definitions
        Accessdefinitions[name] = databaseDetail.accessDefinitions;
    }
}

function addComponentCollection(cc) {
    // cc is an instance of ComponentCollection class
    let newModel = connections[cc.database].model(cc.collection, cc.schema);
    collections[cc.database][cc.collection] = newModel;
}

function getCollection(db, collname) {
    let collection;
    // let prefix = global.config.db_prefix;
    // let dbNameWithPrefix = prefix + db;

    if (collections.hasOwnProperty(db)) {
        if (collections[db].hasOwnProperty(collname))
            collection = collections[db][collname];
    }

    return collection;
}

function _getPermissionAccessList(db, collname, operationType) {
    let permissionAccessList = [];
    let AD;

    if (!Accessdefinitions.hasOwnProperty(db))
        return permissionAccessList;

    Accessdefinitions[db].forEach(accessDefinitions => {
        if (accessDefinitions.collection == collname)
            AD = accessDefinitions;
    })

    if (AD) {
        AD.permissionAccessList.forEach(permissionAccess => {
            if (permissionAccess.onlyOwnData == true) {
                permissionAccessList.push(permissionAccess);
            } else if (operationType == opTypes.read &&
                permissionAccess.read == true) {
                permissionAccessList.push(permissionAccess);
            } else if (operationType == opTypes.write &&
                permissionAccess.write == true) {
                permissionAccessList.push(permissionAccess);
            }
        });
    }

    return permissionAccessList;
}

function checkAccess(db, collname, operationType, queryOrDoc, user) {
    let key = false;
    let permissionAccessList = _getPermissionAccessList(db, collname, operationType);

    permissionAccessList.forEach(permissionAccess => {
        let permissionField = permissionAccess.name;

        if (permissionAccess.onlyOwnData) {
            let refId = queryOrDoc.refId;
            let userId = user.id;

            try {
                if (refId.toString() == userId.toString())
                    key = true;
            } catch (error) {
                key = false;
            }
        } else if (operationType == opTypes.read) {
            if (permissionAccess.read &&
                user.permission[permissionField] == true)
                key = true;
        } else if (operationType == opTypes.write) {

            if (permissionAccess.write &&
                user.permission[permissionField] == true)
                key = true;
        }
    });

    return key;
}

function getAsID(strId) {
    let id;
    try {
        id = Mongoose.Types.ObjectId(strId);
    } catch (e) {
        console.log('strId did not cast objectId', e);
    }

    return id;
}

connect();

module.exports = {
    name,
    addComponentCollection,
    getCollection,
    checkAccess,
    getAsID,
    triggers,
    TypeCasters,
}