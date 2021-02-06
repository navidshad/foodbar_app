class Currency {
  static get EUR() { return { code: 'eur', title: 'Eurro' }; };
  static get SEK() { return { code: 'sek', title: 'Swedish Krona' }; };

  static getAll() {
    return [
      Currency.EUR,
      Currency.SEK,
    ];
  }

  static getAllasString() {
    let string = '';
    Currency.getAll().forEach(cr => string = ' ' + cr.code);
    return string;
  }

  static getAllCodes() {
    let list = [];
    Currency.getAll().forEach(cr => list.push(cr.code));
    return list;
  }

}

module.exports.Currency = Currency;

module.exports.Gate = class {
  constructor(detail) {
    this.title = detail.title;
    this.currencies = detail.currencies;
    this.getPayLinkAsync = detail.getPayLinkAsync;
    this.callback = detail.callback;
  }
}