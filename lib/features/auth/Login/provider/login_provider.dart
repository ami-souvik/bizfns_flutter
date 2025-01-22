import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/core/model/dropdown_model.dart';
import 'package:bizfns/core/route/NavRouter.dart';
import 'package:bizfns/core/utils/const.dart';
import 'package:bizfns/features/auth/Login/model/login_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/Status.dart';
import '../../../../core/route/RouteConstants.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../../core/utils/route_function.dart';
import '../../ForgotBusinessId/model/ForgotBusinessIdResponse.dart';
import '../../ForgotBusinessId/repo/forgot_business_id_repo_impl.dart';
import '../../data/api/auth_api_client/auth_api_client.dart';
import '../model/login_otp_verification_model.dart';
import '../repo/login_repo_impl.dart';

class LoginProvider extends ChangeNotifier {
  bool loading = false;
  bool isResendButtonVisible = false;
  int secondsRemaining = 30;
  bool enableResend = false;
  bool isPasswordHidden = true;
  bool? isPasswordFieldVisibleInLogin;
  late LoginData model;
  late TextEditingController tenantIdController;
  late TextEditingController userIdController;
  late TextEditingController passwordController;
  TextEditingController otpController = TextEditingController();
  late TextEditingController otpTimerController;

  // LoginControllerProvider({this.loginRepository});
  final ScrollController listController = ScrollController();
  var loginRepository = LoginRepoImpl(apiClient: AuthApiClient());
  List<String> tenantIds = [];
  List<ForgotBusinessIdData> businesses = [];
  List<DropdownModel> businessNameDropdownOptions = [
    DropdownModel(id: "-1", dependentid: "-1", name: "Select")
  ];
  DropdownModel selectedBusiness =
      DropdownModel(id: "-1", dependentid: "-1", name: "Select");

  changeBusinessDropDown(DropdownModel val) {
    selectedBusiness = val;
    print("vALUE.ID----->${val.id}");
    print('Changing business ID: ${val.name} ${val.id}');
    notifyListeners();
  }

  //var sselectedBusiness;

  /// Controllers initialization
  InitialControllers(BuildContext context) {
    isPasswordHidden = true;
    tenantIdController = new TextEditingController();
    userIdController = new TextEditingController();
    passwordController = TextEditingController();
    otpController = TextEditingController();
    otpTimerController = TextEditingController();
    checkCompanyId(context);
    isPasswordFieldVisibleInLogin = true;
  }

  /// Clear controllers data
  DisposeControllers() {
    tenantIdController.text = "";
    userIdController.text = "";
    passwordController.text = "";
    otpController.text = "";
    otpTimerController.text = "";
  }

  /// Validation before Login
  Future validation(BuildContext context) async {
    /*if(tenantIdController.text.isEmpty){
     Utils().ShowWarningSnackBar(context,"OOPS!","Please enter business Id");
     return;
   }
   else if(tenantIdController.text.length<8){
     Utils().ShowWarningSnackBar(context,"OOPS!","Please enter valid business Id");
     return;
   }*/
    if (selectedBusiness.id == "-1") {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please Choose a business name");
      return;
    } else if (userIdController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter user Id");
      return;
    } else if (passwordController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter password");
      return;
    } else if (!Utils().isValidPassword(passwordController.text)) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid password");
      return;
    } else {
      Utils().check_internet_connection(context).then((value) {
        UserLogin(context);
        Utils().printMessage("Has Internet");
        if (value != null && value == true) {
          Utils().printMessage("==value==$value");
          //UserLogin(context);
        }
      });
    }
  }

  /// Fetch FCM Token from shared preferences if available otherwise get a new token from firebase and save in shared preferences
  // Future<String> getFcmToken() async {
  //   String? token = await GlobalHandler.getFcmToken();
  //   if (token == null || token.isEmpty) {
  //     if (kIsWeb)
  //       token = "";
  //     else {
  //       token = await FirebaseMessaging.instance.getToken();
  //       await GlobalHandler.setFcmToken(token ?? "");
  //     }
  //   }
  //   return token ?? "";
  // }

  /// Start otp timer
  StartTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining != 0) {
        secondsRemaining--;
        otpTimerController.text = secondsRemaining.toString();
      } else {
        timer.cancel();
        enableResend = true;
        notifyListeners();
      }
      notifyListeners();
    });
  }

  String loginMessage = "";

  /// Resend otp
  void resendCode(BuildContext context) {
    //other code here
    otpController.clear();
    secondsRemaining = 30;
    enableResend = false;
    UserLogin(context, isResend: true);
    StartTimer();
    notifyListeners();
  }

  /// Api call for send otp for login
  UserLogin(BuildContext context, {bool? isResend}) async {
    Utils().printMessage("==UserLogin==");
    // Utils.ShowLoader(context);
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    notifyListeners();
    // String token = await getFcmToken();

    String? fcmToken;

    try {
      List<String> deviceDetails = await Utils.getDeviceDetails();

      String userID = userIdController.text;

      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

      try {
        fcmToken = await firebaseMessaging.getToken();
        print('FCM Token: $fcmToken');
      } catch (e) {
        print('Error in Firebase: $e');
      }

      var body = {
        "userId": userID.length > 10
            ? userID
                .replaceAll('(', '')
                .replaceAll(')', '')
                .replaceAll('-', '')
                .removeAllWhitespace
            : userIdController.text,
        "password": passwordController.text,
        "tenantId": selectedBusiness.id,
        "fcmId": fcmToken,
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2]
      };

      print("LoginBody====>$body");
      print("tenant Id on login ====>${selectedBusiness.id}");
      //print("duplicated tenant Id on login====>${sselectedBusiness}");
      loginRepository.login(body: body).then((value) async {
        notifyListeners();

        print(value.data);

        if (value.status == STATUS.SUCCESS) {
          // Utils.HideLoader(context);
          EasyLoading.dismiss();
          loading = false;
          // Utils().printMessage(value.data);
          StartTimer();
          model = value.data;
          Utils().ShowSuccessSnackBar(
              context, "Success!", model.otp!.toString(),
              duration: Duration(seconds: 10));
          Utils().printMessage("STATUS SUCCESS");
          secondsRemaining = 30;
          enableResend = false;
          otpController.clear();
          print(
              "after hitting login api tentant id ====>${selectedBusiness.id}");
          //print("duplicated tenant after on login====>${sselectedBusiness}");
          if (isResend == null) {
            Navigate.NavigatePushUntil(context, verify_otp, params: {
              'phno': userIdController.text,
              'otpTimeStamp': model.otpTimeStamp ?? "",
              'otpMsg': model.otp_message ?? "",
              "forWhat": ""
            });
            // GoRouter.of(context).pushNamed(verify_otp, extra: {
            //   'phno': userIdController.text,
            //   'otpTimeStamp': model.otpTimeStamp ?? "",
            //   'otpMsg': model.otp_message ?? "",
            //   "forWhat": ""
            // });
          }
        } else {
          EasyLoading.dismiss();
          loading = false;
          // Utils.HideLoader(context);
          Utils().ShowErrorSnackBar(
              context, "Failed!", value.message ?? "Failure");
          Utils().printMessage("STATUS FAILED");
        }
      }, onError: (err) {
        EasyLoading.dismiss();
        // Utils.HideLoader(context);
        loading = false;
        notifyListeners();
        Utils().printMessage("STATUS ERROR->$err");
      });
      notifyListeners();
    } catch (e) {
      loading = false;
      EasyLoading.dismiss();
      // Utils.HideLoader(context);
    }
  }

  /// Validation before submit otp to the server
  otpPageValidation(BuildContext context, String otp) async {
    if (otpController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter otp");
      return;
    } else if (otpController.text.length < 6) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter a valid otp");
      return;
    } else {
      Utils().check_internet_connection(context).then((value) {
        verifyOtp(context, otp, "");
        if (value != null && value == true) {
          // verifyOtp(context, otp,"");
        }
      });
    }
  }

  /// Api call for verify otp
  void verifyOtp(BuildContext context, String otp, String otpTimeStamp) async {
    // loading_state.value = true;
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    notifyListeners();
    print("tenant Id on otp validation ====>${selectedBusiness.id}");
    await loginRepository
        .verifyOtp(
            userId: userIdController.text,
            tenantId: selectedBusiness.id!,
            //tenantId: sselectedBusiness,
            otp: otp,
            otpTimeStamp: otpTimeStamp)
        .then((value) async {
      // loading_state.value = false;
      loading = false;
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        Utils().printMessage("STATUS SUCCESS");
        //context.go(Routes.HOME);
        try {
          var response = value.data;
          final list = response.toList();
          List<OtpVerificationData> objectList = List<OtpVerificationData>.from(
              list.map((x) => OtpVerificationData.fromJson(x)));
          // Utils().printMessage(response);
          List<OtpVerificationData>? data = objectList;
          if (data != null || data.isNotEmpty) {
            await GlobalHandler.setLoginData(data.first);
            Utils().ShowSuccessSnackBar(
                context, "Success", value.message ?? "Success");
            //sselectedBusiness = null;
            EasyLoading.dismiss();
            loading = false;
            print(userIdController.text);
            await GlobalHandler.setToken(data!.first.token ?? "");
            await GlobalHandler.setLogedIn(true);
            await GlobalHandler.setUserId(userIdController.text);
            // await GlobalHandler.setCompanyId(tenantIdController.text);
            await GlobalHandler.setCompanyId(selectedBusiness.id.toString());
            await GlobalHandler.setCompanyName(
                selectedBusiness.name.toString());
            // tenantIdController.text = "";
            // userIdController.text = "";
            // passwordController.text = "";

            if (data!.first.userType != null && data!.first.userType == "1") {
              if (data!.first.isSequrityQuestionAnswered != null &&
                  data!.first.isSequrityQuestionAnswered == "Y") {
                await GlobalHandler.setSequrityQuestionAnswered(true);
                //Navigate.NavigateAndReplace(context, home);
                context.goNamed('home');
              } else {
                await GlobalHandler.setSequrityQuestionAnswered(false);
                Navigate.NavigateAndReplace(context, security_question_page,
                    params: {"forWhat": ""});
              }
            } else if (data!.first.userType != null &&
                data!.first.userType == "2") {
              if (data!.first.isSequrityQuestionAnswered != null &&
                  data!.first.isSequrityQuestionAnswered == "Y") {
                await GlobalHandler.setSequrityQuestionAnswered(true);
                context.goNamed('home');
                // Navigate.NavigateAndReplace(context, home);
              } else {
                // Navigate(context, change_password);
                // await GlobalHandler.setSequrityQuestionAnswered(false);

                Navigate.NavigateAndReplace(context, reset_password,
                    params: {'phone': userIdController.text});
              }
            }
          } else {
            // await GlobalHandler.setSequrityQuestionAnswered(true);
            await GlobalHandler.setToken("");
            await GlobalHandler.setLogedIn(false);
            Utils.Logout(context);
            Utils().ShowWarningSnackBar(
                context, "OOPS!", "This user is not permitted for proceed");
            // Navigate.NavigateAndReplace(context, home);
          }
        } catch (e) {
          EasyLoading.dismiss();
          loading = false;
        }
      } else {
        EasyLoading.dismiss();
        loading = false;
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

  void checkCompanyId(BuildContext context) async {
    String? companyId = await GlobalHandler.getCompanyId();
    String? companyName = await GlobalHandler.getCompanyName();
    String? userId = await GlobalHandler.getUserId();
    if (userId != null) {
      userIdController.text = userId;
      print("check company id callimng");
      print('not call calling API');
      tenantIdController.text = companyId!;
      businessNameDropdownOptions.clear();
      businesses.clear();
      businesses.add(ForgotBusinessIdData(
          bUSINESSNAME: companyName, sCHEMANAME: companyId));
      businessNameDropdownOptions.add(DropdownModel(
          id: companyId,
          dependentid: companyId,
          name: companyName,
          desc: companyName));

      print("businessNameDropdownOptions======>$businessNameDropdownOptions");

      selectedBusiness = businessNameDropdownOptions.first;
      // sselectedBusiness = businessNameDropdownOptions.first.id;
      print("selectedBusiness==========>${selectedBusiness.id}");
      getBusinessId(context);
    }
    if ((companyId != null && companyName != null) &&
        (companyId.isNotEmpty && companyName.isNotEmpty)) {
      tenantIdController.text = companyId;
      businessNameDropdownOptions.clear();
      businesses.clear();
      businesses.add(ForgotBusinessIdData(
          bUSINESSNAME: companyName, sCHEMANAME: companyId));
      businessNameDropdownOptions.add(DropdownModel(
          id: companyId,
          dependentid: companyId,
          name: companyName,
          desc: companyName));
      selectedBusiness = businessNameDropdownOptions.first;
    } else {
      if (userId != null && userId.isNotEmpty) {
        print('not null calling API1');
        getBusinessId(context);
      }
    }
  }

  ///change drop down options on change user ID
  ///
  ///
  ///
  changeDropDownOption(BuildContext context) {
    businessNameDropdownOptions = [
      DropdownModel(id: "-1", dependentid: "-1", name: "Select")
    ];
    selectedBusiness =
        DropdownModel(id: "-1", dependentid: "-1", name: "Select");
    notifyListeners();
  }

  ///Business Name with business id dropdown list api response
  ForgotBusinessIdResponse? forgotBusinessIdResponse;

  /// Validation before submission
  getBusinessId(BuildContext? context) async {
    Utils().printMessage("==GetBusinessId==");

    String? companyId = await GlobalHandler.getCompanyId();
    String? companyName = await GlobalHandler.getCompanyName();
    String? userId = await GlobalHandler.getUserId();

    if (userId != userIdController.text) {
      companyId = null;
      companyName = null;
      /*businessNameDropdownOptions = [DropdownModel(id: "-1",dependentid: "-1",name: "Select")];
      selectedBusiness = DropdownModel(
         id: "-1",
        dependentid: "-1",
        name: "Select"
      );
      notifyListeners();*/
    }

    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    notifyListeners();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    deviceDetails.forEach((element) {
      print('Device: $element');
    });

    String idValue = userIdController.text;

    var body = {
      "userId": idValue.contains('(')
          ? idValue
              .replaceAll('(', '')
              .replaceAll(')', '')
              .replaceAll('-', '')
              .removeAllWhitespace
              .trim()
          : idValue,
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2].isEmpty ? '1.0.0' : deviceDetails[2]
    };

    Dio dio = Dio();

    // var resp = await dio.post(Urls.FORGOT_BUSINESS_ID, data: body);

    // print(resp);

    var ForgotBusinessIdRepository =
        ForgotBusinessIdRepoImpl(apiClient: AuthApiClient());

    print('In login Provider: ${selectedBusiness.id}');

    ForgotBusinessIdRepository.ForgotBusinessId(body: body).then((value) async {
      log("VALUE : ------ ${value}");
      if (value.status == STATUS.SUCCESS) {
        loginMessage = value.message ?? "";

        print("incoming message =====>${value.message}");
        if (value.message!.contains('Please set your password first')) {
          tenantIds.clear();
          List<String> parts = value.message.toString().split(':');
          if (parts.length == 2) {
            String tenantString = parts[1].trim();

            List<String> ids =
                tenantString.substring(1, tenantString.length - 1).split(',');

            // Trim and add each tenant ID to the list
            for (String id in ids) {
              tenantIds.add(id.trim());
            }

            log("all the tenant id--------------->${tenantIds}");
          }
          isPasswordFieldVisibleInLogin = false;
          notifyListeners();
        } else {
          isPasswordFieldVisibleInLogin = true;
          notifyListeners();
        }
        EasyLoading.dismiss();
        loading = false;
        notifyListeners();
        try {
          Utils().printMessage(
              "Forgot business Id ====>>>" + jsonEncode(value.data));
          final Map<String, dynamic> map =
              jsonDecode(jsonEncode(value.data)) as Map<String, dynamic>;
          forgotBusinessIdResponse = ForgotBusinessIdResponse.fromJson(map);
          String msg = "";
          int i = 0;
          businessNameDropdownOptions.clear();
          for (var item in forgotBusinessIdResponse!.data!) {
            businesses.add(item);
            businessNameDropdownOptions.add(DropdownModel(
                id: item.sCHEMANAME!.split("-")[0],
                dependentid: item.sCHEMANAME!.split("-")[0],
                name: item.bUSINESSNAME!.split("-")[0],
                desc: item.bUSINESSNAME!.split("-")[0]));
            msg = msg + "\n" + item.sCHEMANAME!;
            i++;
          }
          if (businessNameDropdownOptions.isNotEmpty) {
            print('businesses Not empty');
            print('Company ID: $companyId');
            businessNameDropdownOptions.forEach((element) {
              print('Drdop Down Name: ' + element.name.toString());
              print('Drop Down ID: ' + element.id.toString());
            });
            if (selectedBusiness.id == "-1") {
              print('no company ID');
              selectedBusiness = businessNameDropdownOptions[0];
              // sselectedBusiness =businessNameDropdownOptions[0].id;
            }
          } else {
            print('businesses empty');
          }
          notifyListeners();
          Utils().printMessage("STATUS SUCCESS");
        } catch (e) {
          if (context != null)
            Utils().ShowErrorSnackBar(context!, "Failed", '${value.message}');
          Utils().printMessage(e.toString());
        }
      } else {
        businessNameDropdownOptions.clear();
        businessNameDropdownOptions = [
          DropdownModel(id: "-1", dependentid: "-1", name: "Select")
        ];
        selectedBusiness = businessNameDropdownOptions.first;
        EasyLoading.dismiss();
        loading = false;
        notifyListeners();
        if (context != null) {
          Utils().ShowErrorSnackBar(
              context, "Server Failed", value.message ?? "Server Failure");
        } else {
          Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!,
              "Server Failed", value.message ?? "Server Failure");
        }
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      businessNameDropdownOptions.clear();
      businessNameDropdownOptions = [
        DropdownModel(id: "-1", dependentid: "-1", name: "Select")
      ];
      selectedBusiness = businessNameDropdownOptions.first;
      EasyLoading.dismiss();
      loading = false;
      notifyListeners();
      if (context != null)
        Utils().ShowErrorSnackBar(
            context, "Failed", "There is some problem occurred in Server");
      notifyListeners();
      Utils().printMessage("STATUS ERROR->$err");
    });
    notifyListeners();
  }
}
