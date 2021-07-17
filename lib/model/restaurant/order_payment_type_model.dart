class OrderPaymentTypeModel {

  String _name;
  String _value;

  OrderPaymentTypeModel(this._name, this._value);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get value => _value;

  set value(String value) {
    _value = value;
  }
}
