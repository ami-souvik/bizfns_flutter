import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../core/utils/fonts.dart';
import '../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../core/widgets/common_text.dart';
import '../../core/widgets/common_text_form_field.dart';
import 'provider/manage_profile_provider.dart';

class RetypeNewPhone extends StatefulWidget {
  const RetypeNewPhone({super.key});

  @override
  State<RetypeNewPhone> createState() => _RetypeNewPhoneState();
}

class _RetypeNewPhoneState extends State<RetypeNewPhone> {
  final GlobalKey<FormState> retypeNewPhoneNoFormKey = GlobalKey<FormState>();
  TextEditingController newPhoneNoController = TextEditingController();

  @override
  void dispose() {
    newPhoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: size.height,
        child: Column(
          // shrinkWrap: true,

          children: [
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        kIsWeb ? MediaQuery.of(context).size.width / 4 : 20.ss),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Gap(size.height / 12.ss),
                    Padding(
                      padding: EdgeInsets.all(8.0.ss),
                      child: SizedBox(
                        height: 20.ss,
                        child: Center(
                          child: Image.asset("assets/images/logo.png"),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Simple Services",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Roboto",
                              color: Colors.black),
                        ),
                      ],
                    ),

                    Gap(10.ss),
                    CommonText(
                        text: "Retype New Phone No.",
                        textStyle: CustomTextStyle(
                            fontSize: 24.fss, fontWeight: FontWeight.w700)),
                    Gap(10.ss),
                    // Gap(30.ss),
                    // Text(
                    //   provider.model!.otp_message ?? "",
                    //   style: TextStyle(
                    //       fontSize: 14,
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.normal),
                    //   textAlign: TextAlign.center,
                    // ),

                    Gap(20.ss),
                    Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: retypeNewPhoneNoFormKey,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
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
                              controller: Provider.of<ManageProfileProvider>(
                                      context,
                                      listen: false)
                                  .newPhoneNoController,
                              fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                              maxLength: 14,
                              decoration: const InputDecoration(
                                hintText: "Enter 10 Digit Mobile Number",
                                counterText: "",
                                border: OutlineInputBorder(gapPadding: 1),
                                isDense: true,
                                // isCollapsed: true,
                                enabledBorder:
                                    OutlineInputBorder(gapPadding: 1),
                                focusedBorder:
                                    OutlineInputBorder(gapPadding: 1),
                              ),
                            ),
                            Gap(10.ss),
                            // CommonTextFormField(
                            //   onValidator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return "Please enter password";
                            //     } else if (!Utils().isValidPassword(value)) {
                            //       return "Please enter a valid password";
                            //     } else
                            //       return null;
                            //   },
                            //   textInputAction: TextInputAction.next,
                            //   controller: verifyPasswordController,
                            //   fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                            //   decoration: const InputDecoration(
                            //     hintText: "Create Password",
                            //     border: OutlineInputBorder(gapPadding: 1),
                            //     isDense: true,
                            //     enabledBorder:
                            //         OutlineInputBorder(gapPadding: 1),
                            //     focusedBorder:
                            //         OutlineInputBorder(gapPadding: 1),
                            //   ),
                            // ),
                            Gap(20.ss),
                            Center(
                              child: InkWell(
                                  onTap: () {
                                    if (retypeNewPhoneNoFormKey.currentState!
                                        .validate()) {
                                      retypeNewPhoneNoFormKey.currentState!
                                          .save();
                                    } else {}
                                    Provider.of<ManageProfileProvider>(context,
                                            listen: false)
                                        .getOtpForMobileChanges(context);
                                  },
                                  child: CustomButton(
                                    title: "Verify Otp",
                                  )),
                            ),
                          ],
                        )),
                    // Gap(10.ss),
                    // Visibility(
                    //   visible: Provider.of<LoginProvider>(context, listen: true)
                    //           .enableResend
                    //       ? false
                    //       : true,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Container(
                    //         alignment: Alignment.center,
                    //         child: CommonText(
                    //           text:
                    //               "Resend otp after ${context.watch<LoginProvider>().secondsRemaining} seconds",
                    //           textStyle: CustomTextStyle(
                    //               color: AppColor.APP_BAR_COLOUR),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Visibility(
                    //   visible: Provider.of<LoginProvider>(context, listen: true)
                    //       .enableResend,
                    //   child: InkWell(
                    //     onTap: () {
                    //       provider.resendCode(context);
                    //     },
                    //     child: Container(
                    //       alignment: Alignment.center,
                    //       child: CommonText(
                    //           text: "Resend",
                    //           textStyle: CustomTextStyle(
                    //               color: AppColor.APP_BAR_COLOUR,
                    //               fontSize: 16.ss)),
                    //     ),
                    //   ),
                    // ),
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
    );
  }
}
