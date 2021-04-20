class ResultModel {
  String _appVersion;
  Map _errors;
  dynamic _data;
  bool _status;

  ResultModel(this._appVersion, this._errors, this._data, this._status);

  factory ResultModel.fromJson(dynamic json) {
    return ResultModel(json['app_version'] as String, json['errors'] as Map,
        json['results'] as dynamic, json['status'] as bool);
  }

  String get appVersion => _appVersion;

  set appVersion(String value) {
    _appVersion = value;
  }

  dynamic get data => _data;

  set data(dynamic value) {
    _data = value;
  }

  Map get errors => _errors;

  set errors(Map value) {
    _errors = value;
  }

  bool get status => _status;

  set status(bool value) {
    _status = value;
  }
}
