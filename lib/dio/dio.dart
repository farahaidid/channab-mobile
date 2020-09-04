import 'package:channab/store/store.dart';
import 'package:dio/dio.dart';

Dio dio;

class Api{
  static BaseOptions options = new BaseOptions(
    baseUrl: "https://channab.com/api",
    connectTimeout: 5000,
    receiveTimeout: 3000,
    headers: {
      'x-api-key': '9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b',
    }
  );
  static void initialize(){
    dio = Dio(options);
    func();
  }

  static void func(){
    dio.interceptors.add(InterceptorsWrapper(
      onRequest:(RequestOptions options) async {
        if(Store.getToken() != null){
          dio.interceptors.requestLock.lock();
          options.headers["token"] = Store.getToken();
          dio.interceptors.requestLock.unlock();
        }
        return options;
      },
      onResponse:(Response response) async {
      // Do something with response data
      return response; // continue
      },
      onError: (DioError e) async {
      // Do something with response error
      return  e;//continue
      }
    ));
  }
}