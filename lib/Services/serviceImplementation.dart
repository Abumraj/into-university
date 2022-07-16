import 'package:dio/dio.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'abstractService.dart';

String schoolBaseUrl = '';
String baseUrl = '';
String userType = '';
String token = '';
bool? isUserLoggedIn;
Dio _dio = Dio();

class ServiceImplementation implements HttpService {
  @override
  Future<Response> getRequest(String url) async {
    // ignore: unused_local_variable
    Response response;

    try {
      response = await _dio.get(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }));
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
    //print(response.data);
    return response;
  }

  Future getAuthCredentials() async {
    await Constants.getUerLoggedInSharedPreference().then((value) {
      isUserLoggedIn = value!;
    });
    await Constants.getUserTypeSharedPreference().then((value) {
      userType = value.toString();
    });
    await Constants.getUserSchoolSharedPreference().then((value) {
      schoolBaseUrl = value.toString();
    });

    await Constants.getUserTokenSharedPreference().then((value) {
      token = value.toString();
    });
    baseUrl = '$schoolBaseUrl/$userType';
  }

  // initializeInterceptors() {
  //   _dio.interceptors.add(InterceptorsWrapper(
  //       onError: (DioError err, ErrorInterceptorHandler handler) {
  //     print(
  //         'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
  //     //return super.onError(err, handler);
  //   }, onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
  //     print('REQUEST[${options.method}] => PATH: ${options.path}');
  //     //return super.onRequest(options, handler);
  //   }, onResponse: (Response response, ResponseInterceptorHandler handler) {
  //     print(
  //         'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
  //     //return (response, handler);
  //   }));
  // }

  @override
  void init() {
    getAuthCredentials();
    _dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }));
    //initializeInterceptors();
    //getRequest("/faculty");
  }

  @override
  Future<Response> postRequest(String url, data) async {
    // ignore: unused_local_variable
    Response response;

    try {
      response = await _dio.post(url,
          data: data,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }));
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
    return response;
  }
}
