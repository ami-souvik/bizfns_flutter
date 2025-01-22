import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../core/utils/Utils.dart';
import '../../core/utils/colour_constants.dart';
import '../../core/utils/fonts.dart';
import '../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../core/widgets/common_text.dart';
import '../../core/widgets/common_text_form_field.dart';
import 'provider/manage_profile_provider.dart';

class VerifyPassword extends StatefulWidget {
  const VerifyPassword({super.key});

  @override
  State<VerifyPassword> createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  TextEditingController verifyPasswordController = TextEditingController();
  TextEditingController newPhoneNoController = TextEditingController();
  final GlobalKey<FormState> verifyPasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<ManageProfileProvider>(context, listen: false)
        .initialController();
  }

  @override
  void dispose() {
    verifyPasswordController.dispose();
    newPhoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFf4feff),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height / 6,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/images/login_bottom_background.png",
                width: size.width, // Adjust the width as needed
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          // Gap(20.ss),
          Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: verifyPasswordFormKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Gap(MediaQuery.of(context).size.height / 15.ss),
                    Padding(
                      padding: EdgeInsets.all(8.0.ss),
                      child: SizedBox(
                        height: 88.ss,
                        child: Center(
                          child: Image.asset("assets/images/logo.png"),
                        ),
                      ),
                    ),
                    Gap(25.ss),
                    Padding(
                      padding: EdgeInsets.only(left: 12.ss),
                      child: CommonText(
                          text: "Verify Password",
                          textStyle: CustomTextStyle(
                              fontSize: 24.fss, fontWeight: FontWeight.w700)),
                    ),
                    Gap(35.ss),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10.0.ss, right: 10.ss, bottom: 5.ss),
                      child: CommonText(
                          text: "Enter Mobile Number",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700)),
                    ),
                    CommonTextFormField(
                      onValidator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please enter 10 digit mobile no";
                        } else if (value != null &&
                            !value.isEmpty &&
                            value.length < 10) {
                          return "Please enter 10 digit mobile no";
                        } else
                          return null;
                      },
                      onTap: () {
                        // Provider.of<SignupProvider>(context,
                        //         listen: false)
                        //     .validationLevelOne(context);
                      },
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        MaskTextInputFormatter(
                            mask: '(###) ###-####',
                            filter: {"#": RegExp(r'[0-9]')},
                            type: MaskAutoCompletionType.lazy),
                      ],
                      controller: newPhoneNoController,
                      fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                      maxLength: 14,
                      decoration: const InputDecoration(
                        hintText: "Enter 10 Digit Mobile Number",
                        counterText: "",
                        border: OutlineInputBorder(gapPadding: 1),
                        isDense: true,
                        // isCollapsed: true,
                        enabledBorder: OutlineInputBorder(gapPadding: 1),
                        focusedBorder: OutlineInputBorder(gapPadding: 1),
                      ),
                    ),
                    Gap(10.ss),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10.0.ss, right: 12.ss, bottom: 5.ss),
                      child: CommonText(
                          text: "Enter Password",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700)),
                    ),
                    CommonTextFormField(
                      obscureText: Provider.of<ManageProfileProvider>(context,
                              listen: false)
                          .isPhonePasswordHidden,
                      onValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter password";
                        } else if (!Utils().isValidPassword(value)) {
                          return "Please enter a valid password";
                        } else
                          return null;
                      },
                      textInputAction: TextInputAction.next,
                      controller: verifyPasswordController,
                      fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                              context
                                      .watch<ManageProfileProvider>()
                                      .isPhonePasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColor.BUTTON_COLOR,
                              size: 24),
                          onPressed: () {
                            if (context
                                .read<ManageProfileProvider>()
                                .isPhonePasswordHidden) {
                              context
                                  .read<ManageProfileProvider>()
                                  .isPhonePasswordHidden = false;
                              context
                                  .read<ManageProfileProvider>()
                                  .notifyListeners();
                            } else {
                              context
                                  .read<ManageProfileProvider>()
                                  .isPhonePasswordHidden = true;
                              context
                                  .read<ManageProfileProvider>()
                                  .notifyListeners();
                            }
                          },
                        ),
                        hintText: "Enter Your Password",
                        border: OutlineInputBorder(gapPadding: 1),
                        isDense: true,
                        enabledBorder: OutlineInputBorder(gapPadding: 1),
                        focusedBorder: OutlineInputBorder(gapPadding: 1),
                      ),
                    ),
                    Gap(20.ss),
                    Center(
                      child: InkWell(
                          onTap: () {
                            if (verifyPasswordFormKey.currentState!
                                .validate()) {
                              verifyPasswordFormKey.currentState!.save();
                            } else {}
                            if (verifyPasswordController.text.isNotEmpty &&
                                newPhoneNoController.text.length == 14) {
                              Provider.of<ManageProfileProvider>(context,
                                      listen: false)
                                  .verifyPassword(
                                      verifyPasswordController.text, context);
                            } else {
                              print("Password not 10 digit long");
                            }
                            print(verifyPasswordController.text.length);
                          },
                          child: CustomButton(
                            title: "Verify Password",
                          )),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
