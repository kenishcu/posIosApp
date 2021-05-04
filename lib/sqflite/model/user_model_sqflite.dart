class UserModelSqflite {

  int id;
  String name;
  String email;
  String userName;
  String branchId;
  String branchCode;
  String branchName;
  int roleId;
  String roleCode;
  String roleName;

  UserModelSqflite({this.id, this.name, this.email, this.userName, this.branchId,
    this.branchCode, this.branchName, this.roleId, this.roleCode, this.roleName});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'userName': userName,
      'branchId': branchId,
      'branchCode': branchCode,
      'branchName': branchName,
      'roleId': roleId,
      'roleCode': roleCode,
      'roleName': roleName
    };
  }

  factory UserModelSqflite.fromMap(dynamic json) {
    return UserModelSqflite(
        id: json['_id'],
        name: json['name'],
        userName: json['userName'],
        email: json['email'],
        branchId: json['branchId'],
        branchCode: json['branchCode'],
        branchName: json['branchName'],
        roleId: json['roleId'],
        roleCode: json['roleCode'],
        roleName: json['roleName']
    );
  }
}
