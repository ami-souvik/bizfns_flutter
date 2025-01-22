import 'dart:async';

import 'package:bizfns/core/utils/fonts.dart';
import 'package:bizfns/core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/ManageProfile/provider/manage_profile_provider.dart';
import 'package:bizfns/features/auth/Login/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:sizing/sizing.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/colour_constants.dart';
import '../../../core/widgets/otp_input.dart';

class VerifyChangePasswordOTP extends StatefulWidget {
  VerifyChangePasswordOTP();

  @override
  State<VerifyChangePasswordOTP> createState() =>
      _VerifyChangePasswordOTPState();
}

class _VerifyChangePasswordOTPState extends State<VerifyChangePasswordOTP> {
  // final TextEditingController _fieldOne = TextEditingController();

  // final TextEditingController _fieldTwo = TextEditingController();

  // final TextEditingController _fieldThree = TextEditingController();

  // final TextEditingController _fieldFour = TextEditingController();

  // final TextEditingController _fieldFive = TextEditingController();

  // final TextEditingController _fieldSix = TextEditingController();

  @override
  void dispose() {
    // if( Provider.of<LoginProvider>(context,listen: false).timer!=null) Provider.of<LoginProvider>(context,listen: false).timer!.cancel();

    // Provider.of<LoginProvider>(context,listen: false).otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("VErifyxxxxxxx");
    Size size = MediaQuery.of(context).size;

    // var controller = Get.put(VerifyOtpController());

    var provider = Provider.of<ManageProfileProvider>(context, listen: false);

    int _startTime = 15;

    return SafeArea(
        child: Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   // centerTitle: true,
      //   title: const Text(
      //     "Verify OTP",
      //     style: TextStyle(color: Colors.black, fontSize: 16),
      //   ),
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       size: 22,
      //       color: Colors.black,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: SizedBox(
        //color: Colors.red,
        width: size.width,
        child: provider.loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20.ss),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(160.ss),
                    const Text(
                      "Enter verification code",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    Text(
                      provider.changePasswordData!.message!,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(20),
                    /*  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OtpInput(
                          controller: _fieldOne,
                          autoFocus: true,
                        ),
                        // auto focus
                        OtpInput(
                          controller: _fieldTwo,
                          autoFocus: false,
                        ),
                        // auto focus
                        OtpInput(
                          controller: _fieldThree,
                          autoFocus: false,
                        ),
                        // auto focus
                        OtpInput(
                          controller: _fieldFour,
                          autoFocus: false,
                        ),
                        // auto focus
                        OtpInput(
                          controller: _fieldFive,
                          autoFocus: false,
                        ),
                        // auto focus
                        OtpInput(
                          controller: _fieldSix,
                          autoFocus: false,
                        ),
                        // auto focus
                      ],
                    ),*/

                    Pinput(
                      androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                      length: 6,
                      controller: Provider.of<ManageProfileProvider>(context,
                              listen: false)
                          .otpController,
                    ),
                    Gap(10.ss),
                    Visibility(
                      visible: Provider.of<ManageProfileProvider>(context,
                                  listen: true)
                              .enableResend
                          ? false
                          : true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: CommonText(
                              text:
                                  "Resend otp after ${context.watch<ManageProfileProvider>().secondsRemaining} seconds",
                              textStyle: CustomTextStyle(
                                  color: AppColor.APP_BAR_COLOUR),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: Provider.of<ManageProfileProvider>(context,
                              listen: true)
                          .enableResend,
                      child: InkWell(
                        onTap: () {
                          provider.resendCode(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: CommonText(
                              text: "Resend",
                              textStyle: CustomTextStyle(
                                  color: AppColor.APP_BAR_COLOUR,
                                  fontSize: 16.ss)),
                        ),
                      ),
                    ),
                    const Gap(20),
                    InkWell(
                        onTap: () {
                          provider.otpPagevalidation(
                              context, provider.otpController.text);
                        },
                        child: CustomButton(
                          title: "Verify OTP",
                        ))
                  ],
                ),
              ),
      ),
    ));
  }
}
