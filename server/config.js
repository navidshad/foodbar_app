module.exports = {
    title: 'Haiku',
    host: 'localhost',

    // content provider
    db_prefix: 'foodbar_',
    mongoUrl: 'mongodb+srv://foodbar.u16qibv.mongodb.net/?retryWrites=true&w=majority',
    mongoOption: {
        user: "foodbar",
        pass: "f1o2o3d4b5a6r",
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
    PRIVATE_KEY: `-----BEGIN RSA PRIVATE KEY-----
MIIBOwIBAAJBAKNhHm9k1ZmZYegSRHT4eTTEl9f2YC11uIZ/uf5LAB3kKxK4wz86
CMtIX5TrPayL+7y8RAIcvIHVV6NoMhGFc08CAwEAAQJBAJzMS3pbCsikNRuV1I9y
HFkxSA1jDgDzFwo2MRnFfzIvTJ68r5BIB2RvMoCXhCllQPXeQiC76XBfP/buTaDb
nBkCIQDYWG9Mz4oSWJrMkUOnwPzayqoVK2R9NXZSs1H1H9A6vQIhAMFTXB9/gnnf
AKiO9I+tScnJd2MdoTBtzft5WO7rNwz7AiBpx/PDrsZn6gLmezCFWYtIv0ciSrE7
t2Q/U4aDQCbkUQIhAIbgfKYxFLuoHNJ8oh1XXeKdX2DUPDAIe6wV9jkB+69fAiBm
G1b91hlbFLQ0sb48nPn8N9LXGC/cSh6NRAeLOb0OsQ==
-----END RSA PRIVATE KEY-----`,

    PUBLIC_KEY: `-----BEGIN PUBLIC KEY-----
MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKNhHm9k1ZmZYegSRHT4eTTEl9f2YC11
uIZ/uf5LAB3kKxK4wz86CMtIX5TrPayL+7y8RAIcvIHVV6NoMhGFc08CAwEAAQ==
-----END PUBLIC KEY-----`,
}