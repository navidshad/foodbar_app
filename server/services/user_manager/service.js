let User = require('../../class/user');

class UserManager {

    constructor() {
        this.tempIds = {};
    }

    getUserById(id) {
        return new Promise(async (done, reject) => {
            let userModel = global.services.contentProvider.getCollection('cms', 'auth');

            let userDoc = await userModel.findOne({ '_id': id }).select({ password: 0 })
                .populate('permission').exec().catch(reject);

            if (!userDoc) reject('user not found');

            let user = User.loadFromModel(userDoc);
            done(user);
        })
    }

    getUserByToken(token) {
        return global.services.jwt.main.verify(token)
            .then(async payload => {
                let user = payload;
                let permission = await global.services.contentProvider.getCollection('cms', 'permission')
                    .findOne({ _id: user.permission }).exec().then();

                if (!permission) throw ('user has a wrong permission');

                user.permission = permission;
                return user;
            });
    }

    isSerialValid(id, serial)
    {
         let key = false;
         
         if(this.tempIds.hasOwnProperty(id) && this.tempIds[id].serial == serial)
              key = true;
         
         return key;
    }

    loginUser(id = '', idType = '', password = '') {
        let token;

        return new Promise(async (done, reject) => {
            //findUser
            let userModel = global.services.contentProvider.getCollection('cms', 'auth');

            let query = { 'password': password };

            if (idType == 'phone') query['phone'] = id;
            else if (idType == 'email') query['email'] = id;

            let gottenFromDB = await userModel
                .findOne(query).populate('permission')
                .exec().then().catch(reject);

            if (!gottenFromDB) reject('user not found');
            else {
                // load to object
                let user = await User.loadFromModel(gottenFromDB)
                    .then().catch(reject);

                // generate json web token
                let payload = user.getBrief();

                token = await global.services['jwt'].main.sign(payload)
                    .then().catch(reject);

                // return
                done(token);
            }
        });
    }

    loginAnonymous() {
        let token;

        return new Promise(async (done, reject) => {
            //findUser
            let userModel = global.services.contentProvider.getCollection('cms', 'auth');

            let query = { 'type': 'anonymous' };

            let gottenFromDB = await userModel
                .findOne(query).populate('permission')
                .exec().then().catch(reject);

            if (!gottenFromDB) {
                let newUserId = await this.registerUser({ 'type': 'anonymous' }).catch(reject);
                gottenFromDB = await this.getUserById(newUserId).catch(reject);
            }

            // load to object
            let user = await User.loadFromModel(gottenFromDB)
                .then().catch(reject);

            // generate json web token
            let payload = user.getBrief();

            token = await global.services['jwt'].main.sign(payload)
                .then().catch(reject);

            // return
            done(token);
        });
    }

    registerTemporaryID(id, type, serial) {
        // id is username or phone number
        // type is the type of id
        // serial is a string being sent to user and he must return it back.
        this.tempIds[id] = { 'id': id, 'type': type, 'serial': serial };
    }

    async submitePasswordForTemporaryID(id, password, serial) {
        let key = false;

        if (this.tempIds.hasOwnProperty(id)
            && this.tempIds[id].serial == serial) {
            let authDetail = { 'password': password };

            if (this.tempIds[id].type == 'phone')
                authDetail['phone'] = id;
            else if (this.tempIds[id].type == 'email')
                authDetail['email'] = id;

            await this.registerUser(authDetail)
                .then(() => key = true)
                .catch((e) => console.log(e));
        }

        delete this.tempIds[id];
        return key;
    }

    async changePasswordForTemporaryID(id, password, serial) {
        let key = false;

        if (this.tempIds.hasOwnProperty(id)
            && this.tempIds[id].serial == serial) {
            let query = {};

            if (this.tempIds[id].type == 'phone')
                query['phone'] = id;
            else if (this.tempIds[id].type == 'email')
                query['email'] = id;

            await this.changePassword(query, password)
                .then(() => key = true)
                .catch((e) => console.log(e));
        }

        delete this.tempIds[id];
        return key;
    }

    registerUser(detail) {
        return new Promise(async (done, reject) => {
            // get default permission
            let permissionId;
            let perM = global.services.contentProvider.getCollection('cms', 'permission');

            let pQuery = { isDefault: true };

            if (detail.type == 'anonymous')
                pQuery = { isAnonymous: true };

            await perM.findOne(pQuery, '_id').exec()
                .then((doc) => permissionId = doc._id)
                .catch(reject);

            detail.permission = permissionId;

            let authM = global.services.contentProvider.getCollection('cms', 'auth');
            return User.createFromModel(authM, detail)
                .then(newUser => {
                    global.services.contentProvider.triggers
                        .call('insertOne', 'cms', 'auth', { 'input': detail, 'output': newUser.dbModel });

                    done(newUser.id);
                })
                .catch(reject);
        });
    }

    changePassword(query, newPass) {
        let update = { '$set': { 'password': newPass } };
        let authM = global.services.contentProvider.getCollection('cms', 'auth');
        return authM.updateOne(query, update).exec().then();
    }
}

module.exports.name = 'userManager';
module.exports.main = new UserManager();