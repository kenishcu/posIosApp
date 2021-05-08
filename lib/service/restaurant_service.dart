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
          options: Options(method: 'GET')
      );
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("error: ");
      throw (e.message);
    }
  }


  Future<ResultModel> getCategoryRestaurantByParams(String branchId, String parentId, String keyword, status) async {
    try {
      Response response = await client.dio.request(
          API_URL + '/categories?parent_id=${parentId.toString()}&branch_id=${branchId.toString()}'
              '&keyword=${keyword.toString()}&status=${status.toString()}',
          options: Options(method: 'GET')
      );
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("error: ");
      throw (e.message);
    }
  }

  Future<ResultModel> getCategoryParentRestaurant() async {
    try {
      String data = await rootBundle.loadString('lib/data/category_restaurant.json');
      return ResultModel.fromJson(json.decode(data));
    } on DioError catch (e) {
      print("error: ");
      throw (e.message);
    }
  }

  Future<ResultModel> orderFood(Map<String, dynamic> data) async {
    try {
      Response response = await client.dio.request(
          API_URL + '/reservation/order',
          data: data,
          options: Options(method: 'POST')
      );
      print(response.data);
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("errors: ");
      throw (e.message);
    }
  }

  Future<ResultModel> reOrderFood(Map<String, dynamic> data, String orderId) async {
    try {Response response = await client.dio.request(
          API_URL + '/reservation/order/${orderId.toString()}',
          data: data,
          options: Options(method: 'PUT')
      );
      print(response.data);
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("errors: ");
      throw (e.message);
    }
  }

  Future<ResultModel> getOrderByTable(String tableId) async {
    try {
      Response response = await client.dio.request(
          API_URL + '/reservation/order-by-table?table_id=${tableId.toString()}',
          options: Options(method: 'GET')
      );
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("errors: ");
      throw (e.message);
    }
  }
}
