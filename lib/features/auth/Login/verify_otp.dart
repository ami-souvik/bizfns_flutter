import 'dart:async';
import 'dart:developer';

import 'package:bizfns/core/utils/fonts.dart';
import 'package:bizfns/core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/ManageProfile/provider/manage_profile_provider.dart';
import 'package:bizfns/features/auth/Login/provider/login_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:sizing/sizing.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/colour_constants.dart';
import '../../../core/widgets/otp_input.dart';

class VerifyOTP extends StatefulWidget {
  final String forWhat;

  const VerifyOTP({super.key, required this.forWhat});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  @override
  void initState() {
    print("ForWhat===========>${widget.forWhat}");
    print(
        "tenant id in otp validation initState======>${Provider.of<LoginProvider>(context, listen: false).selectedBusiness.id}");
    log("userID----->>>>>>>${Provider.of<LoginProvider>(context, listen: false).userIdController.text}");
    super.initState();
  }

  @override
  void dispose() {
    // if( Provider.of<LoginProvider>(context,listen: false).timer!=null) Provider.of<LoginProvider>(context,listen: false).timer!.cancel();

    // Provider.of<LoginProvider>(context,listen: false).otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // var controller = Get.put(VerifyOtpController());

    var provider = Provider.of<LoginProvider>(context, listen: false);

    int _startTime = 15;

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   // centerTitle: true,
        //   title: Center(
        //     child:  Text(
        //       "Verify OTP",
        //       style: TextStyle(color: Colors.black, fontSize: 16.fss),
        //     ),
        //   ),
        //   // leading: IconButton(
        //   //   icon: const Icon(
        //   //     Icons.arrow_back,
        //   //     size: 22,
        //   //     color: Colors.black,
        //   //   ),
        //   //   onPressed: () {
        //   //     Navigator.pop(context);
        //   //   },
        //   // ),
        //   automaticallyImplyLeading: false,
        // ),

        body: provider.loading
            ? SizedBox(
                //color: Colors.red,
                width: size.width,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ))
            : SingleChildScrollView(
                child: Container(
                  height: size.height,
                  child: Column(
                    // shrinkWrap: true,

                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: kIsWeb
                                  ? MediaQuery.of(context).size.width / 4
                                  : 20.ss),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Gap(size.height / 12.ss),
                              Padding(
                                padding: EdgeInsets.all(8.0.ss),
                                child: SizedBox(
                                  height: 80.ss,
                                  child: Center(
                                    child:
                                        Image.asset("assets/images/logo.png"),
                                  ),
                                ),
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     const Text(
                              //       "Simple Services",
                              //       style: TextStyle(
                              //           fontSize: 18,
                              //           fontFamily: "Roboto",
                              //           color: Colors.black),
                              //     ),
                              //   ],
                              // ),

                              Gap(10.ss),
                              CommonText(
                                  text: "OTP Sent",
                                  textStyle: CustomTextStyle(
                                      fontSize: 24.fss,
                                      fontWeight: FontWeight.w700)),
                              Gap(10.ss),
                              // Gap(30.ss),
                              widget.forWhat == "newMobileUpdate"
                                  ? Text("")
                                  : Text(
                                      provider.model!.otp_message ?? "",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.center,
                                    ),

                              Gap(20.ss),

                              Center(
                                child: Pinput(
                                  androidSmsAutofillMethod:
                                      AndroidSmsAutofillMethod.none,
                                  length: 6,
                                  controller: widget.forWhat == ""
                                      ? Provider.of<LoginProvider>(context,
                                              listen: false)
                                          .otpController
                                      : Provider.of<ManageProfileProvider>(
                                              context,
                                              listen: false)
                                          .otpController,
                                ),
                              ),
                              Gap(10.ss),
                              if (widget.forWhat == "")
                                Visibility(
                                  visible: Provider.of<LoginProvider>(context,
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
                                              "Resend otp after ${context.watch<LoginProvider>().secondsRemaining} seconds",
                                          textStyle: CustomTextStyle(
                                              color: AppColor.APP_BAR_COLOUR),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (widget.forWhat == "newMobileUpdate")
                                Visibility(
                                  visible: Provider.of<ManageProfileProvider>(
                                              context,
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
                              if (widget.forWhat == "")
                                Visibility(
                                  visible: Provider.of<LoginProvider>(context,
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
                              if (widget.forWhat == "newMobileUpdate")
                                Visibility(
                                  visible: Provider.of<ManageProfileProvider>(
                                          context,
                                          listen: true)
                                      .enableResend,
                                  child: InkWell(
                                    onTap: () {
                                      Provider.of<ManageProfileProvider>(
                                              context,
                                              listen: false)
                                          .resendCode(context);
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
                              Gap(20.ss),
                              Center(
                                child: InkWell(
                                    onTap: () {
                                      //  print(
                                      //    "tenant id in button click ===>${Provider.of<LoginProvider>(context, listen: false).sselectedBusiness}");
                                      if (widget.forWhat == "") {
                                        Provider.of<LoginProvider>(context,
                                                        listen: false)
                                                    .otpController
                                                    .text
                                                    .length ==
                                                6
                                            ? provider.otpPageValidation(
                                                context,
                                                provider.otpController.text)
                                            : null;
                                      } else {
                                        print(
                                            "otp from new phone change ==>${Provider.of<ManageProfileProvider>(context, listen: false).otpController.text}");
                                        Provider.of<ManageProfileProvider>(
                                                context,
                                                listen: false)
                                            .saveChangesMobile(context);
                                      }
                                    },
                                    child: CustomButton(
                                      title: "Verify OTP",
                                    )),
                              ),
                            ],
                          )),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: size.height / 4.ss,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: AssetImage(
                                          "assets/images/login_bottom_background.png"))),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
