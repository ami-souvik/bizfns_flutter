import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/core/shared_pref/shared_pref.dart';
import 'package:bizfns/core/utils/bizfns_layout_widget.dart';
import 'package:bizfns/core/utils/const.dart';
import 'package:bizfns/features/auth/ForgotPassword/repo/forgot_password_repo.dart';
import 'package:bizfns/features/auth/ForgotPassword/repo/forgot_password_repo_impl.dart';
import 'package:bizfns/features/auth/Login/model/login_otp_verification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/Status.dart';
import '../../../../core/model/dropdown_model.dart';
import '../../../../core/route/RouteConstants.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/route_function.dart';
import '../../../Admin/Staff/repo/staff_repo_impl.dart';
import '../../../Admin/data/api/add_user_api_client/add_user_api_client_impl.dart';
import '../../Login/provider/login_provider.dart';
import '../../data/api/auth_api_client/auth_api_client.dart';
import '../model/ForgotPasswordModel.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final StaffRepoImpl? addCustomerRepository =
      new StaffRepoImpl(apiClient: AddUserApiClientImpl());
  bool loading = false;
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetPasswordformKey = GlobalKey<FormState>();

  TextEditingController tanentIdController = new TextEditingController();
  TextEditingController userIdController = new TextEditingController();
  TextEditingController pinController = new TextEditingController();
  TextEditingController forgotpasswordMsgController =
      new TextEditingController();
  TextEditingController newPassswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  TextEditingController otpTimerController = TextEditingController();

  bool isConfirmPasswordHidden = true;
  bool isNewPasswordHidden = true;

  var forgotPasswordRepository =
      ForgotPasswordRepoImpl(apiClient: AuthApiClient());
  ForgotPasswordData? forgotPasswordData;

  bool isResendButtonVisible = false;
  int secondsRemaining = 30;
  bool enableResend = false;

  /// Clear controllers data
  // DisposeForgotPasswordController() {
  //   tanentIdController.text = "";
  //   userIdController.text = "";
  //   pinController.text = "";
  //   forgotpasswordMsgController.text = "";
  //   newPassswordController.text = "";
  //   confirmPasswordController.text = "";
  //   otpTimerController.text = "";
  // }

  /// Validation before submission
  Future validition(
      BuildContext context, String userId, String dropDownval) async {
    print("incoming userId====>${userId}");
    print("val====>${dropDownval}");
    if (userId.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter business Id");
      return;
    } else if (userId.length < 8) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid business Id");
      return;
    } else if (dropDownval == '-1') {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please choose user Id From Dropdown");
      return;
    } else {
      userIdController.text = userId;
      tanentIdController.text = dropDownval;
      Utils().check_internet_connection(context).then((value) {
        Utils().printMessage("Has Internet");
        if (value != null && value == true) {
          Utils().printMessage("==value==$value");
          ForgotPassword(context);
          // Navigate(context,verify_forgot_password_otp);
        }
      });
    }
  }

  /// Validation before submission
  ForgotPassword(BuildContext context, {bool? fromreset}) async {
    Utils().printMessage("==ForgotPassword==");
    forgotPasswordData = null;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    notifyListeners();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    var body = {
      "userId": userIdController.text,
      "tenantId": tanentIdController.text,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2]
    };
    forgotPasswordRepository.forgotPassword(body: body).then((value) async {
      loading = false;
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        EasyLoading.dismiss();
        try {
          forgotPasswordData = value.data;
          forgotpasswordMsgController.text = forgotPasswordData!.otpMsg ?? "";
          StartTimer();
          Utils().ShowSuccessSnackBar(
              context, "Success", forgotPasswordData!.otp.toString(),
              duration: Duration(seconds: 14));
          Utils().printMessage("STATUS SUCCESS");
          pinController.clear();
          if (fromreset == null) {
            Navigate.NavigateAndReplace(context, verify_forgot_password_otp,
                params: {'phone': userIdController.text});
          }
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

  /// Validation before Verify otp
  Future validitionOtpPage(BuildContext context) async {
    if (pinController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter otp");
      return;
    } else if (pinController.text.length < 6) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter a valid otp");
      return;
    } else {
      Utils().check_internet_connection(context).then((value) {
        Utils().printMessage("Has Internet");
        if (value != null && value == true) {
          Utils().printMessage("==value==$value");
          VerifyOtp(context);
          // Navigate(context,reset_password);
        }
      });
    }
  }

  /// Call Api for otp verification for forgot password
  VerifyOtp(BuildContext context) async {
    loading = true;
    enableResend = false;
    notifyListeners();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    var body = {
      "userId": userIdController.text,
      "tenantId": tanentIdController.text,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "otp": pinController.text,
      "otpTimeStamp": ""
    };
    forgotPasswordRepository.verifyOtp(body: body).then((value) async {
      loading = false;
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        Utils()
            .ShowSuccessSnackBar(context, "Success", "Successfully Verified");
        Utils().printMessage("STATUS SUCCESS");
        pinController.clear();
        Navigate.NavigateAndReplace(context, reset_password,
            params: {'phone': userIdController.text});
      } else {
        Utils()
            .ShowErrorSnackBar(context, "Failed", value.message ?? "Failure");
        if (value.message != null &&
            value.message!.toLowerCase() == "otp expire") {
          pinController.clear();
          enableResend = true;
        }
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      Utils().ShowErrorSnackBar(context, "Failed", err.message ?? "Failure");
      loading = false;
      notifyListeners();
      Utils().printMessage("STATUS ERROR->$err");
    });
    notifyListeners();
  }

  //Please set your password first

  /// Validation of set new password page
  Future validationNewPasswordPage(BuildContext context) async {
    log("userId------>${("userID----->>>>>>>${Provider.of<LoginProvider>(context, listen: false).userIdController.text}")}");
    if (newPassswordController.text.isEmpty) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter new password");
      return;
    } else if (confirmPasswordController.text.isEmpty) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter confirm password again");
      return;
    } else if (newPassswordController.text != confirmPasswordController.text) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "New password and confirm password should be same");
      return;
    } else {
      Utils().check_internet_connection(context).then((value) {
        Utils().printMessage("Has Internet");
        if (value != null && value == true) {
          Utils().printMessage("==value==$value");
          Provider.of<LoginProvider>(context, listen: false)
                  .loginMessage
                  .contains('password')
              ? staffUserLogin(context)
              : ResetPassword(context);
        }
      });
    }
  }

  staffUserLogin(context) async {
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);

    // OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    // List<String> deviceDetails = await Utils.getDeviceDetails();
    // String? userId = await GlobalHandler.getUserId();
    var body = {
      "userId": Provider.of<LoginProvider>(context, listen: false)
          .userIdController
          .text,
      "temporaryPassword": "Abcd@123",
      "newPassword": newPassswordController.text,
      "tenantId": Provider.of<LoginProvider>(context, listen: false)
          .selectedBusiness
          .id,
      // Provider.of<LoginProvider>(context, listen: false).sselectedBusiness,
      "staffEmail": ''
    };
    print("Incoming body====>${jsonEncode(body)}");
    addCustomerRepository!.staffUserLogin(body: body).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        confirmPasswordController.text = "";
        newPassswordController.text = "";
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowSuccessSnackBar(
          context,
          "Success",
          "Successfully staff added",
        );
        Provider.of<LoginProvider>(context, listen: false).tenantIds.clear();
        //Navigate.NavigateAndReplace(context, staff_list, params: {});

        // if (GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
        //     '/home/schedule') {
        //   Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        // }

        Navigate.NavigateAndReplace(context, login);
        Provider.of<LoginProvider>(context, listen: false)
            .getBusinessId(context);
        // GoRouter.of(context).pop();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(context, "Failed", value.message!);
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
      }
    }, onError: (err) {
      loading = false;
      EasyLoading.dismiss();
      Utils().printMessage("ADD_CUSTOMER_ERROR==>$err");
    });
  }

  /// Api call for reset otp
  ResetPassword(BuildContext context) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    notifyListeners();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    if (userIdController.text.isEmpty && tanentIdController.text.isEmpty) {
      bool isLogedin = await GlobalHandler.isLoggedIn();
      if (isLogedin) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        if (data != null) {
          userIdController.text = data.cOMPANYBACKUPPHONENUMBER ?? '';
          tanentIdController.text = data.tenantId ?? "";
        } else {
          Utils.Logout(context);
          Navigate.NavigatePushUntil(context, login);
        }
      } else {
        Utils.Logout(context);
        Navigate.NavigatePushUntil(context, login);
      }
    }

    var body = {
      "userId": userIdController.text,
      "tenantId": tanentIdController.text,
      "newPassword": newPassswordController.text,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2]
    };
    forgotPasswordRepository.resetPassword(body: body).then((value) async {
      EasyLoading.dismiss();
      loading = false;
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        tanentIdController.clear();
        userIdController.clear();
        pinController.clear();
        forgotpasswordMsgController.clear();
        newPassswordController.clear();
        confirmPasswordController.clear();
        otpTimerController.clear();
        Utils().printMessage(value.data.toString());
        Utils().ShowSuccessSnackBar(
            context, "Success", value.message ?? "Success");
        Utils().printMessage("STATUS SUCCESS");
        Utils.Logout(context);
        Navigate.NavigateAndReplace(context, login, params: {'phone': ""});
      } else {
        Utils().printMessage("STATUS FAILED");
        Utils()
            .ShowErrorSnackBar(context, "Failure", value.message ?? "Failed");
      }
    }, onError: (err) {
      EasyLoading.dismiss();
      loading = false;
      notifyListeners();
      Utils().ShowErrorSnackBar(context, "Failure", err.toString() ?? "Failed");
      Utils().printMessage("STATUS ERROR->$err");
    });
    notifyListeners();
  }

  /// Start otp timer
  StartTimer() {
    secondsRemaining = 30;
    enableResend = false;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining != 0) {
        secondsRemaining--;
        notifyListeners();
      } else {
        timer!.cancel();
        enableResend = true;
      }
      notifyListeners();
    });
  }

  /// Resend otp
  void resendCode(BuildContext context) {
    //other code here
    pinController.clear();
    secondsRemaining = 30;
    enableResend = false;
    ForgotPassword(context, fromreset: true);

    notifyListeners();
  }
}
