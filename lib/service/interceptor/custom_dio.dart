import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../authen_service.dart';
import 'cache_interceptor.dart';

class CustomDio {

  Dio dio = new Dio();

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
          print('REQUEST[${options.method}] => PATH: ${options.path}');
           SharedPreferences prefs = await SharedPreferences.getInstance();
           String token = prefs.getString('token');
           if(token != null && options != null) {
             options.headers["Authorization"] = "Bearer " + token;
           }
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) async {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions?.path}');
          return handler.next(response);
        },
        onError: (DioError err, ErrorInterceptorHandler handler) async {
          print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions?.path}');
          if(err.response?.statusCode == 401 || err.response?.statusCode == 402) {
            print("Auth failed");
            // final authRepository = new AuthRepository();
            // await authRepository.refreshToken();
            // return _retry(err.requestOptions);
          }
          return handler.next(err);
        }
      )
   );
   // dio.interceptors.add(CacheInterceptors());
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options =  new Options(
      method: requestOptions.method,
      headers: requestOptions.headers
    );

    return this.dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options
    );
  }

}
