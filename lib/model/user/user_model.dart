import 'package:pos_ios_bvhn/model/user/branch_model.dart';
import 'package:pos_ios_bvhn/model/user/role_model.dart';

class UserModel {

  String _name;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String _email;
  String _userName;

  BranchModel _branch;

  String _branchId;
  String _branchCode;
  String _branchName;

  RoleModel _role;
  int _roleId;
  String _roleCode;
  String _roleName;

  UserModel(this._name, this._email, this._userName, this._branch, this._branchId, this._branchCode, this._branchName,
      this._role, this._roleId, this._roleCode, this._roleName);

  factory UserModel.fromJson(dynamic json) {
    return UserModel( json['name'] as String, json['mail'] as String, json['username'] as String, BranchModel.fromJson(json['branch']), json['branch_id'] as String, json['branch_code'] as String, json['branch_name'] as String,
      RoleModel.fromJson(json['role']), json['role_id'] as int, json['role_code'] as String, json['role_name'] as String,);
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  BranchModel get branch => _branch;

  set branch(BranchModel value) {
    _branch = value;
  }

  String get branchId => _branchId;

  set branchId(String value) {
    _branchId = value;
  }

  String get branchCode => _branchCode;

  set branchCode(String value) {
    _branchCode = value;
  }

  String get branchName => _branchName;

  set branchName(String value) {
    _branchName = value;
  }

  RoleModel get role => _role;

  set role(RoleModel value) {
    _role = value;
  }

  int get roleId => _roleId;

  set roleId(int value) {
    _roleId = value;
  }

  String get roleCode => _roleCode;

  set roleCode(String value) {
    _roleCode = value;
  }

  String get roleName => _roleName;

  set roleName(String value) {
    _roleName = value;
  }
}