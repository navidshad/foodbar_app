module.exports = {
    // there is a problem when an object convert to JSON, setter propertis 
    // will not be converted.
    // this method is for convert an object contains setter propertis 
    // to a object that have all its own propertis in public form.
    toJson: function (obj, setterKeys = []) {
        let jsonForm = JSON.stringify(obj);
        let objectform = JSON.parse(jsonForm);
        
        try {
            setterKeys.forEach(key => objectform[key] = obj[key]);   
        } catch (error) {
            
        }

        return objectform;
    }
}