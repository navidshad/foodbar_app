var mongoose = require('mongoose');
var Schema = mongoose.Schema;

let ComponentCollection = require('../../class/component_collection');
let { Currency } = require('../../class/getway');

let SlideSchema = new Schema({
    showDetail: Boolean,
    refId: String,
    local_title: Object,
    local_subtitle: Object,
    imgStamp: String,
    link: String,
});
    
let slideshowSchema = new Schema({
    title: String,
    width: Number,
    height: Number,
});
slideshowSchema.index({ title: 1}, { unique: true });


//module.exports.fnumber = new ComponentCollection('user', 'fnumber', fnumberSchema);
module.exports.slideshow = new ComponentCollection('cms', 'slideshow', slideshowSchema);
module.exports.slide = new ComponentCollection('cms', 'slide', SlideSchema);