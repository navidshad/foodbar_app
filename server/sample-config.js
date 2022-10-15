module.exports =
{
    title: 'Haiku',
    host: 'localhost',

    // content provider 
    db_prefix: 'foodbar_',
    mongoUrl: 'mongodb://localhost:55000',
    mongoOption: {
        user: "docker",
        pass: "mongopw",
        authSource: "admin",
        useNewUrlParser: true,
    },

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