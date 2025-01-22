import 'dart:convert';

import 'package:bizfns/core/api_helper/api_helper.dart';
import 'package:bizfns/core/common/Resource.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/common/Status.dart';
import '../../../core/shared_pref/shared_pref.dart';
import '../../../core/utils/Utils.dart';
import '../../../core/utils/api_constants.dart';
import '../../../core/utils/const.dart';
import '../../auth/Login/model/login_otp_verification_model.dart';
import '../model/get_profile_model.dart';
import 'profile_repo.dart';

// class ProfileApiClientImpl {
//   // ProfileApiClientImpl({required super.apiClient});

//   @override
//   Future<Resource> getProfile() async{
//    Utils().printMessage("here im fetching getProfile");
//    Resource data = await apiClient.getProfile();
//    if (data.status ==STATUS.SUCCESS ) {
//      Utils().printMessage("Profile fetch is successful");
//    } else{
//      Utils().printMessage("Can not fetch Profile");
//    }
//    return data;
//   }

// }

class ProfileApiClientImpl {
  //-----------------here i'm getting profileData---------------------//
  Future<Resource> getProfile() async {
    try {
      Utils().printMessage("here im in getProfile");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      String? userId = await GlobalHandler.getUserId();
      var body = {
        "tenantId": loginData!.tenantId,
        "userId": userId,
        "businessEmail": loginData!.cOMPANYBACKUPEMAIL
      };
      Utils().printMessage("GET_PROFILE_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.GET_PROFILE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});
      Utils().printMessage("GET_PROFILE RESPONSE =====>${jsonEncode(response.data)}");
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;
          GetProfileModel resp = GetProfileModel.fromJson(data);
          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e, stackTrace) {
      Utils().printMessage('Catch Error $e $stackTrace');
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //---------------------here i'm setting profile data------------------------//
  Future<Resource> setProfile(
      {required String businessName,
      required String businessLogo,
      required String marketingDescription,
      required List<String> addLocation,
      required String address,
      required String businessContactPerson,
      required String trustedBackupMobileNumber,
      required String trustedBackupEmail,
      required String businessEmail}) async {
    try {
      Utils().printMessage("here im setting Profile");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      String? userId = await GlobalHandler.getUserId();
      var body = {
        "userId": userId,
        "tenantId": loginData!.tenantId,
        "businessNameAndLogo": {
          "businessName": businessName,
          "businessLogo": businessLogo
        },
        "marketing": {
          "marketingDescription": marketingDescription,
          "addLocation": addLocation
        },
        "address": address,
        "businessContactPerson": businessContactPerson,
        "trustedBackupMobileNumber": trustedBackupMobileNumber,
        "trustedBackupEmail": trustedBackupEmail,
        "businessEmail": businessEmail
      };
      Utils().printMessage("Set profile body==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");

      // return Resource(
      //     status: STATUS.SUCCESS,
      //     data: 'resp',
      //     message: 'response.data["message"]');
      var response = await ApiHelper().apiCall(
          url: Urls.SET_PROFILE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer $token"});

      Utils().printMessage("SET_PROFILE RESPONSE =====>${response.data}");
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> data = response.data as Map<String, dynamic>;
          GetProfileModel resp = GetProfileModel.fromJson(data);
          return Resource(
              status: STATUS.SUCCESS,
              data: resp,
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e, stackTrace) {
      Utils().printMessage('Catch Error $e $stackTrace');
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> uploadBusinessLogo({required XFile? image}) async {
    try {
      Utils().printMessage("here im uploading profile image");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      String? userId = await GlobalHandler.getUserId();
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      var file = MultipartFile.fromFileSync(image!.path,
          filename: '$timestamp${image.name}');

      final formData = FormData.fromMap({
        'businessLogo': file,
        'tenantId': loginData!.tenantId,
        'userId': userId
      });

      String? token = await GlobalHandler.getToken();
      if (token == null) {
        token = loginData.token ?? "";
        await GlobalHandler.setToken(token);
      }

      var response = await ApiHelper().apiCallForImage(
          url: Urls.UPLOAD_BUSINESS_LOGO,
          body: formData,
          header: {"Authorization": "Bearer $token"});

      return Resource(
          status: STATUS.SUCCESS, data: response, message: 'Success');
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> verifyPassword({required String password}) async {
    try {
      Utils().printMessage("here im verifying password");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      String? userId = await GlobalHandler.getUserId();

      var body = {
        "userId": userId,
        "tenantId": loginData!.tenantId,
        "verifyPassword": password
      };

      print("Verify-password josnBody ===>${jsonEncode(body)}");

      String? token = await GlobalHandler.getToken();
      if (token == null) {
        token = loginData!.token ?? "";
        await GlobalHandler.setToken(token);
      }

      var response = await ApiHelper().apiCall(
          url: Urls.VERIFY_PASSWORD,
          body: body,
          header: {"Authorization": "Bearer $token"},
          requestType: RequestType.POST);

      if (response != null && response.status == STATUS.SUCCESS) {
        print(response.data["success"]);
        if (response.data["success"] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response,
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> getOtpForMobileChanges() async {
    try {
      Utils().printMessage("here im getting otp");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      String? userId = await GlobalHandler.getUserId();

      var body = {
        "tenantId": loginData!.tenantId,
        "oldMobileNumber": loginData!.cOMPANYBACKUPPHONENUMBER,
        "companyId": loginData!.cOMPANYID.toString()
      };

      print("here im getting otp josnBody ===>${jsonEncode(body)}");

      String? token = await GlobalHandler.getToken();
      if (token == null) {
        token = loginData!.token ?? "";
        await GlobalHandler.setToken(token);
      }

      var response = await ApiHelper().apiCall(
          url: Urls.GET_OTP_FOR_MOBILE_CHANGE,
          body: body,
          header: {"Authorization": "Bearer $token"},
          requestType: RequestType.POST);

      if (response != null && response.status == STATUS.SUCCESS) {
        print(response.data["success"]);
        if (response.data["success"] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response,
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }
  // saveChangesMobile

  Future<Resource> saveChangesMobile(
      {required String newMobileNumber, required String otp}) async {
    try {
      Utils().printMessage("here im changing mobile");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      String? userId = await GlobalHandler.getUserId();

      var body = {
        "tenantId": loginData!.tenantId,
        "oldMobileNumber": loginData.cOMPANYBACKUPPHONENUMBER,
        "newMobileNumber": newMobileNumber,
        "companyId": loginData.cOMPANYID.toString(),
        "otp": otp.toString()
        // "otpTimeStamp":"1709724991607.924000"
      };

      print(
          "here im getting saveChangesMobile josnBody ===>${jsonEncode(body)}");

      String? token = await GlobalHandler.getToken();
      if (token == null) {
        token = loginData!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      // return Resource(
      //     status: STATUS.SUCCESS, data: "response", message: "response.data");

      var response = await ApiHelper().apiCall(
          url: Urls.SAVE_CHANGES_MOBILE_NO,
          body: body,
          header: {"Authorization": "Bearer $token"},
          requestType: RequestType.POST);

      if (response != null && response.status == STATUS.SUCCESS) {
        print(response.data["success"]);
        if (response.data["success"] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response,
              message: response.data["message"]);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        if (response.data.toString() == "403") {
          return Resource.error(message: TOKEN_EXPIRED);
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }
}
