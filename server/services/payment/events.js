module.exports.name = 'payment';
module.exports.main = () => 
{
  global.event.on('onPaidSuccess', async (factorid) => 
  {
    let factorModel = global.services.contentProvider.getCollection('user', 'factor');
    
    // update factor
    let query = {'_id':factorid};
    //let update = { $set: { isPaid: true } };
    let factor = await factorModel.findOne(query).exec().then();
    
    factor.isPaid = true;
    await factor.save().then();
    
    // apply subscription for the user
    if(factor.type.title == 'tariff')
    {
      let userid = factor.refId;
      let tariffid = factor.type.refId;
      global.event.emit('applySubscription', tariffid, userid);
    }
  });
}