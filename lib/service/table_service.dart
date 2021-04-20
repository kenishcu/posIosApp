import 'package:dio/dio.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';

import '../constants.dart';
import 'interceptor/custom_dio.dart';

class TableService {

  CustomDio client = new CustomDio();

  Future<ResultModel> getTablePositions(String branchId) async {
    try {
      Response response = await client.dio.request(
          API_URL + '/table-positions?status=-1&branch_id=${branchId.toString()}',
          data: {'n': '','p':'', 'query': ''},
          options: Options(method: 'GET')
      );
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("error: ");
      throw (e.message);
    }
  }

  Future<ResultModel> getTableDataByPosition(String branchId, String positionId) async {
    try {
      Response response = await client.dio.request(
          API_URL + '/tables?status=-1&branch_id=${branchId.toString()}&position_id=${positionId.toString()}',
          data: {'n': '','p':'', 'query': ''},
          options: Options(method: 'GET')
      );
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("error: ");
      throw (e.message);
    }
  }
}