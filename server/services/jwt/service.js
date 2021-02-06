const jwt = require('jsonwebtoken');

class JWT 
{
    setKies(privateKey, publicKey)
    {
        this.privateKey = privateKey;
        this.publicKey  = publicKey;
    }

    sign(payload)
    {
        return new Promise((done, reject) => 
        {
            let option = { algorithm: 'RS256'};
        
            try {
                let token = jwt.sign(payload, this.privateKey, option);
                done(token);
            }
            catch (error) {
                reject(error.message);
            }
        });
    }

    verify(token)
    {
        return new Promise((done, reject) => 
        {
            let option = { algorithm: 'RS256' };
        
            try {
                let decoded = jwt.verify(token, this.publicKey, option);
                done(decoded);
            }
            catch (error) {
                reject(error);
            }
        });
    }
}

module.exports.name = 'jwt';
module.exports.main = new JWT();