import 'package:dio/dio.dart';
import 'package:pos_ios_bvhn/model/results_model.dart';

import '../constants.dart';
import 'interceptor/custom_dio.dart';

class PartnerCustomerService {
  CustomDio client = new CustomDio();

  Future<ResultModel> getPartners(String keyword) async {
    try {
      Response response = await client.dio.request(
          API_URL + '/reservation/partner-customers?partner_customer_name=${keyword.toString()}',
          options: Options(method: 'GET')
      );
      return ResultModel.fromJson(response.data);
    } on DioError catch (e) {
      print("error: ");
      throw (e.message);
    }
  }
}
