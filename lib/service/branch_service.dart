import 'package:dio/dio.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';

import '../constants.dart';
import 'interceptor/custom_dio.dart';

class BranchService {

  CustomDio client = new CustomDio();

  Future<ResultModel> getAllBranches() async {
    try {
      Response response = await client.dio.request(
          API_URL + '/branches?status=1',
          data: {'n': '','p':'', 'query': ''},
          options: Options(method: 'GET')
      );
      print(response.data);
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("error: ");
      throw (e.message);
    }
  }

  Future<ResultModel> getBranchInformation(String branchId) async {
    try {
      Response response = await client.dio.request(
          API_URL + '/branch/${branchId.toString()}',
          options: Options(method: 'GET')
      );
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("error: ");
      throw (e.message);
    }
  }
}
