require('datejs');
const ModularRest = require('@modular-rest/server');
const Path = require('path');

function run() {
    return ModularRest.createRest({
        port: '3001',
        componentDirectory: Path.join(__dirname, 'src'),
        uploadDirectory: Path.join(__dirname, 'uploads'),
        // cors: {
        //     origin: 'http://localhost:3000'
        // },
        dontListen: false,
    })
}

run();
