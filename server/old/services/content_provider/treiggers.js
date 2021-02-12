let DBTrigger = require('../../class/db_trigger');

const triggers = [

    new DBTrigger('insertOne', 'cms', 'auth', async (input, output) => 
    {
        if(output.error) return;

        let auth = output;
    
        const newUser = {
            'refId': auth.id.toString(),
        };
    
        let newSubscription = {'refId': auth.id.toString()};
    
        await new global.services.contentProvider.getCollection('user', 'detail')(newUser).save().then();
        await new global.services.contentProvider.getCollection('user', 'subscription')(newSubscription).save().then();
    }),

    new DBTrigger('removeOne', 'cms', 'auth', async (input, output) => 
    {
        if(output.error) return;

        let query = { refId: input._id };
    
        global.services.contentProvider.getCollection('user', 'detail').deleteOne(query).exec();
        global.services.contentProvider.getCollection('user', 'subscription').deleteOne(query).exec();
    }),
  
    new DBTrigger('removeOne', 'media', 'artist', async (input, output) => 
    {
        if(output.error) return;

        let query = { _id: input._id };
        let query2 = { artistId: input._id };
    
        global.services.contentProvider.getCollection('media', 'album').deleteMany(query2).exec();
        global.services.contentProvider.getCollection('media', 'song').deleteMany(query2).exec();
      
        let directiries = global.services.music.getAllDirectoriesOfArtist(input._id);
        directiries.forEach(dir => 
          global.services.ftp.deleteDir(dir));
    }),
  
    new DBTrigger('removeOne', 'media', 'album', async (input, output) => 
    {
        if(output.error) return;

        let query = { _id: input._id };
        let query2 = { albumId: input._id };
      
        let songs = await global.services.contentProvider.getCollection('media', 'song').find(query2).exec().then();
      
        songs.forEach(song => callTrigger('removeOne', 'media', 'song', {input:{}, output:song}));
    
        //global.services.contentProvider.getCollection('media', 'album').deleteOne(query).exec();
        global.services.contentProvider.getCollection('media', 'song').deleteMany(query2).exec();
    }),
  
    new DBTrigger('removeOne', 'media', 'song', async (input, output) => 
    {
        if(output.error) return;

        let song = output;
        
        let fileList = global.services.music.getAllFilesOfSong(song);
        fileList.forEach(filePath => 
          global.services.ftp.delete(filePath));
    }),
  
    new DBTrigger('insertOne', 'media', 'album', async (input, output) => 
    {
        let album = output;
        let artist = await global.services.contentProvider
          .getCollection('media', 'artist').findOne({_id: album.artistId}).exec().then();
      
        album.artist = artist.name;
        await album.save().then();
    }),
  
    new DBTrigger('updateOne', 'media', 'artist', async (input, output) => 
    {
        if(output.error) return;

        let query = { artistId: output._id };
      
        let update = { $set: { 
            artist          : output.name,
            imgStamp_artist : output.imgStamp,
          } };
    
        global.services.contentProvider.getCollection('media', 'album').update(query, update, {multi: true}).exec();
        global.services.contentProvider.getCollection('media', 'song').update(query, update, {multi: true}).exec();
    }),
  
    new DBTrigger('updateOne', 'media', 'album', async (input, output) => 
    {
        if(output.error) return;

        let query = { albumId: output._id };
        
        let update = { $set: { 
            album           : output.title,
            imgStamp_album  : output.imgStamp,
          } };
    
        global.services.contentProvider.getCollection('media', 'song').update(query, update, {multi: true}).exec();
    }),
];

function callTrigger(name, database, coll, data)
{
  let result;

  triggers.forEach(trigger => 
  {
      if(name == trigger.name && database == trigger.database && coll == trigger.collection)
          result = trigger.callback(data.input, data.output);
  });

  return result;
}

module.exports.call = callTrigger;