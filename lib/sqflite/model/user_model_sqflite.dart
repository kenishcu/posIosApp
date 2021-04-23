class UserModelSqflite {

  final int id;
  final String name;
  final String email;
  final String userName;
  final String branchId;
  final String branchCode;
  final String branchName;
  final int roleId;
  final String roleCode;
  final String roleName;

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
        id: json['id'],
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
