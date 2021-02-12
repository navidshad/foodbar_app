const {getCollection, TypeCasters} = require('@modular-rest/server');
const systemOptions = require('../systemOptions/service');

let name = 'reservation';

function getDividedTimes(period, ISOdate, dividedPerMinutes = 30) {
  let date = new Date(ISOdate.toString());

  let dateStartTime = new Date(
    date.getUTCFullYear(),
    date.getUTCMonth(),
    date.getUTCDay(),
    period.from.houre,
    period.from.minutes
  );

  let dateEndTime = new Date(
    date.getUTCFullYear(),
    date.getUTCMonth(),
    date.getUTCDay(),
    period.to.houre,
    period.to.minutes
  );

  let list = [];
  let counter = 0;
  let keepDividingTime = true;

  while (keepDividingTime) {
    let cloneStartTimeString = dateStartTime.toISOString();

    let additionMinutes = dividedPerMinutes * counter;

    let newTime = new Date(cloneStartTimeString).add({
      minutes: additionMinutes
    });

    list.push(newTime);

    let compairedDates = dateEndTime.compareTo(newTime);
    if (compairedDates <= 0) keepDividingTime = false;

    counter++;
  }

  return list;
}

function ValidateDateForReservation(date) {

  return new Promise(async (done, reject) => {
    let key = false;

    let dividedPerMinutes = await systemOptions.getOption('timeDividedPerMitutes');

    // get periods
    let periodCollection = getCollection('cms', 'period');
    let periods = await periodCollection.find({}).exec().catch(reject);

    // go throughout periods and validate he time 
    periods.forEach(period => {

      let dividedTimes = getDividedTimes(period, date, dividedPerMinutes);
      let index = dividedTimes.indexOf(date);

      if (index <= 0) key = true;
    });

    return done(key);
  });
}

function getScheduleOptions() {
  return new Promise(async (done, reject) => {

    let totalDays = 1;
    let from = Date.today().toISOString();
    let periods = [];

    // get total days
    await systemOptions.getOption('totalAllowedDaysForReservation')
      .then(days => {
        totalDays = days
      })
      .catch((error) => {
        console.log(error);
      });

    // get periods
    await getCollection('cms', 'period')
      .find({}).exec()
      .then(list => periods = list || []);

    preparedOptions = {
      'totalDays': totalDays,
      'from': from,
      'periods': periods,
    };

    done(preparedOptions);
  });
}

function getTables() {
  return getCollection('cms', 'table')
    .find({}).exec();
}

function getReservedTimes(ISODay, tableId) {

  return new Promise(async (done, reject) => {

    let formattedDay = TypeCasters['Date'](ISODay);

    let tomarrowDate = Date.parse(formattedDay.toISOString());
    tomarrowDate.addDays(1);
    tomarrowDate = typeCasters['Date'](tomarrowDate.toISOString());

    let reservedTimes = [];

    let ReservedTableCollection = getCollection('user', 'reservedTable');
    let tableModel = getCollection('cms', 'table');

    // get table
    let table = await tableModel.findOne({
      _id: tableId
    }).exec().catch(reject);

    // validate table
    if (!table) {
      reject('Table ID is wrong.');
      return;
    }

    // console.log(formattedDay.toISOString());
    // console.log(tomarrowDate.toISOString());


    let piplines = [{
        '$match': {
          'from': {
            '$gte': formattedDay,
          },
          //'to': { 'lte': tomarrowDate }
        }
      },
      {
        '$group': {
          '_id': '$from',
          'list': {
            '$push': {
              'tableId': '$tableId',
              'persons': '$persons',
              'totalPersonOnTable': '$totalPersonOnTable',
            }
          }
        }
      }
    ];

    let reservedTables = await ReservedTableCollection.aggregate(piplines).exec().catch(reject);

    reservedTables.forEach((group) => {

      let remainDetail = getRemainPersonByReservedListAndTable(group.list, table);
      if (remainDetail.remain <= 0)
        reservedTimes.push(group._id);

    });

    done(reservedTimes);
  });
}

function getRemainPersonByReservedListAndTable(reservedList, table) {

  let totalPersons = table.persons * table.count;
  let reservedPersons = 0;

  reservedList.forEach(item => {
    if (!(item.tableId == table._id)) return;

    if (item.persons <= item.totalPersonOnTable) {
      reservedPersons += item.totalPersonOnTable;
    } else {
      let divided = item.persons / item.totalPersonOnTable;
      let totalTables = Math.ceil(divided);
      let maxchairsOnReservedTables = totalTables * item.totalPersonOnTable;
      reservedPersons += maxchairsOnReservedTables;
    }
  });

  let result = {
    total: totalPersons,
    reserved: reservedPersons,
    remain: totalPersons - reservedPersons
  };

  return result;
}

function getRemainPersons(ISOdateTimeString, tableId) {

  let tableModel = getCollection('cms', 'table');
  let reservedTableModel = getCollection('user', 'reservedTable');

  return new Promise(async (done, reject) => {

    // define time
    let dateTimeFrom = new Date(ISOdateTimeString);

    // validate Date that not to be null
    if (!dateTimeFrom) {
      reject('Date format is wrong: ' + ISOdateTimeString);
      return;
    }

    // validate Date to be a right time
    let isValidTime = await ValidateDateForReservation(dateTimeFrom);
    if (!isValidTime) {
      reject('Date format is wrong: ' + ISOdateTimeString);
      return;
    }

    // get table
    let table = await tableModel.findOne({
      _id: tableId
    }).exec().catch(reject);

    // validate table
    if (!table) {
      reject('Table ID is wrong.');
      return;
    }

    let findQuery = {
      'tableId': tableId,
      'from': {
        $eq: dateTimeFrom
      }
    };

    let reservedList = await reservedTableModel.find(findQuery).exec().catch(reject);
    let result = getRemainPersonByReservedListAndTable(reservedList, table);

    done(result);
  });
}

function cancel(reservedId) {
  // reserve table
  let reservedModel = getCollection('user', 'reservedTable');
  
  return new Promise(async (done, reject) => {
     
    let query = {_id: reservedId};
    let reservedTable = await reservedModel.findOne(query).exec().catch(reject);
    
    if(!reservedId){
      reject('reserved table not found');
      return;
    }
    
    let currentDate = Date.today().setTimeToNow();
    let compared = currentDate.compareTo(reservedTable.from);
    
//     console.log('current', currentDate.toString());
//     console.log('reserved table', reservedTable.from);
//     console.log('compared', compared);
    
    
    // if current date is less than reserved date
    if(compared == -1) {
      await reservedModel.deleteOne(query).exec().then(done).catch(reject)
    }
    else {
      reject('the date of reserved table is passed and it could be canceled')
    }
  });
}

function reserve(refId, ISOdateTimeString, tableId, persons) {

  return new Promise(async (done, reject) => {

    let additionMinutes = await systemOptions.getOption('timeDividedPerMitutes');

    // define time
    let dateTimeFrom = new Date(ISOdateTimeString);
    let dateTimeTo = new Date(ISOdateTimeString).add({
      minutes: additionMinutes
    });

    // validate Date that not to be null
    if (!dateTimeFrom) {
      reject('Date format is wrong: ' + ISOdateTimeString);
      return;
    }

    // validate Date to be a right time
    let isValidTime = await ValidateDateForReservation(dateTimeFrom);
    if (!isValidTime) {
      reject('Date format is wrong: ' + ISOdateTimeString);
      return;
    }

    // validate tableID
    let tableCollection = getCollection('cms', 'table');
    let table = await tableCollection.findOne({
      _id: tableId
    }).exec().catch(reject);

    if (!table) {
      reject('tableId is wrong');
      return;
    }

    // validate Persons
    let personDetail = await getRemainPersons(ISOdateTimeString, tableId).catch(reject);

    if (personDetail.remain < persons) {
      reject('persons is out of range');
      return;
    }

    // reserve table
    let reservedModel = getCollection('user', 'reservedTable');

    let dateId = Date.UTC(
      Date.today().setTimeToNow().getUTCFullYear(),
      Date.today().setTimeToNow().getUTCMonth(),
      Date.today().setTimeToNow().getUTCDay(),
      Date.today().setTimeToNow().getUTCHours(),
      Date.today().setTimeToNow().getUTCMinutes(),
      Date.today().setTimeToNow().getUTCSeconds(),
      Date.today().setTimeToNow().getUTCMilliseconds()
    );

    let totalPersonOnTable = 0;

    if (table.type == 'RollBand')
      totalPersonOnTable = persons;
    else totalPersonOnTable = table.persons;

    let ReservedDetail = {
      'refId': refId,
      'from': dateTimeFrom.toISOString(),
      'to': dateTimeTo.toISOString(),
      'tableId': tableId,
      'persons': persons,
      'totalPersonOnTable': totalPersonOnTable,
      'reservedId': dateId,
    };

    let newReserved = await new reservedModel(ReservedDetail).save().catch(reject);

    done(ReservedDetail);
  });
}

module.exports = {
  name,
  getScheduleOptions,
  getTables,
  getReservedTimes,
  getRemainPersons,
  reserve,
  cancel,
}