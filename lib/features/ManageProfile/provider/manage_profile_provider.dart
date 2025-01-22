import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bizfns/core/shared_pref/shared_pref.dart';
import 'package:bizfns/core/utils/const.dart';
import 'package:bizfns/features/auth/ForgotPassword/repo/forgot_password_repo.dart';
import 'package:bizfns/features/auth/ForgotPassword/repo/forgot_password_repo_impl.dart';
import 'package:bizfns/features/auth/Login/model/login_model.dart';
import 'package:bizfns/features/auth/Login/model/login_otp_verification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/common/Status.dart';
import '../../../../core/route/RouteConstants.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/route_function.dart';
import '../../../core/utils/alert_dialog.dart';
import '../../auth/Login/provider/login_provider.dart';
import '../data/api/manage_profile_api_client/manage_profile_api_client.dart';
import '../model/ChangePasswordResponse.dart';
import '../model/GetSequrityQuestionsResponse.dart';
import '../model/get_profile_model.dart';
// import '../model/otp_model_for_new_phone_no.dart';
import '../repo/manage_profile_repo_impl.dart';
import '../repo/profile_api_client_implementation.dart';
import '../repo/profile_repo.dart';
import '../repo/profile_repo_impl.dart';

class ManageProfileProvider extends ChangeNotifier {
  final GlobalKey<FormState> changePhNoFormKey = GlobalKey<FormState>();
  // late OtpModelForNewPhoneNo model;
  bool loading = false;
  bool isResendButtonVisible = false;
  int secondsRemaining = 30;
  bool enableResend = false;

  bool isConfirmPasswordHidden = true;
  bool isOldPasswordHidden = true;
  bool isNewPasswordHidden = true;

  bool isPhonePasswordHidden = true;

  String companyName = "";
  String companyLogo = "";
  XFile? _xFile;
  final _picker = ImagePicker();
  bool isMobileNoVisible = false;
  bool isBusinessTypeVisible = false;
  bool isBusinessContactPersonVisible = false;
  bool isBusinessContactPersonTextFieldEditable = false;
  bool isBackUpEmailTextFieldEditable = false;
  bool isBackUpPhoneTextFieldEditable = false;
  bool isSubscriptionPlanVisible = false;
  bool isBackUpEmailPhoneNoVisible = false;
  bool isRegistrationDateVisible = false;
  bool isAddressVisible = false;
  bool isAddressTextFieldVisible = false;
  String businessType = "";
  String registrationDate = "";
  String imageName = '';
  // String primaryMobileNumber = "";
  List<GetProfileModel> allProfile = [];
  TextEditingController businessContactPersonController =
      TextEditingController();
  TextEditingController primaryMobileNumberController = TextEditingController();
  TextEditingController trustedBackupEmailController = TextEditingController();
  TextEditingController trustedBackupMobileNumberController =
      TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController primaryBusinessEmailController =
      TextEditingController();
  TextEditingController addressController = TextEditingController();
  // TextEditingController otpController = TextEditingController();
  // List<TextEditingController> allLocationController = [];
  List<String> locations = [];
  TextEditingController marketing = TextEditingController();
  TextEditingController newEntry = TextEditingController();

  void addLocation() {
    String newValue = newEntry.text.trim();
    if (newValue.isNotEmpty && !locations.contains(newValue)) {
      locations.add(newValue);

      newEntry.clear();
      notifyListeners();
    }
  }

  void removeLocation(String value) {
    locations.remove(value);
    notifyListeners();
  }

  initialController() {
    isPhonePasswordHidden = true;
  }

  // generateLocationEditorField(String initialValue) {
  //   TextEditingController locationEditor =
  //       TextEditingController(text: initialValue);
  //   allLocationController.add(locationEditor);
  //   notifyListeners();
  // }

  // void generateLocationFieldsFromList(List<String> locations) {
  //   allLocationController.clear();
  //   for (String location in locations) {
  //     generateLocationEditorField(location);
  //   }
  //   notifyListeners();
  // }

  setLocationAndMarketing() {}

  changeAddressVisibility() {
    isAddressVisible = !isAddressVisible;
    isAddressTextFieldVisible = false;
    notifyListeners();
  }

  editAddress() {
    isAddressTextFieldVisible = true;
    notifyListeners();
  }

  changeBusinessTypeVisibility() {
    isBusinessTypeVisible = !isBusinessTypeVisible;
    notifyListeners();
  }

  changeBusinessContactPersonVisibility() {
    isBusinessContactPersonVisible = !isBusinessContactPersonVisible;
    isBusinessContactPersonTextFieldEditable = false;
    notifyListeners();
  }

  editBusinessContactPerson() {
    isBusinessContactPersonTextFieldEditable = true;
    notifyListeners();
  }

  editBackUpEmail() {
    isBackUpEmailTextFieldEditable = true;
    notifyListeners();
  }

  editBackUpPhone() {
    isBackUpPhoneTextFieldEditable = true;
    notifyListeners();
  }

  changeSubscriptionPlanVisibility() {
    isSubscriptionPlanVisible = !isSubscriptionPlanVisible;
    notifyListeners();
  }

  changeBackUpEmailPhoneNoVisibility() {
    isBackUpEmailPhoneNoVisible = !isBackUpEmailPhoneNoVisible;
    isBackUpEmailTextFieldEditable = false;
    isBackUpPhoneTextFieldEditable = false;
    notifyListeners();
  }

  changeRegistrationDateVisibility() {
    isRegistrationDateVisible = !isRegistrationDateVisible;
    notifyListeners();
  }

  changeMobileNoVisibility() {
    isMobileNoVisible = !isMobileNoVisible;
    notifyListeners();
  }

  setBusinessNameController() {
    businessNameController.text = companyName;
  }

  OtpVerificationData? loginData;
  List<SequrityQuestion> sequrityquestions = [];
  ChangePasswordData? changePasswordData;
  var manageProfileRepository =
      ManageProfileRepoImpl(apiClient: ManageProfileApiClient());
  final ProfileRepoImplementation profileRepo =
      ProfileRepoImplementation(apiClient: ProfileApiClientImpl());
  TextEditingController otpController = TextEditingController();
  TextEditingController otpTimerController = TextEditingController();

  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPassswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  TextEditingController currentPhoneNoController = new TextEditingController();
  TextEditingController newPhoneNoController = new TextEditingController();

  ///For Set basic info in account page
  getCompanyDetails() async {
    loginData = await GlobalHandler.getLoginData();
    if (loginData != null) {
      Utils().printMessage(loginData!.businessLogo ?? "");
      companyName = loginData!.bUSINESSNAME ?? "";
      companyLogo = loginData!.logoAddress ?? "";
      notifyListeners();
    }
  }

  Future getSequrityQuestions(BuildContext context) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    // notifyListeners();
    try {
      loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      var body = {
        // "userId":loginData.,
        "userId": userId!.length > 10
            ? userId!
                .replaceAll('(', '')
                .replaceAll(')', '')
                .replaceAll('-', '')
                .removeAllWhitespace
            : userId,
        "tenantId": loginData!.tenantId,
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2]
      };
      Utils().printMessage(body.toString());
      manageProfileRepository.getSequrityQuestion(body: body).then(
          (value) async {
        EasyLoading.dismiss();
        loading = false;
        // Utils.HideLoader(context);
        notifyListeners();
        if (value.status == STATUS.SUCCESS) {
          // Utils().printMessage(value.data.toString());
          try {
            sequrityquestions.clear();
            sequrityquestions = value.data;
            for (int i = 0; i < sequrityquestions.length; i++) {
              sequrityquestions[i].answeer = null;
            }
          } catch (e) {
            Utils().ShowErrorSnackBar(context, "Failure", SomethingWentWrong);
          }
          Utils().printMessage("STATUS SUCCESS");
        } else {
          notifyListeners();
          if (value.message == TOKEN_EXPIRED) {
            Utils.Logout(context);
          }
          Utils()
              .ShowErrorSnackBar(context, "Failure", value.message ?? "Failed");
          Utils().printMessage("STATUS FAILED");
        }
      }, onError: (err) {
        loading = false;
        notifyListeners();
        Utils().ShowErrorSnackBar(context, "Failed!", err.toString());
        Utils().printMessage("STATUS ERROR->$err");
      });
    } catch (e) {
      Utils().ShowErrorSnackBar(context, "Failed!", SomethingWentWrong);
    }
    notifyListeners();
  }

  void validition(BuildContext context, {bool? isVerifyPassword}) {
    bool isValidate = true;

    for (int i = 0; i < sequrityquestions.length; i++) {
      if (sequrityquestions[i].answeer == null ||
          sequrityquestions[i].answeer == "null" ||
          sequrityquestions[i].answeer!.isEmpty) {
        isValidate = false;
        break;
      }
    }
    if (isValidate == false) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please answer all questions");
      return;
    } else {
      Utils().check_internet_connection(context).then((value) async {
        Utils().printMessage("Has Internet");
        if (value != null && value == true) {
          Utils().printMessage("==value==$value");
          isVerifyPassword == null
              ? saveSequrityQuestion(context)
              : verifySequrityQuestion(context);
        }
      });
    }
  }

  void validitionForPh(BuildContext context, [String? forWhat]) {
    bool isValidate = true;

    for (int i = 0; i < sequrityquestions.length; i++) {
      if (sequrityquestions[i].answeer == null ||
          sequrityquestions[i].answeer == "null" ||
          sequrityquestions[i].answeer!.isEmpty) {
        isValidate = false;
        break;
      }
    }
    if (isValidate == false) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please answer all questions");
      return;
    } else {
      Utils().check_internet_connection(context).then((value) async {
        Utils().printMessage("Has Internet");
        if (value != null && value == true) {
          Utils().printMessage("==value==$value");
          print("in here new fdfsfdsfsdf");
          // isVerifyPassword == null
          //     ? saveSequrityQuestion(context)
          //     :
          // verifySequrityQuestion(context, forWhat);
          verifySequrityQuestionForMobile(context);
        }
      });
    }
  }

  Future saveSequrityQuestion(BuildContext context) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    // notifyListeners();
    loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var Questions = [];
    if (sequrityquestions.isNotEmpty) {
      for (var val in sequrityquestions) {
        var question = {
          "PK_QUESTION_ID": int.parse(val.pKQUESTIONID.toString()),
          "QUESTION": val.qUESTION.toString(),
          "answeer": val.answeer.toString(),
        };
        Questions.add(question);
      }
    }
    var body = {
      // "userId":loginData.,
      "userId": userId!.length > 10
          ? userId!
              .replaceAll('(', '')
              .replaceAll(')', '')
              .replaceAll('-', '')
              .removeAllWhitespace
          : userId,
      "tenantId": loginData!.tenantId,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "sequrityQuestions": Questions
    };
    manageProfileRepository.saveSequrityQuestion(body: body).then(
        (value) async {
      EasyLoading.dismiss();
      loading = false;
      // Utils.HideLoader(context);
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        // Utils().printMessage(value.data.toString());
        try {
          await GlobalHandler.setSequrityQuestionAnswered(true);
          OtpVerificationData? data = await GlobalHandler.getLoginData();
          if (data != null) {
            data.isSequrityQuestionAnswered = "Y";
          }
          print("here navigating to the homePage");
          // Navigate.NavigateAndReplace(context, home, params: {});
          context.goNamed('home');
          notifyListeners();
        } catch (e) {
          Utils().ShowErrorSnackBar(context, "Failure", SomethingWentWrong);
        }
        Utils().printMessage("STATUS SUCCESS");
      } else {
        notifyListeners();
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        Utils()
            .ShowErrorSnackBar(context, "Failure", value.message ?? "Failed");
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      loading = false;
      EasyLoading.dismiss();
      notifyListeners();
      Utils().ShowErrorSnackBar(context, "Failed!", err.toString());
      Utils().printMessage("STATUS ERROR->$err");
    });
    notifyListeners();
  }

  void validitionChangePassword(BuildContext context) {
    if (oldPasswordController.text.isEmpty) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter old password");
      return;
    } else if (newPassswordController.text.isEmpty) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter new password");
      return;
    } else if (confirmPasswordController.text.isEmpty) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter confirm password");
      return;
    } else if (newPassswordController.text != confirmPasswordController.text) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "New password and confirm password should be same");
      return;
    } else if (!Utils().isValidPassword(newPassswordController.text)) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid new password");
      return;
    } else if (oldPasswordController.text == newPassswordController.text) {
      Utils().ShowWarningSnackBar(context, "OOPS!",
          "Old password and new password should be different");
      return;
    } else {
      Utils().check_internet_connection(context).then((value) async {
        Utils().printMessage("Has Internet");
        if (value != null && value == true) {
          Utils().printMessage("==value==$value");
          otpController.clear();
          callChangePasswordApi(context);
        }
      });
    }
  }

  Future callChangePasswordApi(BuildContext context, {bool? isResend}) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    // notifyListeners();
    loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      // "userId":loginData.,
      "userId": userId,
      "tenantId": loginData!.tenantId,
      "oldPassword": oldPasswordController.text,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2]
    };
    manageProfileRepository.changePasswordAndSendOtp(body: body).then(
        (value) async {
      EasyLoading.dismiss();
      loading = false;
      // Utils.HideLoader(context);
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        // Utils().printMessage(value.data.toString());
        try {
          StartTimer(context);
          changePasswordData = value.data;
          Utils().ShowSuccessSnackBar(
              context, "Success", changePasswordData!.oTP.toString(),
              duration: Duration(seconds: 10));

          secondsRemaining = 30;
          enableResend = false;
          otpController.clear();

          if (isResend == null) {
            Navigate(context, verify_change_password_otp, params: {});
          }

          notifyListeners();
        } catch (e) {
          Utils().ShowErrorSnackBar(context, "Failure", SomethingWentWrong);
        }
        Utils().printMessage("STATUS SUCCESS");
      } else {
        notifyListeners();
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        Utils()
            .ShowErrorSnackBar(context, "Failure", value.message ?? "Failed");
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      loading = false;
      EasyLoading.dismiss();
      notifyListeners();
      Utils().ShowErrorSnackBar(context, "Failed!", err.toString());
      Utils().printMessage("STATUS ERROR->$err");
    });
    notifyListeners();
  }

  StartTimer(
    BuildContext context,
  ) {
    print("Start timer called");
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining != 0) {
        print("Seconds Remaining ===>${secondsRemaining}");
        // if (secondsRemaining <= 1) {
        //   print("pop called");
        //   Navigator.pop(context);
        // }
        secondsRemaining--;
        notifyListeners();
      } else {
        timer.cancel();
        enableResend = true;
        notifyListeners();
      }
      notifyListeners();
    });
  }

  void resendCode(BuildContext context) {
    //other code here
    otpController.clear();
    secondsRemaining = 30;
    enableResend = false;
    // getOtpForMobileChanges(context);
    callChangePasswordApi(context);

    notifyListeners();
  }

  void resendCode2(BuildContext context) {}

  otpPagevalidation(BuildContext context, String otp) async {
    if (otpController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter otp");
      return;
    } else if (otpController.text.length < 6) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter a valid otp");
      return;
    } else {
      Utils().check_internet_connection(context).then((value) {
        if (value != null && value == true) {
          verifyOtp(context, otp, "");
        }
      });
    }
  }

  void verifyOtp(BuildContext context, String otp, String otpTimeStamp) async {
    // loading_state.value = true;
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    notifyListeners();
    loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "userId": userId,
      "tenantId": loginData!.tenantId,
      // "otp": changePasswordData!.oTP.toString(),
      "otp": otp.toString(),

      "otpTimeStamp": changePasswordData!.otpTimeStamp.toString(),
      "newPassword": newPassswordController.text,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2]
    };
    await manageProfileRepository.verifyOtp(body: body).then((value) async {
      // loading_state.value = false;
      loading = false;
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        Utils().printMessage("STATUS SUCCESS");
        //context.go(Routes.HOME);
        try {
          EasyLoading.dismiss();
          oldPasswordController.text = "";
          otpController.text = "";
          otpTimerController.text = "";
          newPassswordController.text = "";
          confirmPasswordController.text = "";
          // Utils.Logout(context);
          //   Navigate.NavigateAndReplace(context, login);
          ShowSuccessDialog(
              context: context,
              msg: "Password Reset successfully.\n Login again to continue.",
              title: "Success",
              onOkTap: () {
                // await GlobalHandler.setLoginData(null);
                Utils.Logout(context);
                Future.delayed(const Duration(milliseconds: 200), () {
                  context.pop();
                });
              });
        } catch (e) {
          EasyLoading.dismiss();
        }
      } else {
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(context, "OOPS!", value.message ?? "Failed");
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      // loading_state.value = false;
      EasyLoading.dismiss();
      loading = false;
      notifyListeners();
      Utils().printMessage("$err");
    });
  }

  ///Change Phone number things
  ///
  void validitionChangePhoneNumber(BuildContext context) {
    if (newPhoneNoController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter phone no");
      return;
    } else if (newPhoneNoController.text.isEmpty) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter new password");
      return;
    } else {
      Utils().check_internet_connection(context).then((value) async {
        Utils().printMessage("Has Internet");
        if (value != null && value == true) {
          Utils().printMessage("==value==$value");
          callChangePasswordApi(context);
        }
      });
    }
  }

  verifySequrityQuestionForMobile(BuildContext context,
      [String? forWhat]) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    // notifyListeners();
    loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var Questions = [];
    if (sequrityquestions.isNotEmpty) {
      for (var val in sequrityquestions) {
        var question = {
          "PK_QUESTION_ID": int.parse(val.pKQUESTIONID.toString()),
          "QUESTION": val.qUESTION.toString(),
          "answeer": val.answeer.toString(),
        };
        Questions.add(question);
      }
    }
    var body = {
      // "userId":loginData.,
      "userId": userId!.length > 10
          ? userId!
              .replaceAll('(', '')
              .replaceAll(')', '')
              .replaceAll('-', '')
              .removeAllWhitespace
          : userId,
      "tenantId": loginData!.tenantId,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "sequrityQuestions": Questions
    };

    print("GetSecurityQuestion Data====>${jsonEncode(body)}");
    manageProfileRepository.verifySequrityQuestion(body: body).then(
        (value) async {
      EasyLoading.dismiss();
      loading = false;
      // Utils.HideLoader(context);
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        Navigate(context, retype_newphone);

        // Utils().printMessage(value.data.toString());
        // try {
        //   CallChangePhoneNumberApi(context);
        // } catch (e) {
        //   Utils().ShowErrorSnackBar(context, "Failure", SomethingWentWrong);
        // }
        Utils().printMessage("STATUS SUCCESS");
      } else {
        notifyListeners();
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        Utils()
            .ShowErrorSnackBar(context, "Failure", value.message ?? "Failed");
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      loading = false;
      EasyLoading.dismiss();
      notifyListeners();
      Utils().ShowErrorSnackBar(context, "Failed!", err.toString());
      Utils().printMessage("STATUS ERROR->$err");
    });
    notifyListeners();
  }

  verifySequrityQuestion(BuildContext context, [String? forWhat]) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    // notifyListeners();
    loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var Questions = [];
    if (sequrityquestions.isNotEmpty) {
      for (var val in sequrityquestions) {
        var question = {
          "PK_QUESTION_ID": int.parse(val.pKQUESTIONID.toString()),
          "QUESTION": val.qUESTION.toString(),
          "answeer": val.answeer.toString(),
        };
        Questions.add(question);
      }
    }
    var body = {
      // "userId":loginData.,
      "userId": userId!.length > 10
          ? userId!
              .replaceAll('(', '')
              .replaceAll(')', '')
              .replaceAll('-', '')
              .removeAllWhitespace
          : userId,
      "tenantId": loginData!.tenantId,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "sequrityQuestions": Questions
    };
    manageProfileRepository.verifySequrityQuestion(body: body).then(
        (value) async {
      EasyLoading.dismiss();
      loading = false;
      // Utils.HideLoader(context);
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        // Utils().printMessage(value.data.toString());
        try {
          CallChangePhoneNumberApi(context);
        } catch (e) {
          Utils().ShowErrorSnackBar(context, "Failure", SomethingWentWrong);
        }
        Utils().printMessage("STATUS SUCCESS");
      } else {
        notifyListeners();
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        Utils()
            .ShowErrorSnackBar(context, "Failure", value.message ?? "Failed");
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      loading = false;
      EasyLoading.dismiss();
      notifyListeners();
      Utils().ShowErrorSnackBar(context, "Failed!", err.toString());
      Utils().printMessage("STATUS ERROR->$err");
    });
    notifyListeners();
  }

  void CallChangePhoneNumberApi(BuildContext context) async {
    // loading_state.value = true;
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    notifyListeners();
    loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "userId": userId,
      "companyId": loginData!.cOMPANYID,
      "currentMobileNo": currentPhoneNoController.text,
      "newMobileNo": newPhoneNoController.text,
      "tenantId": loginData!.tenantId,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2]
    };
    await manageProfileRepository.changeMobileNo(body: body).then(
        (value) async {
      // loading_state.value = false;
      loading = false;
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        Utils().printMessage("STATUS SUCCESS");
        //context.go(Routes.HOME);
        try {
          EasyLoading.dismiss();
          await GlobalHandler.setUserId(newPhoneNoController.text);
          currentPhoneNoController.text = "";
          newPhoneNoController.text = "";
          // Utils.Logout(context);
          //   Navigate.NavigateAndReplace(context, login);

          AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            // showCloseIcon: true,
            title: 'Success',
            desc: "Mobile No Changed successfully.\n Login again to continue.",

            // desc: 'Dialog description here..................................................',
            btnOkOnPress: () async {
              Utils().printMessage('OnClick');

              await GlobalHandler.setLogedIn(false);
              await GlobalHandler.setSequrityQuestionAnswered(false);
              await GlobalHandler.setLoginData(null);
              Utils.Logout(context);
              Future.delayed(const Duration(milliseconds: 200), () {
                Navigate.NavigateAndReplace(context, login);
              });
            },
            btnOkIcon: Icons.check_circle,
          ).show();
        } catch (e) {
          EasyLoading.dismiss();
        }
      } else {
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(context, "OOPS!", value.message ?? "Failed");
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      // loading_state.value = false;
      EasyLoading.dismiss();
      loading = false;
      notifyListeners();
      Utils().printMessage("$err");
    });
  }

  clearController() {
    currentPhoneNoController.text = "";
    newPhoneNoController.text = "";
  }

  clearChangePasswordController() {
    oldPasswordController.text = "";
    newPassswordController.text = "";
    confirmPasswordController.text = "";
  }

  void validitionForPhoneNoChange(BuildContext context) async {
    OtpVerificationData? data = await GlobalHandler.getLoginData();

    if (currentPhoneNoController.text.isEmpty) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter current mobile no");
      return;
    } else if (currentPhoneNoController.text.length < 10) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid mobile no");
      return;
    } else if (data != null &&
        data.cOMPANYBACKUPPHONENUMBER != currentPhoneNoController.text) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "You have entered wrong current mobile number");
      return;
    } else if (newPhoneNoController.text.isEmpty) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter new mobile no");
      return;
    } else if (newPhoneNoController.text.length < 10) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid mobile no");
      return;
    } else {
      Navigate(context, verify_sequrity_questions);
    }
  }

  getProfile() async {
    Utils().printMessage("==Getting Profile==");
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    profileRepo.getProfile().then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          if (value.data != null) {
            GetProfileModel resp = value.data as GetProfileModel;
            Utils().printMessage("GetProfileResponseData ===>${resp.data}");
            allProfile.add(resp);
            businessType = resp.data!.businessType.toString();
            businessContactPersonController.text =
                resp.data!.businessContactPerson.toString();
            primaryMobileNumberController.text =
                resp.data!.primaryMobileNumber.toString();
            trustedBackupEmailController.text =
                resp.data!.trustedBackupEmail.toString();
            trustedBackupMobileNumberController.text =
                resp.data!.trustedBackupMobileNumber.toString();
            businessNameController.text =
                resp.data!.businessNameAndLogo!.businessName.toString();
            DateTime apiDate =
                DateTime.parse(resp.data!.registrationDate.toString());
            registrationDate = DateFormat('dd-MM-yyyy').format(apiDate);
            addressController.text = resp.data!.fullAddress.toString();
            primaryBusinessEmailController.text =
                resp.data!.primaryBusinessEmail.toString();
            imageName = resp.data!.businessNameAndLogo!.businessLogo.toString();
            locations = (resp.data!.marketing!.addLocation) ?? [];
            marketing.text = resp.data!.marketing!.marketingDescription!;

            print("Locations============>${locations}");
            loading = false;
            EasyLoading.dismiss();
            notifyListeners();
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    });
  }

  setProfileData() async {
    Utils().printMessage("==Setting Profile==");
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    await profileRepo
        .setProfile(
            businessName: businessNameController.text,
            businessLogo: imageName,
            marketingDescription: marketing.text,
            addLocation: locations,
            address: addressController.text,
            businessContactPerson: businessContactPersonController.text,
            trustedBackupMobileNumber: trustedBackupMobileNumberController.text,
            trustedBackupEmail: trustedBackupEmailController.text,
            businessEmail: primaryBusinessEmailController.text)
        .then((value) {
      // locations.clear();
      getProfile();
      loading = false;
      EasyLoading.dismiss();
    });
  }

  // disposeController() {
  //   businessNameController.dispose();
  //   addressController.dispose();
  //   businessContactPersonController.dispose();
  //   trustedBackupMobileNumberController.dispose();
  // }

  pickProfileImageFromGallery() async {
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    _xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (_xFile != null) {
      profileRepo.uploadBusinessLogo(image: _xFile).then((value) {
        // print(value.data.data[0]["imageName"]);
        imageName = value.data.data["data"][0]["imageName"];
        getProfile();
        notifyListeners();
      });
    }
    loading = false;
    EasyLoading.dismiss();
  }

  pickProfileImageFromCamera() async {
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    _xFile = await _picker.pickImage(source: ImageSource.camera);
    if (_xFile != null) {
      profileRepo.uploadBusinessLogo(image: _xFile).then((value) {
        print("value=========>${value.data.data["data"][0]["imageName"]!}");
        // print(value.data.data[0]["imageName"]);
        imageName = value.data.data["data"][0]["imageName"]!;
        getProfile();
        notifyListeners();
      });
    }
    loading = false;
    EasyLoading.dismiss();
  }

  verifyPassword(String password, BuildContext context) async {
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    if (password.isNotEmpty) {
      profileRepo.verifyPassword(password: password).then((value) {
        if (value.status == STATUS.SUCCESS) {
          print("Data-receiving after verifying password ==>${value.data}");

          Utils().ShowSuccessSnackBar(
              context, "Success", 'Password Verified successfully');
          loading = false;
          EasyLoading.dismiss();
          Navigate(context, security_question_page,
              params: {"forWhat": "verifyNewPhone"});
        } else {
          Utils().ShowErrorSnackBar(
              context, "Failed", 'Password Verification Failed');
          loading = false;
          EasyLoading.dismiss();
        }
      });
    } else {
      if (kDebugMode) {
        print("password is empty");
      }
      loading = false;
      EasyLoading.dismiss();
    }
  }

  getOtpForMobileChanges(BuildContext context) async {
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    // if (password.isNotEmpty) {
    profileRepo.getOtpForMobileChanges().then((value) {
      if (value.status == STATUS.SUCCESS) {
        
        StartTimer(context);
        // model = value;
        print(
            "Data-receiving after sending otp ==>${value.data.data["data"]["OTP"]}");

        Utils().ShowSuccessSnackBar(
            context, "Success!", "${value.data.data["data"]["OTP"]}",
            duration: Duration(seconds: 10));
        secondsRemaining = 30;
        enableResend = false;
        otpController.clear();
        // if(isResend == null) {
        Navigate(context, verify_otp, params: {"forWhat": "newMobileUpdate"});
        // }
        loading = false;
        EasyLoading.dismiss();
        // Navigate(context, security_question_page,
        //     params: {"forWhat": "verifyNewPhone"});
      } else {
        Utils().ShowErrorSnackBar(context, "Failed", 'Otp sent Failed');
        loading = false;
        EasyLoading.dismiss();
      }
    });
    // } else {
    //   if (kDebugMode) {
    //     print("password is empty");
    //   }
    //   loading = false;
    //   EasyLoading.dismiss();
    // }
  }

  saveChangesMobile(BuildContext context) async {
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    profileRepo
        .saveChangesMobile(
            newMobileNumber: newPhoneNoController.text
                .replaceAll('(', '')
                .replaceAll(')', '')
                .replaceAll('-', '')
                .removeAllWhitespace,
            otp: otpController.text)
        .then((value) {
      if (value.status == STATUS.SUCCESS) {
        loading = false;
        EasyLoading.dismiss();
        ShowSuccessDialog(
            context: context,
            msg:
                "Phone No Reset successfully.\nYour New Phone No :${newPhoneNoController.text.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').removeAllWhitespace}.\n Login again to continue.",
            title: "Success",
            onOkTap: () {
              // await GlobalHandler.setLoginData(null);
              newPhoneNoController.clear();
              Utils.Logout(context);
              GlobalHandler.clearData();
              Provider.of<LoginProvider>(context, listen: false)
                  .businessNameDropdownOptions
                  .clear();

              Future.delayed(const Duration(milliseconds: 200), () {
                context.pop();
              });
            });
      } else {
        Utils().ShowErrorSnackBar(context, "Failed", 'Mobile No Change Failed');
        loading = false;
        EasyLoading.dismiss();
      }

      // return null;
    });
  }

  saveMarketingValue() {
    locations.clear();
    setProfileData();
  }

  // void addLocation() {
  //   String newValue = _textEditingController.text.trim();
  //   if (newValue.isNotEmpty && !locations.contains(newValue)) {
  //     setState(() {
  //       locations.add(newValue);
  //     });
  //     _textEditingController.clear();
  //   }
  // }

  // clearController(){

  // }

  // uploadProfile() {
  //   Utils().printMessage("==Uploading Profile==");
  //   loading = true;
  //   EasyLoading.show(
  //       status: "Loading", indicator: const CircularProgressIndicator());
  //   profileRepo.uploadBusinessLogo()
  // }
}

// await GlobalHandler.setLogedIn(false);
//         //             await GlobalHandler.setSequrityQuestionAnswered(
//         //                 false);
//         //             await GlobalHandler.setLoginData(null);
//         //             Future.delayed(
//         //               const Duration(milliseconds: 200),
//         //                   () => context.go(login),
//         //             );
