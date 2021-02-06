const uniqueRandom = require('unique-random');
const sendmail = require('sendmail')({
    smtpPort: 10254,
});

let Kavenegar;// = require('kavenegar');
let kevenegarAPI;// = Kavenegar.KavenegarApi({ apikey: global.config.api_key_kavenegar });
const random = uniqueRandom(1, 100000);

let name = "sender";

function _sendVarificationCodeBySMS(phone) {
    let body = {
        receptor: "00" + phone,
        token: random(),
        template: 'register',
    };

    return new Promise((done, reject) => {
        kevenegarAPI.VerifyLookup(body,
            (entries, status, message) => {
                if (status == 200) done(body.token);
                else reject(message);
            }
        );
    });
}

function _sendVarificationCodeByEmail(receptorEmail) {

    let appTitle = global.config.title;
    let host = global.config.host;
    let code = random();

    return new Promise((done, reject) => {

        if (host.includes('localhost')) {
            done(code);
            console.log('varification code: ', code);

        } else {
            sendmail({
                from: `no-reply@${host}`,
                to: receptorEmail,
                subject: `${appTitle} varification code`,
                html: `Your Varification code is ${code} \n\nThank you\n${appTitle}`,
            }, function (err, reply) {
                if (err) reject(err);
                else done(code);
            });
        }
    });

}

function sendVarificationCode(idType, id) {

    let result;

    switch (idType) {
        case 'email':
            result = _sendVarificationCodeByEmail(id);
            break;

        case 'phone':
            result = _sendVarificationCodeBySMS(id);
            break;
    }

    return result;
}

module.exports = {
    name, sendVarificationCode,
};