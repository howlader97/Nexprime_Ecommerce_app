import 'dart:convert';
import 'package:nexprime/main_app_entry.dart';
import 'package:nexprime/routes/app_routes.dart';
import 'package:nexprime/routes/app_routes_key.dart';
import 'package:nexprime/services/storage/storage_key.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  StorageServices._privateConstructor();
  static final StorageServices _instance =
      StorageServices._privateConstructor();
  static StorageServices get instance => _instance;

  ////////////// storage initial
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  /////////////////// user login data store
  Future<void> setLogDedData(Map<String, String> data) async {
    try {
      final pref = await _pref;
      var formateData = jsonEncode(data);
      await pref.setString(StorageKey.instance.loginDataStore, formateData);
    } catch (e) {
      errorLog("setLogDedData data", e);
    }
  }

  Future<Map> getLogDedData() async {
    try {
      final pref = await _pref;

      // return _box.read(StorageKey.instance.loginDataStore) ?? {};
      var response = pref.getString(StorageKey.instance.loginDataStore) ?? "";
      return jsonDecode(response);
    } catch (e) {
      errorLog("getLogDedData", e);
      return {};
    }
  }

  ////////////// token storage
  Future<void> setToken(String value) async {
    final pref = await _pref;
    await pref.setString(StorageKey.instance.token, value);
  }

  Future<String> getToken() async {
    try {
      final pref = await _pref;
      return pref.getString(StorageKey.instance.token) ?? "";
    } catch (e) {
      errorLog("get token", e);
      return "";
    }
  }

  Future<int> getUserId() async {
    try {
      final token = await getToken();
      if (token.isEmpty) return 0;
      final parts = token.split('.');
      if (parts.length < 2) return 0;

      var payload = parts[1];
      final padLength = 4 - (payload.length % 4);
      if (padLength < 4) {
        payload += '=' * padLength;
      }

      final payloadStr = utf8.decode(base64Url.decode(payload));
      final decoded = jsonDecode(payloadStr);
      return int.tryParse(decoded['sub'].toString()) ?? 0;
    } catch (e) {
      errorLog("getUserId error", e);
      return 0;
    }
  }

  Future<void> setEmail(String value) async {
    final pref = await _pref;
    await pref.setString(StorageKey.instance.email, value);
  }

  Future<String> getEmail() async {
    try {
      final pref = await _pref;
      return pref.getString(StorageKey.instance.email) ?? "";
    } catch (e) {
      errorLog("get email", e);
      return "";
    }
  }

  ////////////// reset token
  Future<void> setResetToken(String value) async {
    final pref = await _pref;
    await pref.setString(StorageKey.instance.resetToken, value);
  }

  Future<String> getResetToken() async {
    try {
      final pref = await _pref;
      return pref.getString(StorageKey.instance.resetToken) ?? "";
    } catch (e) {
      errorLog("get resetToken", e);
      return "";
    }
  }

  ////////////// refresh token
  Future<void> setRefreshToken(String value) async {
    final pref = await _pref;
    await pref.setString(StorageKey.instance.refreshToken, value);
  }

  Future<String> getRefreshToken() async {
    try {
      final pref = await _pref;
      return pref.getString(StorageKey.instance.refreshToken) ?? "";
    } catch (e) {
      errorLog("get refreshToken", e);
      return "";
    }
  }

  /// Logout (clear all data)
  Future<void> logout({String? route}) async {
    try {
      final pref = await _pref;
      await pref.setString(StorageKey.instance.refreshToken, "");
      await pref.setString(StorageKey.instance.token, "");
      await pref.setString(StorageKey.instance.appUserRollData, "");

      AppRoutes.instance.go(route ?? AppRoutesKey.instance.signInScreen);

      Future.delayed(const Duration(milliseconds: 600), () {
        mainAppKey.currentState?.resetRiverpod();
      });
    } catch (e) {
      errorLog("logout", e);
    }
  }

  //////////// language
  Future<String> getLanguage() async {
    final pref = await _pref;
    return pref.getString(StorageKey.instance.language) ?? "";
  }

  Future<void> setLanguage(String value) async {
    final pref = await _pref;
    await pref.setString(StorageKey.instance.language, value);
  }

  //////////// app role
  Future<String> getAppRoll() async {
    final pref = await _pref;
    return pref.getString(StorageKey.instance.appUserRollData) ?? "CUSTOMER";
  }

  Future<void> setAppRoll(String value) async {
    final pref = await _pref;
    await pref.setString(StorageKey.instance.appUserRollData, value);
  }

  //////////// first time flag
  Future<bool> getAppFirstTime() async {
    final pref = await _pref;
    return pref.getBool(StorageKey.instance.appFirstTime) ?? true;
  }

  Future<void> setAppFirstTime() async {
    try {
      final pref = await _pref;
      await pref.setBool(StorageKey.instance.appFirstTime, false);
    } catch (e) {
      errorLog("setAppFirstTime", e);
    }
  }

  //////////// dark mode
  Future<bool> isDarkMode() async {
    final pref = await _pref;
    return pref.getBool(StorageKey.instance.isDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final pref = await _pref;
    await pref.setBool(StorageKey.instance.isDarkMode, value);
  }
}
