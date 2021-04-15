class ResultModel {

  String _appVersion;
  Map _errors;
  Map _data;
  bool _status;

  ResultModel(this._appVersion, this._errors, this._data, this._status);

  factory ResultModel.fromJson(dynamic json) {
    return ResultModel(json['app_version'] as String, json['errors'] as Map,
        json['data'] as Map, json['status'] as bool);
  }

  String get appVersion => _appVersion;

  set appVersion(String value) {
    _appVersion = value;
  }

  Map get errors => _errors;

  set errors(Map value) {
    _errors = value;
  }

  Map get data => _data;

  set data(Map value) {
    _data = value;
  }

  bool get status => _status;

  set status(bool value) {
    _status = value;
  }
}
