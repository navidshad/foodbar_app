module.exports = class ComponentCollection
{
    constructor(dbName, collName, schema, accessDefinitions)
    {
        // string
        this.database = dbName;
        // string
        this.collection = collName;
        // schema object of mongoose
        this.schema = schema;
        // array of accessDefinitions class
        this.accessDefinitions = accessDefinitions;
    }
}