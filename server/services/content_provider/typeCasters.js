let Mongoose = require('mongoose');
module.exports = {
  'ObjectId': Mongoose.Types.ObjectId,
  'Date': (dateValue) => {
      let strDate = dateValue.toString();
      let mongoDateFormateInString = new Date(strDate).toISOString().split('T')[0];
      return new Date(mongoDateFormateInString);
  }
}