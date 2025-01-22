import 'dart:async';
import 'dart:convert';

import 'package:bizfns/core/model/dropdown_model.dart';
import 'package:bizfns/core/shared_pref/shared_pref.dart';
import 'package:bizfns/features/auth/Login/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/Status.dart';
import '../../../../core/route/RouteConstants.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/alert_dialog.dart';
import '../../../../core/utils/route_function.dart';
import '../../Login/model/login_model.dart';
import '../../data/api/auth_api_client/auth_api_client.dart';
import '../model/BusinessCategory.dart';
import '../model/BusinessType.dart';
import '../model/pre_registration_data.dart';
import '../model/signup_otp_model.dart';
import '../repo/signup_repo_impl.dart';

class SignupProvider extends ChangeNotifier {
  bool isChecked = false;
  bool loading = false;
  int selectedPlan = 0;
  String TermsAndCondition = "";
  bool isPasswordVisible = true;
  bool isConfirmPasswordHidden = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  late SignupOtpData model;

  TextEditingController businessNameController = new TextEditingController();
  TextEditingController businessTypeController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  TextEditingController otpController = new TextEditingController();

  List<DropdownModel> businessCategory = [];
  List<BusinessCategoryType> allBusinessCategory = [];

  DropdownModel selectedBusinessCategory = DropdownModel(
    id: "-1",
    dependentid: "-1",
    name: "Select One",
  );
  DropdownModel selectedBusinessType = DropdownModel(
      id: "-1", dependentid: "-1", name: "Select Business Category First");

  List<DropdownModel> businessTypes = [];
  List<PlanList> planList = [];
  // LoginControllerProvider({this.loginRepository});
  bool enableResend = false;
  int secondsRemaining = 30;
  InitialControllers() {
    isConfirmPasswordHidden = true;
  }

  DisposeControllers() {
    businessNameController.text = "";
    businessTypeController.text = "";
    phoneController.text = "";
    emailController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    secondsRemaining = 30;
    otpController.text = "";
    enableResend = false;

    businessCategory.clear();
    businessCategory.add(DropdownModel(
      id: "-1",
      dependentid: "-1",
      name: "Select One",
    ));
    businessTypes.clear();
    businessTypes.add(DropdownModel(
        id: "-1", dependentid: "-1", name: "Select Business Category First"));
    selectedBusinessCategory = businessCategory.first;
    selectedBusinessType = businessTypes.first;
  }

  var signupRepository = SignupRepoImpl(apiClient: AuthApiClient());

  ///For local validation
  void validationLevelOne(BuildContext context) {
//     if (businessNameFieldKey.currentState!.validate()) {
// //    If all data are correct then save data to out variables
//       businessNameFieldKey.currentState!.save();
//
//     } else {
// //    If all data are not valid then start auto validation.
//       autoValidate = true;
//       notifyListeners();
//     }
    if (businessNameController.text.isEmpty) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter business name");

      return;
    } else if (businessNameController.text.length < 4) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Business name should have minimum 4 characters");
      return;
    } else if (selectedBusinessCategory.id == "-1") {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please choose business category");

      return;
    } else if (selectedBusinessType.id == "-1") {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter business type");

      return;
    }
  }

  ///For local validation
  void ValidationLevelTwo(BuildContext context) {
//     if (formKey.currentState!.validate()) {
// //    If all data are correct then save data to out variables
//       formKey.currentState!.save();
//     } else {
// //    If all data are not valid then start auto validation.
//         autoValidate = true;
//         notifyListeners();
//     }
    if (businessNameController.text.isEmpty) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter business name");

      return;
    } else if (businessNameController.text.length < 4) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Business name should have minimum 4 characters");

      return;
    } else if (selectedBusinessCategory.id == "-1") {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please choose business category");

      return;
    } else if (selectedBusinessType.id == "-1") {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter business type");

      return;
    } else if (phoneController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Enter 10 digit mobile no");

      return;
    } else if (phoneController.text.length < 14) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid mobile no");

      return;
    }
  }

  ///For local validation
  void ValidationLevelThree(BuildContext context) {
    if (businessNameController.text.isEmpty) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter business name");

      return;
    } else if (businessNameController.text.length < 4) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Business name should have minimum 4 characters");
      return;
    } else if (selectedBusinessCategory.id == "-1") {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please choose business category");
      return;
    } else if (selectedBusinessType.id == "-1") {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter business type");
      return;
    } else if (phoneController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Enter 10 digit mobile no");
      return;
    } else if (phoneController.text.length < 14) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid mobile no");
      return;
    } else if (emailController.text.isNotEmpty &&
        !Utils.IsValidEmail(emailController.text)) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid email id");
      return;
    }
  }

  ///For local validation
  void ValidationLevelFour(BuildContext context) {
//     if (formKey.currentState!.validate()) {
// //    If all data are correct then save data to out variables
//       formKey.currentState!.save();
//     } else {
// //    If all data are not valid then start auto validation.
//       autoValidate = true;
//       notifyListeners();
//     }
    if (businessNameController.text.isEmpty) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter business name");
      return;
    } else if (businessNameController.text.length < 4) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Business name should have minimum 4 characters");
      return;
    } else if (selectedBusinessCategory.id == "-1") {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please choose business category");
      return;
    } else if (selectedBusinessType.id == "-1") {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter business type");
      return;
    } else if (phoneController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Enter 10 digit mobile no");
      return;
    } else if (phoneController.text.length < 14) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid mobile no");
      return;
    } else if (emailController.text.isNotEmpty &&
        !Utils.IsValidEmail(emailController.text)) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid email id");
      return;
    } else if (passwordController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter password");
      return;
    } else if (!Utils().isValidPassword(passwordController.text)) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid password");
      return;
    }
  }

  ///For local validation when submit button is hit
  void validition(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    } else {
      autoValidate = true;
      notifyListeners();
    }
    if (businessNameController.text.isEmpty) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter business name");
      return;
    } else if (businessNameController.text.trim().length < 4) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Business name should have minimum 4 characters");
      return;
    } else if (selectedBusinessCategory.id == "-1") {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please choose business category");
      return;
    } else if (selectedBusinessType.id == "-1") {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter business type");
      return;
    } else if (phoneController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Enter 10 digit mobile no");
      return;
    } else if (phoneController.text.length < 14) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid mobile no");
      return;
    } else if (emailController.text.isNotEmpty &&
        !Utils.IsValidEmail(emailController.text)) {
      Utils()
          .ShowWarningSnackBar(context, "OOPS!", "Please enter a valid email");
      return;
    } else if (passwordController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please enter password");
      return;
    } else if (!Utils().isValidPassword(passwordController.text)) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid password");
      return;
    } else if (confirmPasswordController.text.isEmpty) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter confirm password");
      return;
    } else if (!Utils().isValidPassword(confirmPasswordController.text)) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Please enter a valid confirm password");
      return;
    } else if (passwordController.text != confirmPasswordController.text) {
      Utils().ShowWarningSnackBar(
          context, "OOPS!", "Password and confirm password should be same");
      return;
    }
    // else if(passwordController.text != confirmPasswordController.text){
    //   Utils().ShowWarningSnackBar(context,"OOPS!","Password and confirm password should be same");
    //   return;
    // }
    else {
      Utils().check_internet_connection(context).then((value) async {
        Utils().printMessage("Has Internet");
        if (value != null && value == true) {
          Utils().printMessage("==value==$value");

          List<String> deviceDetails = await Utils.getDeviceDetails();
          var body = {
            "deviceId": deviceDetails[0],
            "deviceType": deviceDetails[1],
            "appVersion": deviceDetails[2],
            "planId": selectedPlan == 0 ? 1 : selectedPlan,
            "businessName": businessNameController.text,
            "businessType": selectedBusinessType.id,
            "businessCategory": selectedBusinessCategory.id,
            "phoneNumber": phoneController.text
                .replaceAll('(', '')
                .replaceAll(')', '')
                .replaceAll('-', '')
                .removeAllWhitespace,
            "businessEmail": emailController.text,
            "password": passwordController.text
          };
          // CallRegistrationApi(context, body);
          SendOtp(context);
        }
      });
    }
  }

  ///Call Api for send registration data to server
  CallRegistrationApi(BuildContext context, Map body) async {
    Utils().printMessage("==UserRegistration==");
    // Utils.ShowLoader(context,title: "Processing");
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);

    loading = true;
    notifyListeners();
    signupRepository.signup(body: body).then((value) async {
      loading = false;
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        // Utils.HideLoader(context);
        await GlobalHandler.setUserId(phoneController.text);
        await GlobalHandler.setCompanyName(businessNameController.text);
        businessNameController.text = "";
        businessTypeController.text = "";
        phoneController.text = "";
        emailController.text = "";
        passwordController.text = "";
        confirmPasswordController.text = "";
        EasyLoading.dismiss();
        Utils().printMessage(value.data);
        Utils().printMessage("STATUS SUCCESS");
        await GlobalHandler.setCompanyId(value.data.toString());

        ShowSuccessDialog(
            context: context,
            msg: value.message! +
                "\n Your Business Id is " +
                value.data.toString(),
            title: "Success",
            onOkTap: () {
              // context.pop();
              Navigate.NavigatePushUntil(context, login);
              // Navigate.NavigatePushUntil(context, login);
              //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              //       builder: (context) => LoginPage()), (Route route) => false);
            });
      } else {
        // Utils.HideLoader(context);
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(context, "OOPS!", value.message ?? "");
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      loading = false;
      // Utils.HideLoader(context);
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(context, "OOPS!", err.message ?? "");
      notifyListeners();
      Utils().printMessage("STATUS ERROR->$err");
    });

    notifyListeners();
  }

  ///Call Api for get Subscription list, Business category and type
  CallPreRegistrationApi(BuildContext context) async {
    Utils().printMessage("==Pre Registration Api Call==");
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    // notifyListeners();
    signupRepository.preSignupData().then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          var commonData = value.data;
          if (commonData != null) {
            if (commonData!.businessCategoryType != null &&
                commonData!.businessCategoryType!.isNotEmpty) {
              businessCategory.clear();
              businessTypes.clear();
              businessCategory.add(DropdownModel(
                id: "-1",
                dependentid: "-1",
                name: "Select One",
              ));
              businessTypes.add(DropdownModel(
                  id: "-1",
                  dependentid: "-1",
                  name: "Select Business Category First"));
              int i = 0;
              allBusinessCategory.clear();
              allBusinessCategory.addAll(commonData!.businessCategoryType!);
              for (var category in commonData!.businessCategoryType!) {
                var cat = DropdownModel(
                    id: category.pKCATEGORYID.toString(),
                    name: category.cATEGORYNAME,
                    desc: category.CATEGORYDESCRIPTION);
                var type = DropdownModel(
                    dependentid: category.pKCATEGORYID.toString(),
                    name: category.bUSINESSTYPEENTITY,
                    id: category.pKBUSINESSTYPEID.toString());

                if (i == 0) {
                  businessCategory.add(cat);
                  // businessTypes.add(type);
                  // selectedBusinessCategory = cat;;
                  // selectedBusinessType = type;
                } else {
                  bool match = false;
                  for (var mcat in businessCategory) {
                    if (mcat.id == cat.id) {
                      match = true;
                    }
                  }
                  if (!match) businessCategory.add(cat);
                  if (selectedBusinessType.id == cat.id) {
                    businessTypes.add(type);
                  }
                }
                i++;
              }

              Utils().printMessage(
                  "Categories====>>>" + businessCategory.length.toString());
              Utils().printMessage(
                  "Types====>>>" + businessTypes.length.toString());
              Utils().printMessage("Types====>>>" + selectedBusinessType.name!);
              Utils().printMessage(
                  "Types====>>>" + selectedBusinessCategory.name!);
            }
            // businessCategory.addAll(commonData!.businessCategoryType!);
            //  businessCategory.map((item) => BusinessCategory.fromJson(commonData!.businessCategory!)).toList();
          } else {
            context.pop();
          }

          if (commonData!.planList != null &&
              commonData!.planList!.isNotEmpty) {
            //List<PlanList> data=commonData.planList.cast<PlanList>();
            planList.clear();
            planList.addAll(commonData!.planList);
            //var list= commonData!planList.map((item) => PlanList.fromJson(item)).toList();
            // planList.addAll(data);
          }

          print(planList.length);
          if (commonData!.termsAndCondition != null &&
              commonData!.termsAndCondition!.isNotEmpty) {
            TermsAndCondition = commonData!.termsAndCondition!;
          }
          loading = false;
          notifyListeners();
        } catch (e) {
          loading = false;
          Utils().printMessage("STATUS Failure ==>>> " + e.toString());
        }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  ///Change Privacy policy Check box
  void ChangeCheck(bool checked) {
    isChecked = checked;
    notifyListeners();
  }

  ///Start timer for resend otp
  StartTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining != 0) {
        secondsRemaining--;
      } else {
        timer.cancel();
        enableResend = true;
      }
      notifyListeners();
    });
  }

  ///Resend the otp
  void resendCode(BuildContext context) {
    //other code here
    otpController.clear();
    secondsRemaining = 30;
    enableResend = false;
    SendOtp(context, isResend: true);
    notifyListeners();
  }

  ///Load initial data for registration page
  void LoadData(BuildContext context) async {
    // kIsWeb ?.CallPreRegistrationApi():
    selectedBusinessCategory = DropdownModel(
      id: "-1",
      dependentid: "-1",
      name: "Select One",
    );
    selectedBusinessType = DropdownModel(
        id: "-1", dependentid: "-1", name: "Select Business Category First");
    businessCategory = [];

    allBusinessCategory = [];

    businessTypes = [];
    planList = [];
    Utils().check_internet_connection(context).then((value) {
      Utils().printMessage("Has Internet");
      if (value != null && value == true) {
        CallPreRegistrationApi(context);
      } else {
        Utils().ShowWarningSnackBar(context, "Opps!!", "No Internet");
        Navigator.pop(context);
        loading = false;
      }
    });
  }

  ///Validation of otp written by the user
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
          VerifyOtp(context);
        }
      });
    }
  }

  ///Send otp to the user
  void SendOtp(BuildContext context, {bool? isResend}) {
    Utils().printMessage("==RegistrationSendOtp==");
    // Utils.ShowLoader(context,title: "Processing");
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);

    loading = true;
    notifyListeners();
    signupRepository
        .signupSendOtp(
            userId: phoneController.text, emailId: emailController.text)
        .then((value) async {
      loading = false;

      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        // Utils.HideLoader(context);
        EasyLoading.dismiss();
        // Utils().printMessage(value.data);
        Utils().printMessage("STATUS SUCCESS");
        model = value.data;
        Utils().ShowSuccessSnackBar(context, "Success!", model.otp ?? "",
            duration: const Duration(seconds: 14));
        Navigate(context, verify_registration_otp);
        StartTimer();
      } else {
        // Utils.HideLoader(context);
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(context, "OOPS!", value.message ?? "");
        Utils().printMessage("STATUS FAILED");
      }
    }, onError: (err) {
      loading = false;
      // Utils.HideLoader(context);
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(context, "OOPS!", err.message ?? "");
      notifyListeners();
      Utils().printMessage("STATUS ERROR->$err");
    });

    notifyListeners();
  }

  ///Api call for otp verification
  void VerifyOtp(BuildContext context) async {
    // loading_state.value = true;
    loading = true;
    EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    notifyListeners();
    var body = {
      "userId": phoneController.text,
      "otp": otpController.text,
      "otpTimeStamp": ""
    };
    await signupRepository.verifySignupOtp(body: body).then((value) async {
      // loading_state.value = false;

      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        Utils().printMessage("STATUS SUCCESS");
        //context.go(Routes.HOME);
        EasyLoading.dismiss();
        loading = false;
        Utils().check_internet_connection(context).then((value) async {
          Utils().printMessage("Has Internet");
          if (value != null && value == true) {
            Utils().printMessage("==value==$value");

            List<String> deviceDetails = await Utils.getDeviceDetails();
            var body = {
              "deviceId": deviceDetails[0],
              "deviceType": deviceDetails[1],
              "appVersion": deviceDetails[2],
              "planId": selectedPlan == 0 ? 1 : selectedPlan,
              "businessName": businessNameController.text,
              "businessType": selectedBusinessType.id,
              "businessCategory": selectedBusinessCategory.id,
              "phoneNumber": phoneController.text
                  .replaceAll('(', '')
                  .replaceAll(')', '')
                  .replaceAll('-', '')
                  .removeAllWhitespace
                  .trim(),
              "businessEmail":
                  emailController.text.isEmpty ? null : emailController.text,
              "password": passwordController.text
            };
            CallRegistrationApi(context, body);
          }
        });
      } else {
        loading = false;
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

  phoneNoRegCheck(BuildContext context) async {
    // loading = true;
    // EasyLoading.show(status: "Loading", indicator: CircularProgressIndicator());
    // notifyListeners();
    print(
        "phoneController.text----->${phoneController.text.removeAllWhitespace.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').trim()}");
    var body = {
      "phoneNumber": phoneController.text.removeAllWhitespace
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll('-', '')
          .trim()
    };

    await signupRepository.phoneNoRegCheck(body: body).then((value) {
      notifyListeners();
      if (value.status == STATUS.SUCCESS) {
        print("SUCCESS");
        // loading = false;
        // EasyLoading.dismiss();
      } else {
        Utils().ShowWarningSnackBar(
          context,
          "",
          '${value.message} But you can add one more' ?? "",
        );
        // loading = false;
        // EasyLoading.dismiss();
      }
      notifyListeners();
    });
  }
}
