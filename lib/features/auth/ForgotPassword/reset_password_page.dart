import 'dart:developer';

import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/auth/ForgotPassword/provider/forgot_password_provider.dart';
import 'package:bizfns/features/auth/Login/provider/login_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sizing/sizing.dart';
import 'package:provider/provider.dart';

import '../../../core/route/RouteConstants.dart';
import '../../../core/utils/Utils.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/const.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/route_function.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/common_text_form_field.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  void initState() {
    super.initState();
     log("userID----->>>>>>>${Provider.of<LoginProvider>(context, listen: false).loginMessage}");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var controller =
        Provider.of<ForgotPasswordProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFf4feff),
        body: controller.loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.APP_BAR_COLOUR,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 15),
                      child: InkWell(
                          onTap: () {
                            Navigate.NavigateAndReplace(context, login);
                            controller.newPassswordController.clear();
                            controller.confirmPasswordController.clear();

                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors
                                  .white, // Choose the background color you prefer
                            ),
                            padding:
                                EdgeInsets.all(8), // Adjust padding as needed
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors
                                  .black, // Choose the icon color you prefer
                            ),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: kIsWeb
                              ? MediaQuery.of(context).size.width / 4
                              : 20),
                      child: SingleChildScrollView(
                        child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: Provider.of<ForgotPasswordProvider>(context,
                                  listen: false)
                              .resetPasswordformKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(5.ss),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 80.ss,
                                  child: Center(
                                    child:
                                        Image.asset("assets/images/logo.png"),
                                  ),
                                ),
                              ),
                              Gap(10.ss),
                              Gap(MediaQuery.of(context).size.height / 35.ss),
                              Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: CommonText(
                                    text: "Set New Password",
                                    textStyle: CustomTextStyle(
                                        fontSize: 24.fss,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Gap(10.ss),
                              Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: CommonText(
                                    text:
                                        "Hello There! set your new password here",
                                    textStyle: CustomTextStyle(
                                        fontSize: 14.fss,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Gap(30.ss),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: CommonText(
                                    text: "New Password",
                                    textStyle: CustomTextStyle(
                                        fontSize: 14.fss,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Gap(5.ss),
                              CommonTextFormField(
                                  onValidator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter password";
                                    } else if (!Utils()
                                        .isValidPassword(value)) {
                                      return "Please enter a valid password";
                                    } else
                                      return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  controller:
                                      Provider.of<ForgotPasswordProvider>(
                                              context,
                                              listen: false)
                                          .newPassswordController,
                                  obscureText: context
                                      .watch<ForgotPasswordProvider>()
                                      .isNewPasswordHidden,
                                  fontTextStyle:
                                      CustomTextStyle(fontSize: 16.fss),
                                  decoration: InputDecoration(
                                    hintText: "New Password",
                                    border: OutlineInputBorder(gapPadding: 1),
                                    isDense: true,
                                    // isCollapsed: true,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          context
                                                  .watch<
                                                      ForgotPasswordProvider>()
                                                  .isNewPasswordHidden
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColor.BUTTON_COLOR,
                                          size: 24),
                                      onPressed: () {
                                        if (context
                                            .read<ForgotPasswordProvider>()
                                            .isNewPasswordHidden) {
                                          context
                                              .read<ForgotPasswordProvider>()
                                              .isNewPasswordHidden = false;
                                          context
                                              .read<ForgotPasswordProvider>()
                                              .notifyListeners();
                                        } else {
                                          context
                                              .read<ForgotPasswordProvider>()
                                              .isNewPasswordHidden = true;
                                          context
                                              .read<ForgotPasswordProvider>()
                                              .notifyListeners();
                                        }
                                      },
                                    ),
                                    enabledBorder:
                                        OutlineInputBorder(gapPadding: 1),
                                    focusedBorder:
                                        OutlineInputBorder(gapPadding: 1),
                                  )),
                              Gap(5.ss),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10.ss),
                                child: CommonText(
                                    text: PasswordRule,
                                    textStyle: CustomTextStyle(
                                        fontSize: 10.fss,
                                        color: AppColor.GERY)),
                              ),
                              Gap(20.ss),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: CommonText(
                                    text: "Confirm Password",
                                    textStyle: CustomTextStyle(
                                        fontSize: 14.fss,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Gap(5.ss),
                              CommonTextFormField(
                                  onValidator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter password";
                                    } else if (!Utils()
                                        .isValidPassword(value)) {
                                      return "Please enter a valid password";
                                    } else if (Provider.of<
                                                    ForgotPasswordProvider>(
                                                context,
                                                listen: false)
                                            .newPassswordController
                                            .text !=
                                        value) {
                                      return "New password and confirm password should be same";
                                    } else
                                      return null;
                                  },
                                  textInputAction: TextInputAction.done,
                                  obscureText: context
                                      .watch<ForgotPasswordProvider>()
                                      .isConfirmPasswordHidden,
                                  controller:
                                      Provider.of<ForgotPasswordProvider>(
                                              context,
                                              listen: false)
                                          .confirmPasswordController,
                                  fontTextStyle:
                                      CustomTextStyle(fontSize: 16.fss),
                                  decoration: InputDecoration(
                                    hintText: "Confirm Password",
                                    border: OutlineInputBorder(gapPadding: 1),
                                    isDense: true,
                                    // isCollapsed: true,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          context
                                                  .watch<
                                                      ForgotPasswordProvider>()
                                                  .isConfirmPasswordHidden
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColor.BUTTON_COLOR,
                                          size: 24),
                                      onPressed: () {
                                        if (context
                                            .read<ForgotPasswordProvider>()
                                            .isConfirmPasswordHidden) {
                                          context
                                              .read<ForgotPasswordProvider>()
                                              .isConfirmPasswordHidden = false;
                                          context
                                              .read<ForgotPasswordProvider>()
                                              .notifyListeners();
                                        } else {
                                          context
                                              .read<ForgotPasswordProvider>()
                                              .isConfirmPasswordHidden = true;
                                          context
                                              .read<ForgotPasswordProvider>()
                                              .notifyListeners();
                                        }
                                      },
                                    ),
                                    enabledBorder:
                                        OutlineInputBorder(gapPadding: 1),
                                    focusedBorder:
                                        OutlineInputBorder(gapPadding: 1),
                                  )),
                              Gap(30.ss),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                child: InkWell(
                                    onTap: () {
                                      controller
                                          .validationNewPasswordPage(context);
                                    },
                                    child: const CustomButton(title: "Submit")),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
//)
      ),
    );
  }
}
