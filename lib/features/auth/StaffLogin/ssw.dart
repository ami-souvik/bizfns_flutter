// SingleChildScrollView(
//       child: Container(
//         height: size.height,
//         child: Column(
//           // shrinkWrap: true,

//           children: [
//             Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal:
//                         kIsWeb ? MediaQuery.of(context).size.width / 4 : 20.ss),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Gap(size.height / 12.ss),
//                     Padding(
//                       padding: EdgeInsets.all(8.0.ss),
//                       child: SizedBox(
//                         height: 80.ss,
//                         child: Center(
//                           child: Image.asset("assets/images/logo.png"),
//                         ),
//                       ),
//                     ),
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.center,
//                     //   children: [
//                     //     const Text(
//                     //       "Simple Services",
//                     //       style: TextStyle(
//                     //           fontSize: 18,
//                     //           fontFamily: "Roboto",
//                     //           color: Colors.black),
//                     //     ),
//                     //   ],
//                     // ),

//                     Gap(10.ss),
//                     CommonText(
//                         text: "Verify Password",
//                         textStyle: CustomTextStyle(
//                             fontSize: 24.fss, fontWeight: FontWeight.w700)),
//                     Gap(10.ss),
//                     // Gap(30.ss),
//                     // Text(
//                     //   provider.model!.otp_message ?? "",
//                     //   style: TextStyle(
//                     //       fontSize: 14,
//                     //       color: Colors.black,
//                     //       fontWeight: FontWeight.normal),
//                     //   textAlign: TextAlign.center,
//                     // ),

//                     Gap(20.ss),
//                     Form(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         key: verifyPasswordFormKey,
//                         child: ListView(
//                           shrinkWrap: true,
//                           children: [
//                             Padding(
//                               padding:
//                                   EdgeInsets.symmetric(horizontal: 10.0.ss),
//                               child: CommonText(
//                                   text: "Enter 10 Digit No",
//                                   textStyle: CustomTextStyle(
//                                       fontSize: 14.fss,
//                                       fontWeight: FontWeight.w700)),
//                             ),
//                             CommonTextFormField(
//                               onValidator: (value) {
//                                 if (value != null && value.isEmpty) {
//                                   return "Please enter 10 digit mobile no";
//                                 } else if (value != null &&
//                                     !value.isEmpty &&
//                                     value.length < 10) {
//                                   return "Please enter 10 digit mobile no";
//                                 } else
//                                   return null;
//                               },
//                               onTap: () {
//                                 // Provider.of<SignupProvider>(context,
//                                 //         listen: false)
//                                 //     .validationLevelOne(context);
//                               },
//                               textInputAction: TextInputAction.next,
//                               textInputType: TextInputType.number,
//                               inputFormatters: [
//                                 MaskTextInputFormatter(
//                                     mask: '(###) ###-####',
//                                     filter: {"#": RegExp(r'[0-9]')},
//                                     type: MaskAutoCompletionType.lazy),
//                               ],
//                               controller: newPhoneNoController,
//                               fontTextStyle: CustomTextStyle(fontSize: 16.fss),
//                               maxLength: 14,
//                               decoration: const InputDecoration(
//                                 hintText: "Enter 10 Digit Mobile Number",
//                                 counterText: "",
//                                 border: OutlineInputBorder(gapPadding: 1),
//                                 isDense: true,
//                                 // isCollapsed: true,
//                                 enabledBorder:
//                                     OutlineInputBorder(gapPadding: 1),
//                                 focusedBorder:
//                                     OutlineInputBorder(gapPadding: 1),
//                               ),
//                             ),
//                             Gap(10.ss),
//                             Padding(
//                               padding:
//                                   EdgeInsets.symmetric(horizontal: 10.0.ss),
//                               child: CommonText(
//                                   text: "Enter Your Password",
//                                   textStyle: CustomTextStyle(
//                                       fontSize: 14.fss,
//                                       fontWeight: FontWeight.w700)),
//                             ),
//                             CommonTextFormField(
//                               obscureText: Provider.of<ManageProfileProvider>(
//                                       context,
//                                       listen: false)
//                                   .isPhonePasswordHidden,
//                               onValidator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return "Please enter password";
//                                 } else if (!Utils().isValidPassword(value)) {
//                                   return "Please enter a valid password";
//                                 } else
//                                   return null;
//                               },
//                               textInputAction: TextInputAction.next,
//                               controller: verifyPasswordController,
//                               fontTextStyle: CustomTextStyle(fontSize: 16.fss),
//                               decoration: InputDecoration(
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                       context
//                                               .watch<ManageProfileProvider>()
//                                               .isPhonePasswordHidden
//                                           ? Icons.visibility_off
//                                           : Icons.visibility,
//                                       color: AppColor.BUTTON_COLOR,
//                                       size: 24),
//                                   onPressed: () {
//                                     if (context
//                                         .read<ManageProfileProvider>()
//                                         .isPhonePasswordHidden) {
//                                       context
//                                           .read<ManageProfileProvider>()
//                                           .isPhonePasswordHidden = false;
//                                       context
//                                           .read<ManageProfileProvider>()
//                                           .notifyListeners();
//                                     } else {
//                                       context
//                                           .read<ManageProfileProvider>()
//                                           .isPhonePasswordHidden = true;
//                                       context
//                                           .read<ManageProfileProvider>()
//                                           .notifyListeners();
//                                     }
//                                   },
//                                 ),
//                                 hintText: "Enter Your Password",
//                                 border: OutlineInputBorder(gapPadding: 1),
//                                 isDense: true,
//                                 enabledBorder:
//                                     OutlineInputBorder(gapPadding: 1),
//                                 focusedBorder:
//                                     OutlineInputBorder(gapPadding: 1),
//                               ),
//                             ),
//                             Gap(20.ss),
//                             Center(
//                               child: InkWell(
//                                   onTap: () {
//                                     if (verifyPasswordFormKey.currentState!
//                                         .validate()) {
//                                       verifyPasswordFormKey.currentState!
//                                           .save();
//                                     } else {}
//                                     if (verifyPasswordController
//                                             .text.isNotEmpty &&
//                                         newPhoneNoController.text.length ==
//                                             14) {
//                                       Provider.of<ManageProfileProvider>(
//                                               context,
//                                               listen: false)
//                                           .verifyPassword(
//                                               verifyPasswordController.text,
//                                               context);
//                                     } else {
//                                       print("Password not 10 digit long");
//                                     }
//                                     print(verifyPasswordController.text.length);
//                                   },
//                                   child: CustomButton(
//                                     title: "Verify Password",
//                                   )),
//                             ),
//                           ],
//                         )),
//                     // Gap(10.ss),
//                     // Visibility(
//                     //   visible: Provider.of<LoginProvider>(context, listen: true)
//                     //           .enableResend
//                     //       ? false
//                     //       : true,
//                     //   child: Row(
//                     //     mainAxisAlignment: MainAxisAlignment.center,
//                     //     children: [
//                     //       Container(
//                     //         alignment: Alignment.center,
//                     //         child: CommonText(
//                     //           text:
//                     //               "Resend otp after ${context.watch<LoginProvider>().secondsRemaining} seconds",
//                     //           textStyle: CustomTextStyle(
//                     //               color: AppColor.APP_BAR_COLOUR),
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     // Visibility(
//                     //   visible: Provider.of<LoginProvider>(context, listen: true)
//                     //       .enableResend,
//                     //   child: InkWell(
//                     //     onTap: () {
//                     //       provider.resendCode(context);
//                     //     },
//                     //     child: Container(
//                     //       alignment: Alignment.center,
//                     //       child: CommonText(
//                     //           text: "Resend",
//                     //           textStyle: CustomTextStyle(
//                     //               color: AppColor.APP_BAR_COLOUR,
//                     //               fontSize: 16.ss)),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 )),
//             Expanded(
//               flex: 1,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     height: size.height / 4.ss,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             fit: BoxFit.fitWidth,
//                             image: AssetImage(
//                                 "assets/images/login_bottom_background.png"))),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
