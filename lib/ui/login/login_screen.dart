import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';
import 'package:pos_ios_bvhn/model/user/login_form_model.dart';
import 'package:pos_ios_bvhn/model/user/user_model.dart';
import 'package:pos_ios_bvhn/provider/setting_provider.dart';
import 'package:pos_ios_bvhn/service/authen_service.dart';
import 'package:pos_ios_bvhn/sqflite/model/user_model_sqflite.dart';
import 'package:pos_ios_bvhn/sqflite/user_sqflite.dart';
import 'package:pos_ios_bvhn/ui/login/branch_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black26);

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final authService = new AuthRepository();

  FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }


  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Lỗi đăng nhập."),
        ],
      ),
    );


    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM_RIGHT,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    final loginSlogan = Container(
      child: Padding(
        padding: EdgeInsets.only(left: 0),
        child: Text("Order manager", style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.bold
        )),
      ),
    );

    final subLoginSlogan = Container(
      child: Padding(
        padding: EdgeInsets.only(),
        child: Text("Use the details provided to you by your account administrator."
            "Next time you will only need the username and the password.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black26
          )),
      ),
    );

    final emailField = Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 25,
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text("Username", style: TextStyle(
                color: Colors.blue
              )),
            ),
          ),
          Container(
            height: 43,
            child: TextFormField(
              obscureText: false,
              controller: emailController,
              style: style,
              decoration: InputDecoration(
                  hintText: "Enter Username ...",
                  contentPadding: EdgeInsets.only(left: 10),
                  fillColor: PrimaryBlackColor,
                  hintStyle: TextStyle(
                      fontSize: 16,
                      color: PrimaryGreyColor
                  ),
                  border: InputBorder.none
              ),
            ),
          )
        ],
      )
    );

    final passwordField = Container(
        height: 70,
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text("Password", style: TextStyle(
                    color: Colors.blue
                )),
              ),
            ),
            Container(
              height: 43,
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                style: style,
                decoration: InputDecoration(
                    hintText: "Enter password ...",
                    fillColor: PrimaryBlackColor,
                    contentPadding: EdgeInsets.only(left: 10),
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: PrimaryGreyColor
                    ),
                    border: InputBorder.none
                ),
              ),
            )
          ],
        )
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.blue,
      child: Container(
        height: 60,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () async {
            if (this._formKey.currentState.validate()) {
              // TODO: Auth
              print( "Email : " + emailController.text);
              print( "Password : " + passwordController.text);
               LoginFormModel loginFormModel = new LoginFormModel(emailController.text, passwordController.text);
               ResultModel res = await authService.login(loginFormModel.toJson());
               if(res.status) {
                 UserModel userInfo =  UserModel.fromJson(res.data);
                 Provider.of<SettingProvider>(context, listen: false).setUserInfo(userInfo);

                 // save data login in sqflite database
                 UserModelSqflite userLiteDate = new UserModelSqflite(
                   id: 1,
                   name: userInfo.name,
                   userName: userInfo.userName,
                   email: userInfo.email,
                   branchId: userInfo.branchId,
                   branchCode: userInfo.branchCode,
                   branchName: userInfo.branchName,
                   roleId: userInfo.roleId,
                   roleName: userInfo.roleName,
                   roleCode: userInfo.roleCode,
                 );

                 UserSqfLite userSqfLite = new UserSqfLite();

                 userSqfLite.insert(userLiteDate);

                 Navigator.push(context,
                     MaterialPageRoute(builder: (context) => BranchSelectionScreen())
                 );
               } else {
                 // TODO: AUTH FAILED
                 _showToast();
               }
            }
          },
          child: Text("Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );

    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 100),
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                    ),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            loginSlogan,
                            SizedBox(height: 10.0),
                            subLoginSlogan,
                            SizedBox(height: 10.0),
                            emailField,
                            SizedBox(height: 10.0),
                            passwordField,
                            SizedBox(height: 10.0,),
                            loginButton,
                            SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
