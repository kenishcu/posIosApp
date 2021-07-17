import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pos_ios_bvhn/app.dart';
import 'package:pos_ios_bvhn/components/navigator_custom.dart';
import 'package:pos_ios_bvhn/sqflite/user_sqflite.dart';
import 'package:pos_ios_bvhn/ui/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../authen_service.dart';
import 'cache_interceptor.dart';

class CustomDio extends Interceptor {

  Dio dio = new Dio();

  NavigatorCustom navigatorCustom =  new NavigatorCustom();

  CustomDio() {
    // set up basic options header
    BaseOptions options = new BaseOptions(
        connectTimeout: CONNECT_TIME_OUT,
        receiveTimeout: RECEIVE_TIME_OUT,
        baseUrl: API_URL,
        headers: {
          "content-Type": "application/json"
        }
    );

   dio.options = options;
   dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          // print('REQUEST[${options.method}] => PATH: ${options.path}');
           SharedPreferences prefs = await SharedPreferences.getInstance();
           String token = prefs.getString('token');
           if(token != null && options != null) {
             options.headers["Authorization"] = "Bearer " + token;
           }
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) async {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions?.path}');
          if (response.statusCode == 200 && response.data != null && response.data['token'] != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('token', response.data['token']);
          }
          return handler.next(response);
        },
        onError: (DioError err, ErrorInterceptorHandler handler) async {
          print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions?.path}');
          if(err.message == 'HttpException: Failed to parse header value') {
            UserSqfLite userSqfLite = new UserSqfLite();
            await userSqfLite.delete(1);
            navigatorCustom.toLogin();
          }
          return handler.next(err);
        }
      )
   );
  }

}
