
let name = 'systemOptions';
let options;

function getOptionCollection() {
    return global.services.contentProvider.getCollection('cms', 'settings');
}

async function initializedOptions() {
    let model = getOptionCollection();
    let newDoc = await new model({ title: 'production' }).save();
    return newDoc;
}

function getOptions() {
    return new Promise( async (done, reject) => {
        // get options from database 
        // if it wasn't gotten already.
        if (!options) {

            let model = getOptionCollection();

            await model.findOne({}).exec()
                .then(async doc => {

                    if (doc) options = doc;
                    else options = await initializedOptions();

                })
                .catch(reject);
        }

        done(options);
    });
}

function getOption(key) {
    return getOptions().then(op => {
        let value = options[key];
        return value;
    }).catch((e) => {
        console.log(e);
        return e;
    });
}

function setOptions(id, updates) {

    let model = getOptionCollection();
    return model.update({ '_id': id }, updates).exec();
}

module.exports = {
    name,
    getOptions,
    getOption,
    setOptions,
}