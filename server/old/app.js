require('datejs');
Date.i18n.setLanguage('fa-IR');

const modularRest = require('modular-rest');
const koaBody = require('koa-body');
const koaStatic = require('koa-static');
const cors = require('@koa/cors');

const EventEmitter = require('events');
global.event = new EventEmitter();

global.config = require('./config');
const dataInsertion = require('./data_insertion');
let servicesDirectory = require('path').join(__dirname, 'services');

let option = {
  root: servicesDirectory,
  onBeforInit: BeforInit, // befor anything
  onInit: Init, // after collecting routers
  onAfterInit: AfterInit, // affter launch server
  port: global.config.port || 8080,

  // if it would be true, app doesn't listen to port,
  // and a raw app object with all routers will be returned.
  // this option is for virtual host middlewares
  dontlisten: false,

  // collecting other services from subfolders
  otherSrvice: [{
      filename: {
        name: 'service',
        extension: '.js'
      },
      rootDirectory: servicesDirectory,
      option: {
        // if this option woulde be true, the property of each service will be attached to rootObject
        // the `name` property will be rejected and only the main property of each service would be recognize.
        // it would be useful when you want to collect all mongoose models in one root object.
        combineWithRoot: false,

        // convert the rootObject to an array
        // the `name` property will be rejected and only the main property of each service would be recognize.
        convertToArray: false,
      }
    },
    {
      filename: {
        name: 'events',
        extension: '.js'
      },
      rootDirectory: servicesDirectory,
      option: {
        convertToArray: false,
        combineWithRoot: false,
      }
    },
    {
      filename: {
        name: 'db',
        extension: '.js'
      },
      rootDirectory: servicesDirectory,
      option: {
        combineWithRoot: true
      }
    },
  ],
};

function BeforInit(app) {
  // set cors 
  let corsOptions = {
    origin: (ctx) => {
      const requestOrigin = ctx.accept.headers.origin;
      let whitelist = global.config.valid_cors;

      if (!whitelist.includes(requestOrigin))
        return ctx.throw(`🙈 ${requestOrigin} is not a valid origin`);

      return requestOrigin;
    }
  };
  app.use(cors(corsOptions));

  // body parser
  let options = {
    multipart: true,
  };

  // use a body parser
  app.use(koaBody(options));
}

function Init(app, otherSrvice) {

  // use otherSrvice
  // all your other services will injected to `otherSrvice` object.
  // eahc service would be accessible by its filename
  global.services = otherSrvice['service'];

  // run event intializer
  for (key in otherSrvice['events']) {
    let event = otherSrvice['events'][key];
    event.main();
  }
  
  // add component collection to content provider
  for (key in otherSrvice['db']) {
    let cc = otherSrvice['db'][key];
    global.services.contentProvider.addComponentCollection(cc);
  }

  // serve upload folder
  app.use(koaStatic(global.config.uploadPath));

  // serve build folder
  // TODO ...
}

async function AfterInit(app, otherSrvice) {
  global.services.jwt.main
    .setKies(global.config.PRIVATE_KEY, global.config.PUBLIC_KEY);

  await dataInsertion.createPermissions();
  await dataInsertion.createAdminUser();
  dataInsertion.insertOtherNecessaryData();
}

modularRest.createRest(option).then(app => {
  // do something
});