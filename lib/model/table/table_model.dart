import 'package:pos_ios_bvhn/model/table/position_table_model.dart';

class TableModel {
  String _id;
  String _tableCode;
  String _tableName;
  bool _using;
  int _status;
  PositionTableModel _position;

  TableModel(this._id, this._tableCode, this._tableName, this._using, this._status, this._position);

  factory TableModel.fromJson(dynamic json) {
    return TableModel(json['_id'] as String , json['table_code'] as String, json['table_name'] as String,
        json['using'] as bool, json['status'] as int, PositionTableModel.fromJson(json['position']));
  }

  toJson() {
    return {
      '_id': _id,
      'table_name': _tableName,
      'table_code': _tableCode,
      'using': _using,
      'status': _status,
      'position': _position.toJson()
    };
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  bool get using => _using;

  set using(bool value) {
    _using = value;
  }


  String get tableCode => _tableCode;

  set tableCode(String value) {
    _tableCode = value;
  }

  String get tableName => _tableName;

  set tableName(String value) {
    _tableName = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  PositionTableModel get position => _position;

  set position(PositionTableModel value) {
    _position = value;
  }
}
