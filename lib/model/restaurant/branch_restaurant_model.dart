class BranchRestaurantModel {
  String _branchId;
  String _branchName;
  String _branchCode;
  int _status;

  BranchRestaurantModel(this._branchId, this._branchName, this._branchCode, this._status);

  factory BranchRestaurantModel.fromJson(dynamic json) {
    return BranchRestaurantModel( json['branch_id'] as String, json['branch_name'] as String,
        json['branch_code'] as String, json['status'] as int);
  }

  String get branchId => _branchId;

  set branchId(String value) {
    _branchId = value;
  }

  String get branchName => _branchName;

  set branchName(String value) {
    _branchName = value;
  }

  String get branchCode => _branchCode;

  set branchCode(String value) {
    _branchCode = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }
}
