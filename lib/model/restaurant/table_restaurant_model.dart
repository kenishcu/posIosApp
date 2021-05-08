class TableRestaurantModel {

  String _id;
  String _tableCode;
  String _tableName;
  int _createAt;
  int _updateAt;
  int _status;

  TableRestaurantModel(this._id, this._tableCode, this._tableName,
      this._createAt, this._updateAt, this._status);

  factory TableRestaurantModel.fromJson(dynamic json) {
    return TableRestaurantModel( json['_id'] as String, json['table_code'] as String, json['table_name'] as String,
        json['create_at'] as int, json['update_at'] as int, json['status'] as int);
  }


  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get tableCode => _tableCode;

  set tableCode(String value) {
    _tableCode = value;
  }

  String get tableName => _tableName;

  set tableName(String value) {
    _tableName = value;
  }

  int get createAt => _createAt;

  set createAt(int value) {
    _createAt = value;
  }

  int get updateAt => _updateAt;

  set updateAt(int value) {
    _updateAt = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }
}
