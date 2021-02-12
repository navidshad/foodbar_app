let fs = require('file-system');

function getCollction(type, db = "media") {
  let coll;

  coll = global.services.contentProvider.getCollection(db, type);

  return coll;
}

function updateTimeStamp(db, type, id, time, fileType) {
  //let objectid = global.services.stitch.objectId(id);
  let coll = getCollction(type, db);

  let update = {
    $set: {
      image: {
        imgStamp: time,
        type: fileType,
      }
    }
  };

  let query = { _id: id };

  if (db == 'user' && type == 'detail')
    query = { refId: id };

  return coll.updateOne(query, update)
    .then((r) => { return time; });
}

function createFilePath(dir, id, time, fileType) {
  let pathModule = require('path');
  let fileFormat = fileType.split('/')[1];
  let fileName = `${id}-${time}.${fileFormat}`;
  let filePath = pathModule.join(dir, fileName);

  return filePath;
}

function createDirectoryPath(db, collection) {
  let pathModule = require('path');
  let directory = pathModule.join(global.config.uploadPath, `${db}-${collection}`);
  return directory;
}

function removeOldImage(db, type, id, dir) {
  //let objectid = global.services.stitch.objectId(id);
  let coll = getCollction(type, db);

  let query = { _id: id };
  if (type == 'user') query = { refId: id };

  return coll.findOne(query)
    .then(async doc => {
      let oldTime = doc.image.imgStamp;
      let fileType = doc.image.type;
      let destPath = createFilePath(dir, id, oldTime, fileType);
      //console.log('remove', destPath, oldTime, doc['imgStamp'], doc);
      fs.fs.unlinkSync(destPath);
    });
}

function storePhoto(db, collection, id, file) {
  return new Promise(async (done, reject) => {
    // create directory path
    let dir = createDirectoryPath(db, collection);

    // delete if exists
    await removeOldImage(db, collection, id, dir).catch(reject);

    let time = new Date().getTime();
    let destPath = createFilePath(dir, id, time, file.type);

    fs.copyFile(file.path, destPath, {
      done: (err) => {
        if (err) reject(err);
        else done(time);

        // update related doc on database
        updateTimeStamp(db, collection, id, time, file.type);
        // remove temp file
        fs.fs.unlinkSync(file.path);
      }
    });
  });
}

function removePhoto(db, type, id) {
  let ftp = global.services.ftp;
  let rootDir = global.config.ftp_photo_dir;

  return new Promise(async (done, reject) => {
    // directory
    let dir = `${rootDir}/${db}-${type}`;
    // delete if exists
    await removeOldImage(db, type, id, dir).catch(reject);
    // update timeStamp to be ''
    await updateTimeStamp(db, type, id, null).then(done).catch(reject);
  });
}

module.exports = {
  storePhoto,
  removePhoto
}