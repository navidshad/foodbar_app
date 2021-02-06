
function createPermissions() {
  let model = global.services.contentProvider.getCollection('cms', 'permission');
  
  return new Promise(async (done, reject) => {
    
    // create customer permission
    let isAnonymousExisted = await model.countDocuments({title:'anonymous'}).exec().catch(reject);
    let isCoustomerExisted = await model.countDocuments({title:'customer'}).exec().catch(reject);
    let isAdministratorExisted = await model.countDocuments({title:'administrator'}).exec().catch(reject);
    
    if(!isAnonymousExisted) {
      await new model({
        anonymous_access: true,
        isAnonymous: true,
        title: 'anonymous',
      }).save().catch(reject);
    }
    
    if(!isCoustomerExisted) {
      await new model({
        customer_access: true,
        anonymous_access: true,
        isDefault: true,
        title: 'customer',
      }).save().catch(reject);
    }
    
    if(!isAdministratorExisted) {
      await new model({
        advanced_settings: true,
        content_producer: true,
        customer_access: true,
        anonymous_access: true,
        user_manager: true,
        title: 'administrator',
      }).save().catch(reject);
    }
    
    done();
  });
  
}

function createAdminUser() {
  let permissionModel = global.services.contentProvider.getCollection('cms', 'permission');
  let authModel = global.services.contentProvider.getCollection('cms', 'auth');
  let adminEmail = global.config.adminUser.email;
  let adminPass = global.config.adminUser.password;
  
  return new Promise(async (done, reject) => {
    let isAnonymousExisted = await authModel.countDocuments({type:'anonymous'}).exec().catch(reject);
    let isAdministratorExisted = await authModel.countDocuments({type:'user', email:adminEmail}).exec().catch(reject);
    
    let anonymousPermission = await permissionModel.findOne({title:'anonymous'}).exec().catch(reject);
    let administratorPermission = await permissionModel.findOne({title:'administrator'}).exec().catch(reject);
    
    if(!isAnonymousExisted) {
      await new authModel({
        permission: anonymousPermission._id,
        email: '',
        phone: '',
        password: '',
        type: 'anonymous',
      }).save().catch(reject);
    }
    
    if(!isAdministratorExisted) {
      await new authModel({
        permission: administratorPermission._id,
        email: adminEmail,
        password: adminPass,
        type: 'user'
      }).save().catch(reject);
    }
    
    done();
  });
}

function insertOtherNecessaryData() {
  let settingsModel = global.services.contentProvider.getCollection('cms', 'settings');
  
  return new Promise(async (done, reject) => {
    let isSettingsExisted = await settingsModel.countDocuments({}).exec();
    
    if(!isSettingsExisted) {
      await new settingsModel({
        title: global.config.title,
      }).save().catch(reject);
    }
  });
}

module.exports = {
  createPermissions,
  createAdminUser,
  insertOtherNecessaryData
};