import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pos_ios_bvhn/constants.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';
import 'package:pos_ios_bvhn/service/interceptor/custom_dio.dart';

class AuthRepository {

  CustomDio client = new CustomDio();

  Future<ResultModel> login(Map<String, dynamic> data) async {
    try {
      Response response = await client.dio.request(
          API_URL + '/login',
        data: data,
        options: Options(method: 'POST')
      );
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("error: ");
      print (e.message);
      return ResultModel("", null, null, false);
    }
  }

  Future<Map> logout() async {
    try {
      Response response = await client.dio.get(
        API_URL + '/logout',
      );
      return response.data;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<void> refreshToken() async {
    // get data config in storage
    Map<String, dynamic> data;

    // send config to refresh token
    Response response = await client.dio.post(
      '/settings',
      data: data
    );

    if (response.statusCode == 200) {
      // save token to storage
    }
  }
}
