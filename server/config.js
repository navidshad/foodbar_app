module.exports = {
    title: 'Foodbar',
    host: 'localhost',
    
    // content provider
    db_prefix: 'foodbar_',
    mongoUrl: process.env.MONGO_CONNECTION || '',
    mongoOption: {
        user: process.env.MONGO_USER || "",
        pass: process.env.MONGO_PASS || "",
        // authSource: "admin",
        useNewUrlParser: true,
    },

    // image uploader
    uploadPath: require('path').join(__dirname, 'assets'),

    // hosts
    port: 80,
    temppath: require('path').join(__dirname, 'temp'),

    adminUser: {
        email: 'admin',
        password: 'admin'
    },

    // jwt
    PRIVATE_KEY: process.env.PRIVATE_KEY,
    PUBLIC_KEY: process.env.PUBLIC_KEY,
}
