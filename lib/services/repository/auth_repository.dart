import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nexprime/constant/app_api_url.dart';
import 'package:nexprime/services/api/api_services.dart';
import 'package:nexprime/services/api/non_auth_api.dart';
import 'package:nexprime/services/storage/storage_services.dart';
import 'package:nexprime/utils/app_log.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class AuthRepository {
  ////////////// Contractures
  AuthRepository._privetContractures();
  static final AuthRepository _instance = AuthRepository._privetContractures();
  static AuthRepository get instance => _instance;

  /////////////// object
  ApiServices apiServices = ApiServices.instance;
  NonAuthApi nonAuthApi = NonAuthApi();
  AppApiUrl api = AppApiUrl.instance;
  StorageServices storageServices = StorageServices.instance;
  /////////////// function
  Future<Map<String,dynamic>> login({
    required String email,
    required String password,
    //required String fcmToken, required String deviceId
  }) async {
    try {
      Map<String, String> bodyData = {
        "email": email.trim().toLowerCase(),
        "password": password.trim(),
        // "deviceId": deviceId.trim(),
        // "fcmToken": fcmToken.trim(),
      };

      var response = await nonAuthApi.sendRequest.post(
        api.login,
        data: bodyData,
      );

      if (response.data is Map) {
        if (response.data["access_token"] is String) {
          await storageServices.setToken(
            response.data["access_token"].toString(),
          );
        }
        if (response.data["refresh_token"] is String) {
          await storageServices.setRefreshToken(
            response.data["refresh_token"].toString(),
          );
        }
        if (response.data["user"] is Map) {
          var user = response.data["user"];
          if (user["role"] is String) {
            await storageServices.setAppRoll(user["role"].toString());
          }
        }

        return {
          "success": true,
          "data": response.data,
        };
      }
    } on DioException catch (e) {
      return {
        "success": false,
        "data": e.response?.data,
      };
    }
    catch (e) {
      errorLog("login function repo", e);
    }
    return {
      "success": false,
      "data": {
        "detail": "Login failed",
      },
    };
  }

  Future<bool> accountDelete({required String password}) async {
    try {
      Map<String, String> body = {"password": password};
      var response = await apiServices.deleteServices(
        url: api.authDeleteAccount,
        body: body,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("accountDelete AuthRepository", e);
    }
    return false;
  }

  Future<bool> updateProfile({
    required Map<String, dynamic> body,
    String? profileImagePath,
    String? coverImagePath,
  }) async {
    try {
      dynamic requestBody;

      if ((profileImagePath == null || profileImagePath.isEmpty) &&
          (coverImagePath == null || coverImagePath.isEmpty)) {
        // Send as JSON if no file paths are provided
        requestBody = body;
      } else {
        // Send as FormData if files are provided
        FormData formData = FormData();
        body.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            // Skip image URL keys if we are uploading files for them
            if (key == "profileImageUrl" &&
                profileImagePath != null &&
                profileImagePath.isNotEmpty) {
              return;
            }
            if (key == "coverImageUrl" &&
                coverImagePath != null &&
                coverImagePath.isNotEmpty) {
              return;
            }
            formData.fields.add(MapEntry(key, value.toString()));
          }
        });

        if (profileImagePath != null && profileImagePath.isNotEmpty) {
          final file = File(profileImagePath);
          if (await file.exists()) {
            String fileName = file.path.split('/').last;
            var mimeType = lookupMimeType(file.path);

            formData.files.add(
              MapEntry(
                "profileImageUrl",
                await MultipartFile.fromFile(
                  file.path,
                  filename: fileName,
                  contentType: MediaType.parse(
                    mimeType ?? "application/octet-stream",
                  ),
                ),
              ),
            );
          }
        }

        if (coverImagePath != null && coverImagePath.isNotEmpty) {
          final file = File(coverImagePath);
          if (await file.exists()) {
            String fileName = file.path.split('/').last;
            var mimeType = lookupMimeType(file.path);

            formData.files.add(
              MapEntry(
                "coverImageUrl",
                await MultipartFile.fromFile(
                  file.path,
                  filename: fileName,
                  contentType: MediaType.parse(
                    mimeType ?? "application/octet-stream",
                  ),
                ),
              ),
            );
          }
        }
        requestBody = formData;
      }

      var response = await apiServices.patchServices(
        url: api.updateProfile,
        body: requestBody,
      );

      return response != null;
    } catch (e) {
      errorLog("updateProfile repo", e);
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      Map<String, String> body = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      var response = await apiServices.postServices(
        url: api.changePassword,
        body: body,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("changePassword repo", e);
    }
    return false;
  }

  Future<bool> customerSignUp({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String frontImage,
    required String backImage,
  }) async {
    try {
      final futures = [
        MultipartFile.fromFile(
          frontImage,
          filename: frontImage.split('/').last,
        ),
        MultipartFile.fromFile(
          backImage,
          filename: backImage.split('/').last,
        ),
      ];

      final files = await Future.wait(futures);

      FormData formBodyData = FormData.fromMap({
        "fullname": fullName,
        "email": email,
        "phonenumber": phoneNumber,
        "password": password,
        "residentcard_frontside": files[0],
        "residentcard_backside": files[1],
      });

      var response = await apiServices.postServices(
        url: api.customerSignUp,
        body: formBodyData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("customer signUp repo", e);
    }
    return false;
  }

  Future<bool> vendorSignUp({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String storeName,
    required String storeBio,
    required String storeAddress,
    required String frontImage,
    required String backImage,
    required String storePhoto,
    required String kycDocument,
  }) async {
    try {
      final futures = [
        MultipartFile.fromFile(
          frontImage,
          filename: frontImage.split('/').last,
        ),
        MultipartFile.fromFile(
          backImage,
          filename: backImage.split('/').last,
        ),
        MultipartFile.fromFile(
          storePhoto,
          filename: storePhoto.split('/').last,
        ),
        MultipartFile.fromFile(
          kycDocument,
          filename: kycDocument.split('/').last,
        ),
      ];

      final files = await Future.wait(futures);

      FormData formBodyData = FormData.fromMap({
        "fullname": name,
        "email": email,
        "phonenumber": phoneNumber,
        "password": password,
        "store_name": storeName,
        "store_bio": storeBio,
        "store_address": storeAddress,
        "residentcard_frontside": files[0],
        "residentcard_backside": files[1],
        "store_photo": files[2],
        "kyc_document": files[3],
      });

      var response = await apiServices.postServices(
        url: api.vendorSignUp,
        body: formBodyData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("vendor signUp repo", e);
    }
    return false;
  }

  Future<bool> authResendOTP({required String email}) async {
    try {
      var response = await apiServices.postServices(
        url: api.userResendOtp,
        body: {"email": email},
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("authResendOTP", e);
    }
    return false;
  }

  Future<bool> authOtpVerify({
    required String email,
    required String otp,
  }) async {
    try {
      Map<String, dynamic> bodyData = {"email": email, "code": otp};
      var response = await apiServices.postServices(
        url: api.authOtpVerify,
        body: bodyData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("authOtpVerify", e);
    }
    return false;
  }

  ////////// forgot
  Future<bool> forgotPassword({required String email}) async {
    try {
      Map<String, String> bodyData = {"email": email};
      var response = await apiServices.postServices(
        url: api.authForgotPassword,
        body: bodyData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("forgotPassword repo", e);
    }
    return false;
  }

  Future<String> forgotVerifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      Map<String, dynamic> bodyData = {"email": email, "code": otp};
      var response = await apiServices.postServices(
        url: api.authVerifyEmail,
        body: bodyData,
      );
      if (response != null) {
        if (response["reset_token"] != null &&
            response["reset_token"] != null) {
          return response["reset_token"].toString();
        }
      }
    } catch (e) {
      errorLog("forgotPassword repo", e);
    }
    return "";
  }

  Future<bool> forgotResetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      Map<String, dynamic> bodyData = {
        "reset_token": token,
        "new_password": newPassword,
      };
      var response = await nonAuthApi.sendRequest.post(
        api.authResetPassword,
        data: bodyData,
        options: Options(
          headers: {"Content-Type": "application/json", "Accept": "*/*"},
        ),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      errorLog("forgotPassword repo", e);
    }
    return false;
  }
}
