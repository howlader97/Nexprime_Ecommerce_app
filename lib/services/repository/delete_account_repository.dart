import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/services/api/api.dart';
import 'package:nexprime/utils/app_log.dart';

class DeleteAccountRepository {
  DeleteAccountRepository._privateConstructor();
  static final DeleteAccountRepository _instance = DeleteAccountRepository._privateConstructor();
  static DeleteAccountRepository get instance => _instance;

  final AppApiUrl _apiUrl = AppApiUrl.instance;

  Future<({bool success, String message})> deleteAccount() async {
    try {
      final String fullUrl = "${AppApiUrl.instance.baseUrl}${_apiUrl.deleteAccount}";
      final response = await AppApi().sendRequest.delete(fullUrl);

      String responseMessage = "";
      if (response.data is Map) {
        responseMessage = response.data["message"]?.toString() ?? "";
      } else if (response.data is String) {
        try {
          final decoded = jsonDecode(response.data);
          if (decoded is Map) {
            responseMessage = decoded["message"]?.toString() ?? "";
          }
        } catch (_) {}
      }

      if (response.statusCode == 200 || response.statusCode == 204) {
        return (success: true, message: responseMessage);
      } else {
        return (success: false, message: responseMessage);
      }
    } on DioException catch (e) {
      errorLog("deleteAccount DioException", e);
      String errorMessage = "";
      if (e.response?.data is Map) {
        final errorData = e.response!.data as Map;
        errorMessage = errorData["message"]?.toString() ??
            errorData["detail"]?.toString() ??
            errorData["error"]?.toString() ??
            "";
      } else if (e.response?.data is String) {
        try {
          final decoded = jsonDecode(e.response!.data);
          if (decoded is Map) {
            errorMessage = decoded["message"]?.toString() ??
                decoded["detail"]?.toString() ??
                decoded["error"]?.toString() ??
                "";
          }
        } catch (_) {
          errorMessage = e.response?.data?.toString() ?? "";
        }
      }
      return (success: false, message: errorMessage);
    } catch (e) {
      errorLog("deleteAccount Exception", e);
      return (success: false, message: e.toString());
    }
  }
}
