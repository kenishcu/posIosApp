class RoleModel {
  int _roleId;
  String _roleCode;
  String _roleName;

  RoleModel(this._roleId, this._roleCode, this._roleName);

  factory RoleModel.fromJson(dynamic json) {
    return RoleModel(json['role_id'] as int, json['role_code'] as String, json['role_name'] as String);
  }

  int get roleId => _roleId;

  set roleId(int value) {
    _roleId = value;
  }

  String get roleName => _roleName;

  set roleName(String value) {
    _roleName = value;
  }

  String get roleCode => _roleCode;

  set roleCode(String value) {
    _roleCode = value;
  }
}
