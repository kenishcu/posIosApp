import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';
import 'package:pos_ios_bvhn/service/interceptor/custom_dio.dart';

import '../constants.dart';

class RestaurantService {

  CustomDio client = new CustomDio();

  Future<ResultModel> getProductsByParams(String branchId, String parentId,
      String categoryId, String query, int p, int n) async {
    try {
      Response response = await client.dio.request(
          API_URL + '/product-in-menu?branch_id=${branchId.toString()}'
              '&category_id=${categoryId.toString()}'
              '&category_parent_id=${parentId.toString()}&query=${query.toString()}',
          data: {'n': 1,'p': 50},
          options: Options(method: 'GET')
      );
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("error: ");
      throw (e.message);
    }
  }


  Future<ResultModel> getCategoryRestaurantById(String branchId, String parentId) async {
    try {
      Response response = await client.dio.request(
          API_URL + '/categories?parent_id=${parentId.toString()}&branch_id=${branchId.toString()}',
          data: {'n': 1,'p': 50},
          options: Options(method: 'GET')
      );
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("error: ");
      throw (e.message);
    }
  }

  Future<ResultModel>  getCategoryParentRestaurant() async {
    try {
      String data = await rootBundle.loadString('lib/data/category_restaurant.json');
      return ResultModel.fromJson(json.decode(data));
    } on DioError catch (e) {
      print("error: ");
      throw (e.message);
    }
  }
}