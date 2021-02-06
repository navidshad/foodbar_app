module.exports.AccessDefinition = class AccessDefinition
{
    constructor(database, collection, permissionAccessList)
    {
        this.database = database;
        this.collection = collection;
        this.permissionAccessList = permissionAccessList;
    }
}

module.exports.PermissionAccess = class PermissionAccess
{
    constructor(name, options)
    {
        this.name = name;
        this.read = options.read;
        this.write = options.write;
        // if true users can perform CRUD on documents that they created already.
        this.onlyOwnData = options.onlyOwnData;
    }
}

module.exports.Types = class Types
{
    static get customer_access    () { return 'customer_access' };
    static get anonymous_access   () { return 'anonymous_access' };
    static get advanced_settings  () { return 'advanced_settings' };
    static get content_producer   () { return 'content_producer' };
    static get user_manager       () { return 'user_manager' };
}

module.exports.opTypes = class operationTypes 
{
    static get read() { return 'read' };
    static get write() { return 'write' };
}