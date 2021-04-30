class CommissionRestaurantModel {

  String _customerName;
  String _receiveName;
  String _rosesNote;
  int _rosesPercent;

  CommissionRestaurantModel(this._customerName, this._receiveName,
      this._rosesNote, this._rosesPercent);

  factory CommissionRestaurantModel.fromJson(dynamic json) {
    return CommissionRestaurantModel(json['customer_name'] as String, json['receive_name'] as String,
    json['roses_note'] as String, json['roses_percent'] as int);
  }

  toJson() {
    return {
      'customer_name': _customerName,
      'receive_name': _receiveName,
      'roses_note': _rosesNote,
      'roses_percent': _rosesPercent
    };
  }

  String get customerName => _customerName;

  set customerName(String value) {
    _customerName = value;
  }

  String get receiveName => _receiveName;

  set receiveName(String value) {
    _receiveName = value;
  }

  String get rosesNote => _rosesNote;

  set rosesNote(String value) {
    _rosesNote = value;
  }

  int get rosesPercent => _rosesPercent;

  set rosesPercent(int value) {
    _rosesPercent = value;
  }
}
