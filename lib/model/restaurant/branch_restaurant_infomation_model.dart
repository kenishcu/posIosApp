class BranchRestaurantInformationModel {

  String _branchCode;
  String _branchName;
  int _serviceRate;
  int _status;
  int _taxRate;
  int _createAt;
  int _updateAt;

  BranchRestaurantInformationModel(this._branchCode, this._branchName, this._serviceRate,
      this._status, this._taxRate, this._createAt, this._updateAt);

  factory BranchRestaurantInformationModel.fromJson(dynamic json) {
    return BranchRestaurantInformationModel( json['branch_code'] as String, json['branch_name'] as String,
        json['service_rate'] as int, json['status'] as int,  json['tax_rate'] as int,  json['create_at'] as int,
        json['update_at'] as int);
  }

  String get branchCode => _branchCode;

  set branchCode(String value) {
    _branchCode = value;
  }

  String get branchName => _branchName;

  set branchName(String value) {
    _branchName = value;
  }

  int get serviceRate => _serviceRate;

  set serviceRate(int value) {
    _serviceRate = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  int get taxRate => _taxRate;

  set taxRate(int value) {
    _taxRate = value;
  }

  int get createAt => _createAt;

  set createAt(int value) {
    _createAt = value;
  }

  int get updateAt => _updateAt;

  set updateAt(int value) {
    _updateAt = value;
  }
}
