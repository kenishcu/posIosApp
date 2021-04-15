import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheInterceptors extends InterceptorsWrapper{

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO: implement onRequest
    return options;
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    return response;
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // TODO: implement onError
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.containsKey('token')) {

    }
  }
}
