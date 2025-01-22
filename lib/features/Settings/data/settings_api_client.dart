import 'dart:convert';
import 'dart:developer';

import '../../../core/api_helper/api_helper.dart';
import '../../../core/common/Resource.dart';
import '../../../core/common/Status.dart';
import '../../../core/shared_pref/shared_pref.dart';
import '../../../core/utils/Utils.dart';
import '../../../core/utils/api_constants.dart';
import '../../../core/utils/const.dart';
import '../../auth/Login/model/login_otp_verification_model.dart';

class SettingsApiClientImpl {
  Future<Resource> addTaxTable(
      {required String taxMasterName,
       required String taxMasterRate
      }) async {
    try {
      Utils().printMessage("here im");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils().printMessage("here im");
      // var body = {
      //   "deviceId": deviceDetails[0],
      //   "deviceType": deviceDetails[1],
      //   "appVersion": deviceDetails[2],
      //   "tenantId": loginData!.tenantId,
      //   "custFName": firstName,
      //   "custLName": lastName,
      //   "custEmail": email,
      //   "custPhNo": phone,
      //   "companyId": loginData!.cOMPANYID.toString(),
      //   "custAddress":custAddress,
      //   "custCompanyName":custCompanyName,
      //   "questionData" : serviceEntity['data'],
      // };

      var body = {
        "tenantId": loginData!.tenantId,
        "userId": userId,
        "taxMasterName": taxMasterName,
        "taxMasterRate": taxMasterRate
      };

      log("ADD_TAX MASTER_BODY==>${jsonEncode(body)}");
      String value = jsonEncode(body);
      print(value);
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.ADD_TAX_TABLE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + token.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            return Resource(
                status: STATUS.SUCCESS,
                data: response.data["data"],
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
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }
}
