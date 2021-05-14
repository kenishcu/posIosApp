class PaymentOtherModel {

  int _room;
  int _debit;
  int _card;
  int _free;
  int _bank;
  int _voucher;
  int _cash;
  int _tip;

  PaymentOtherModel(this._room, this._debit, this._card,
      this._free, this._bank, this._voucher, this._cash, this._tip);

  factory PaymentOtherModel.fromJson(dynamic json) {
    return PaymentOtherModel(json['room'] as int , json['debit'] as int,
        json['card'] as int, json['free'] as int, json['bank'] as int,
        json['voucher'] as int, json['cash'] as int, json['tip'] as int);
  }

  toJson() {
    return {
      'room': _room,
      'debit': _debit,
      'card': _card,
      'free': _free,
      'bank': _bank,
      'voucher': _voucher,
      'cash': _cash,
      'tip': _tip
    };
  }

  int get room => _room;

  set room(int value) {
    _room = value;
  }
  int get debit => _debit;

  set debit(int value) {
    _debit = value;
  }

  int get card => _card;

  set card(int value) {
    _card = value;
  }

  int get free => _free;

  set free(int value) {
    _free = value;
  }

  int get bank => _bank;

  set bank(int value) {
    _bank = value;
  }

  int get voucher => _voucher;

  set voucher(int value) {
    _voucher = value;
  }

  int get cash => _cash;

  set cash(int value) {
    _cash = value;
  }

  int get tip => _tip;

  set tip(int value) {
    _tip = value;
  }
}
