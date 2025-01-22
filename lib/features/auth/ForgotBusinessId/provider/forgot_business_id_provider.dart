import 'dart:async';
import 'dart:convert';

import 'package:bizfns/core/shared_pref/shared_pref.dart';
import 'package:bizfns/core/utils/const.dart';
import 'package:bizfns/features/auth/ForgotBusinessId/repo/forgot_business_id_repo_impl.dart';
import 'package:bizfns/features/auth/ForgotPassword/repo/forgot_password_repo.dart';
import 'package:bizfns/features/auth/ForgotPassword/repo/forgot_password_repo_impl.dart';
import 'package:bizfns/features/auth/Login/model/login_otp_verification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../core/common/Status.dart';
import '../../../../core/route/RouteConstants.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/route_function.dart';
import '../../data/api/auth_api_client/auth_api_client.dart';
import '../model/ForgotBusinessIdResponse.dart';

class ForgotBusinessIdProvider extends ChangeNotifier {
  bool loading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController userIdController = new TextEditingController();

  bool isConfirmPasswordHidden = true;
  bool isNewPasswordHidden = true;

  var ForgotBusinessIdRepository =
      ForgotBusinessIdRepoImpl(apiClient: AuthApiClient());
  ForgotBusinessIdResponse? forgotBusinessIdResponse;

  bool isResendButtonVisible = false;
  int secondsRemaining = 30;
  bool enableResend = false;

  /// Clear controllers data
  DisposeForgotPasswordController() {
    userIdController.text = "";
  }

  /// Validation before submission
  Future validition(BuildContext context) async {
    if (userIdController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter user Id");
      return;
    } else {
      Utils().check_internet_connection(context).then((value) {
        Utils().printMessage("Has Internet");
        if (value != null && value == true) {
          Utils().printMessage("==value==$value");
          ForgotBusinessId(context);
          // Navigate(context,verify_forgot_password_otp);
        }
      });
    }
  }

  /// Validation before submission
  ForgotBusinessId(BuildContext context, {bool? fromreset}) async {
    Utils().printMessage("==ForgotBusinessId==");
    forgotBusinessIdResponse = null;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    notifyListeners();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    var body = {
      "userId": userIdController.text,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2]
    };
    ForgotBusinessIdRepository.ForgotBusinessId(body: body).then((value) async {
      loading = false;
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        EasyLoading.dismiss();
        try {
          Utils().printMessage(
              "Forgot business Id ====>>>" + jsonDecode(value.data));
          final Map<String, dynamic> map =
              jsonDecode(jsonEncode(value.data)) as Map<String, dynamic>;
          forgotBusinessIdResponse = ForgotBusinessIdResponse.fromJson(map);
          print(
              "forgotBusinessIdResponse : ${ForgotBusinessIdResponse.fromJson(map)}");
          String msg = "";
          // for(var item in forgotBusinessIdResponse!.data!){
          //   msg=msg+"\n"+item.sCHEMANAME!;
          // }
          Utils().ShowSuccessSnackBar(context, "Success", msg);
          Utils().printMessage("STATUS SUCCESS");
          Navigate.NavigateAndReplace(
            context,
            login,
          );
        } catch (e) {
          Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
          Utils().printMessage(e.toString());
        }
      } else {
        EasyLoading.dismiss();
        Utils()
            .ShowErrorSnackBar(context, "Failed", value.message ?? "Failure");
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      EasyLoading.dismiss();
      loading = false;
      Utils().ShowSuccessSnackBar(context, "Failed", err.message ?? "Failure");
      notifyListeners();
      Utils().printMessage("STATUS ERROR->$err");
    });
    notifyListeners();
  }
}
