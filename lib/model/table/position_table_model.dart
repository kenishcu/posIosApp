class PositionTableModel {

  String _id;
  String _branchCode;
  String _branchId;
  String _branchName;
  String _positionCode;
  String _positionName;
  int _status;

  PositionTableModel(this._id, this._branchCode, this._branchId, this._branchName, this._positionName,
      this._positionCode, this._status);

  factory PositionTableModel.fromJson(dynamic json) {
    return PositionTableModel(json['_id'] as String, json['branch_code'] as String, json['branch_id'] as String,
        json['branch_name'] as String,  json['position_name'] as String, json['position_code'] as String, json['status'] as int);
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get branchCode => _branchCode;

  set branchCode(String value) {
    _branchCode = value;
  }

  String get branchId => _branchId;

  set branchId(String value) {
    _branchId = value;
  }

  String get branchName => _branchName;

  set branchName(String value) {
    _branchName = value;
  }

  String get positionCode => _positionCode;

  set positionCode(String value) {
    _positionCode = value;
  }

  String get positionName => _positionName;

  set positionName(String value) {
    _positionName = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }
}