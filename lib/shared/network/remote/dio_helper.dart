import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper {
  static Dio? dio;
  static Map headers = <String, dynamic>{};
  static init() {
    print('Befor Dio Running....');

    dio = Dio(BaseOptions(
      baseUrl: 'https://student.valuxapps.com/api/',
      receiveDataWhenStatusError: true,

      // contentType: 'application/json', // Added contentType here
      //headers: headers as Map<String, dynamic>?,
    ));

    print('After Dio Running....');
  }

  static Future<Response> getData({
    @required String? path,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return await dio!.get(
      '$path',
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    @required String? path,
    Map<String, dynamic>? query,
    @required Map<String, dynamic>? data,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'contentType': 'application/json',
    };

    return await dio!.post(
      path!,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    @required String? path,
    Map<String, dynamic>? query,
    @required Map<String, dynamic>? data,
    String lang = 'en',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'contentType': 'application/json',
    };

    return await dio!.put(
      path!,
      queryParameters: query,
      data: data,
    );
  }
}
