module.exports = class DBTrigger
{
    constructor(name, db, coll, callback)
    {
        this.name = name;
        this.database = db;
        this.collection = coll;
        this.callback = callback;
    }
}