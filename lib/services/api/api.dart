import 'package:dio/dio.dart';

class Api {
  late final Dio _dio;

  Api() {
    _dio = Dio();
  }

  Future<Response<dynamic>> get(String path) async {
    return await _dio.get(path);
  }

  Future<Response<dynamic>> delete(String path) async {
    return await _dio.delete(path);
  }

  Future<Response<dynamic>> put(String path, {Object? data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response<dynamic>> patch(String path, {Object? data}) async {
    return await _dio.patch(path, data: data);
  }

  Future<Response<dynamic>> post(String path, {Object? data}) async {
    return await _dio.post(path, data: data);
  }
}