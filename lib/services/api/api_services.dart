import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/services/api/api.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:nexprime/utils/app_snack_bar.dart';

class ApiServices {
  ///////////////
  ApiServices._privateConstructor();
  static final ApiServices _instance = ApiServices._privateConstructor();
  static ApiServices get instance => _instance;
  //////////  object
  final api = AppApi();
  var storageServices = StorageServices.instance;
  final appRoutes = AppRoutes.instance;

  // services

  Future<dynamic> putServices({required String url, dynamic body, int statusCode = 200, Map<String, dynamic>? query}) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      final response = await api.sendRequest.put(url, data: body, queryParameters: query);
      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      if (e.response.runtimeType != Null) {
        if (e.response?.data["message"].runtimeType != Null) {
          AppSnackBar.instance.error("${e.response?.data["message"]}");
        }

        return null;
      }
      errorLog('api dio exception', e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> postServices({
    required String url,
    dynamic body,
    int statusCodeStart = 200,
    int statusCodeEnd = 299,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      Options? requestOptions = options;
      if (body is FormData) {
        requestOptions = Options(contentType: 'multipart/form-data');
      } else {
        requestOptions = Options(contentType: 'application/json');
      }

      final dynamic response = await AppApi().sendRequest.post(url, data: body, queryParameters: query, options: requestOptions);
      if (response.statusCode >= statusCodeStart && response.statusCode <= statusCodeEnd) {
        return response.data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      if (e.response.runtimeType != Null) {
        if (e.response?.statusCode == 401) {
          await storageServices.logout(route: AppRoutesKey.instance.initial);
          // appRoutes.pushReplacement(AppRoutesKey.instance.initial);
        }

        if (e.response?.data["message"].runtimeType != Null) {
          AppSnackBar.instance.error("${e.response?.data["message"]}");
        }
        if (e.response?.data["detail"].runtimeType != Null) {
          AppSnackBar.instance.error("${e.response?.data["detail"]}");
        }

        return null;
      }
      errorLog('api dio exception', e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> getServices(String url, {int statusCode = 200, Map<String, dynamic>? queryParameters, dynamic body}) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      final response = await api.sendRequest.get(url, queryParameters: queryParameters, data: body);
      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      if (e.response.runtimeType != Null) {
        if (e.response?.data["message"].runtimeType != Null) {
          AppSnackBar.instance.error("${e.response?.data["message"]}");
        }

        return null;
      }
      errorLog('api dio exception', e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> patchServices({required String url, Object? body, int statusCode = 200, Map<String, dynamic>? query, Options? options}) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      Options? requestOptions = options;
      if (body is FormData) {
        requestOptions = Options(contentType: 'multipart/form-data');
      } else {
        requestOptions = Options(contentType: 'application/json');
      }
      final response = await api.sendRequest.patch(url, data: body, queryParameters: query, options: requestOptions);

      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        AppSnackBar.instance.error("Unexpected response: ${response.statusCode} ${response.statusMessage}");
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      if (e.response.runtimeType != Null) {
        if (e.response?.data["message"].runtimeType != Null) {
          AppSnackBar.instance.error("${e.response?.data["message"]}");
        }

        return null;
      }
      errorLog('api dio exception', e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }

  Future<dynamic> deleteServices({required String url, Object? body, int statusCode = 200, Map<String, dynamic>? query, Options? options}) async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      final response = await api.sendRequest.delete(url, data: body, queryParameters: query, options: options);

      if (response.statusCode == statusCode) {
        return response.data;
      } else {
        AppSnackBar.instance.error("Unexpected response: ${response.statusCode} ${response.statusMessage}");
        return null;
      }
    } on SocketException catch (e) {
      errorLog('api socket exception', e);
      AppSnackBar.instance.error("Check Your Internet Connection");
      return null;
    } on TimeoutException catch (e) {
      errorLog('api time out exception', e);
      return null;
    } on DioException catch (e) {
      if (e.response.runtimeType != Null) {
        if (e.response?.data["message"].runtimeType != Null) {
          AppSnackBar.instance.error("${e.response?.data["message"]}");
        }
        return null;
      }
      errorLog('api dio exception', e);
      return null;
    } catch (e) {
      errorLog('api exception', e);
      return null;
    }
  }
}
