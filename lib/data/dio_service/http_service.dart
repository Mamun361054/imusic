import 'dart:io';

import 'package:dhak_dhol/data/api/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../utils/shared_pref.dart';

String errorMessage = '';

class HttpServiceImpl {
  late Dio _dio;

  Future<Response> getRequest(String url) async {
    final token = await SharedPref.getValue(SharedPref.keyToken);
    print("user token${token.toString()}");
    debugPrint('url $url');
    Response response;
    try {
      response = await _dio.get(url,
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));
      debugPrint('response $response');
    } on DioError catch (e) {
      debugPrint(e.message.toString());
      throw Exception(e.message);
    }
    return response;
  }

  Future<Response> postRequest(String url, data) async {
    final token = await SharedPref.getValue(SharedPref.keyToken);
    print("user token${token}");

    Response response;
    debugPrint('url $url');
    errorMessage = '';
    try {
      response = await _dio.post(url,
          data: data,
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));
      debugPrint('Post postRequest ${response.data}');
    } on DioError catch (e) {
      errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(errorMessage.toString());
      throw Exception(e.error);
    }
    return response;
  }

  Future<Response> deleteRequest(String url) async {
    final token = await SharedPref.getValue(SharedPref.keyToken);
    print("user token${token.toString()}");
    debugPrint('url $url');
    Response response;
    try {
      response = await _dio.delete(url,
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));
      debugPrint('response $response');
    } on DioError catch (e) {
      debugPrint(e.message.toString());
      throw Exception(e.message);
    }
    return response;
  }

  void init() {
    _dio = Dio(
      BaseOptions(baseUrl: ApiProvider.domain, headers: {
        Headers.contentTypeHeader: 'application/json',
      }),
    );
  }
}

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.unknown:
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
            dioError.response!.statusCode!, dioError.response!.data);
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  late String message;

  String _handleError(int statusCode, dynamic error) {
    print('error ${error}');
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return error["message"];
      case 500:
        return 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
