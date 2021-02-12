module.exports =
{
    title: 'Haiku',
    host: 'localhost',

    // content provider 
    mongo: 'mongodb://localhost:27017',
    db_prefix: 'foodbar_',

    // image uploader
    uploadPath: require('path').join(__dirname, 'uploads'),

    // hosts
    port: 2005,
    temppath: require('path').join(__dirname, 'temp'),
    
    adminUser: {
        email: '',
        password: ''
    },

    //jwt
    PRIVATE_KEY: '',
    PUBLIC_KEY: "",
}