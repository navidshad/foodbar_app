let validateObject = require('modular-rest-toolkit').validateObject;

module.exports = class User {

    constructor(id, permission, phone, email, password, type, model)
    {
        this.id         = id;
        this.permission = permission;
        this.email      = email;
        this.phone      = phone;
        this.password   = password;
        this.type       = type;
        this.dbModel    = model;
    }

    getBrief()
    {
        let brief = {
            id : this.id,
            permission : this.permission,
            phone : this.phone, 
            email : this.email,
            type  : this.type,
        }

        return brief;
    }

    updateDetail(detail)
    {
        if(detail.phone)    this.phone      = detail.phone;
        if(detail.email)    this.email      = detail.email;
        if(detail.password) this.password   = detail.password;
    }

    hasPermission(permissionField)
    {
        let key = false;

        if(this.permission[permissionField] == null)
            return key;

        key = this.permission[permissionField];
        return key;
    }

    async save()
    {
        this.mode['permission'] =  this.permission;
        this.mode['phone']      =  this.phone;
        this.mode['email']      =  this.email;
        this.mode['password']   =  this.password;

        await mode.save();
    }

    static loadFromModel(model)
    {
        return new Promise((done, reject) => 
        {
            // check required fields
            let isValidData = validateObject(model, 'fullname email password permission');
            if(!isValidData) 
                reject(User.notValid(detail));

            let id         = model.id;
            let permission = model.permission; 
            let phone      = model.phone;
            let email      = model.email;
            let password   = model.password;
            let type       = model.type; 

            //create user
            let newUser = new User(id, permission, phone, email, password, type, model);
            done(newUser);
        });
    }

    static createFromModel(model, detail)
    {
        return new Promise( async (done, reject) => 
        {
            //create user
            await new model(detail).save()
                .then(newUser => 
                    done(User.loadFromModel(newUser)))
                .catch(reject);
        });
    }

    static notValid(object)
    {
        let error = `user detail are not valid ${object}`;
        console.error(error);
        return error;
    }
}
