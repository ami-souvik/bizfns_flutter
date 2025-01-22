import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/auth/Login/provider/login_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizing/sizing.dart';
import 'package:provider/provider.dart';
import '../../../core/route/RouteConstants.dart';
import '../../../core/utils/Utils.dart';
import '../../../core/utils/alert_dialog.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/const.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/route_function.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/common_dropdown.dart';
import '../../../core/widgets/common_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode focusNode = new FocusNode();
  final GlobalKey<FormState> loginformKey = GlobalKey<FormState>();

  @override
  void initState() {
    Provider.of<LoginProvider>(context, listen: false)
        .InitialControllers(context);
    Provider.of<LoginProvider>(context, listen: false).DisposeControllers();
    Provider.of<LoginProvider>(context, listen: false).tenantIds.clear();

    //Provider.of<LoginProvider>(context, listen: false).sselectedBusiness = null;
  }

  @override
  void dispose() {
    // Provider.of<LoginProvider>(context,listen: false).passwordController.dispose();
    super.dispose();
  }

  shareBizfins() async {
    final result = await Share.shareWithResult(
        "Let's manage your business with Bizfins, it's fast and an useful tool to group your day to day schedule in one place and easier to manage, let's go with bizfins...\niOS: https://www.apple.com/in/app-store/\nAndroid: https://play.google.com/store/games?hl=en&gl=US");

    if (result.status == ShareResultStatus.success) {
      Utils().ShowSuccessSnackBar(context, 'Success',
          'Thank you for telling your friends about Bizfins');
      setState(() {});
    }
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // var controller = Get.put(LoginController());

    var controller = Provider.of<LoginProvider>(context, listen: false);

    return SafeArea(
      top: true,
      child: GestureDetector(
        onPanUpdate: (details) {
          // Get the current scroll position of the ListView.
          double scrollPosition = controller.listController.position.pixels;

          // Update the scroll position by the amount that the user has dragged their finger.
          scrollPosition -= details.delta.dy;

          // Set the new scroll position.
          if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
            // Keyboard is visible.`
            controller.listController.position..jumpTo(scrollPosition);
          } else {
            // Keyboard is not visible.
          }

          // setState(() {
          //
          // });
        },
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFFf4feff),
          body: context.watch<LoginProvider>().loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.APP_BAR_COLOUR,
                  ),
                )
              : Stack(
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
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: loginformKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kIsWeb
                                ? MediaQuery.of(context).size.width / 4
                                : 0.0),
                        child: ListView(
                          shrinkWrap: true,
                          // mainAxisSize: MainAxisSize.max,
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.ss),
                              child: ListView(
                                shrinkWrap: true,
                                controller: controller.listController,
                                physics: const ClampingScrollPhysics(),
                                children: [
                                  Gap(MediaQuery.of(context).size.height /
                                      40.ss),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0.ss),
                                    child: SizedBox(
                                      height: 90.ss,
                                      child: Center(
                                        child: Image.asset(
                                            "assets/images/logo.png"),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 20.ss,
                                  //   child: Center(
                                  //     child: Image.asset(
                                  //         "assets/images/bizfns_logo_main.png"),
                                  //   ),
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     Padding(
                                  //       padding: EdgeInsets.all(8.0.ss),
                                  //       child: SizedBox(
                                  //         height: 10.ss,
                                  //         child: Center(
                                  //           child: Image.asset(
                                  //               "assets/images/bizfns_logo_main.png"),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Gap(10.ss),
                                  CommonText(
                                    text: "Login",
                                    textStyle: CustomTextStyle(
                                        fontSize: 24.fss,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Gap(5.ss),
                                  CommonText(
                                      text: "Hello There! Welcome",
                                      textStyle: CustomTextStyle(
                                          fontSize: 14.fss,
                                          fontWeight: FontWeight.w500)),
                                  Gap(20.ss),
                                  /*  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0.ss),
                                    child: CommonText(
                                        text: "Business Id",
                                        textStyle: CustomTextStyle(
                                            fontSize: 14.fss,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  Gap(5.ss),
                                  CommonTextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: Provider.of<LoginProvider>(context,
                                              listen: false)
                                          .tenantIdController,
                                      onValidator: (value){
                                        if(value == null || value.isEmpty){
                                          return "Please enter business Id";
                                        }else if(value.length < 8){
                                          return "Please enter a valid business Id";
                                        }else return null;
                                      },
                                      fontTextStyle:
                                          CustomTextStyle(fontSize: 16.fss),
                                      decoration: InputDecoration(
                                        hintText: "Enter Business Id",
                                        border: OutlineInputBorder(gapPadding: 1),
                                        isDense: true,
                                        // isCollapsed: true,

                                        enabledBorder:
                                            OutlineInputBorder(gapPadding: 1),
                                        focusedBorder:
                                            OutlineInputBorder(gapPadding: 1),
                                      )),*/
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 8.0.ss, top: 0.ss),
                                    child: InkWell(
                                      onTap: () {
                                        // Navigate(context,forgot_password);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0.ss),
                                            child: CommonText(
                                                text: "User Id",
                                                textStyle: CustomTextStyle(
                                                    fontSize: 14.fss,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),

                                          //TODO: [Discussion] Forgot Business Id has to be deleted`

                                          /*InkWell(
                                            onTap: () {
                                              Navigate(
                                                  context, forgot_business_id);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.0.ss),
                                              child: CommonText(
                                                text: "Forgot Business Id?",
                                                textStyle: TextStyle(
                                                    fontSize: 12.fss,
                                                    fontWeight: FontWeight.w500,
                                                    // decoration: TextDecoration.underline,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),*/
                                        ],
                                      ),
                                    ),
                                  ),
                                  Gap(5.ss),
                                  Focus(
                                    child: CommonTextFormField(
                                      onChanged: (val) async {
                                        controller
                                            .changeDropDownOption(context);
                                        if (val != null) {
                                          // Check if val is a 10-digit numeric string
                                          if (_isNumeric(val) &&
                                              val.length == 10) {
                                            await controller
                                                .getBusinessId(context);
                                          }
                                        }
                                      },
                                      onSave: (val) async {

                                        if(_isNumeric(val!) &&
                                            val!.length == 10){
                                          await controller.getBusinessId(context);
                                        }
                                      },
                                      onValueChanged: (val) async {
                                        if (val != null) {
                                          // Check if val is a 10-digit numeric string
                                          if (_isNumeric(val) &&
                                              val.length == 10) {
                                            await controller
                                                .getBusinessId(context);
                                          }
                                        }
                                      },
                                      textInputAction: TextInputAction.next,
                                      controller: Provider.of<LoginProvider>(
                                              context,
                                              listen: false)
                                          .userIdController,
                                      onValidator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter user Id";
                                        } else {
                                          return null;
                                        }
                                      },
                                      fontTextStyle:
                                          CustomTextStyle(fontSize: 16.fss),
                                      decoration: const InputDecoration(
                                        hintText:
                                            "Registered email / mobile no",
                                        border:
                                            OutlineInputBorder(gapPadding: 1),
                                        isDense: true,
                                        enabledBorder:
                                            OutlineInputBorder(gapPadding: 1),
                                        focusedBorder:
                                            OutlineInputBorder(gapPadding: 1),
                                      ),
                                    ),
                                    onFocusChange: (hasFocus) async {
                                      if (!hasFocus &&
                                          controller.userIdController.text
                                              .isNotEmpty && controller.userIdController.text.length >= 10) {
                                        await controller.getBusinessId(context);
                                      }
                                    },
                                  ),
                                  Gap(5.ss),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0.ss),
                                    child: CommonText(
                                        text: "Business Name",
                                        textStyle: CustomTextStyle(
                                            fontSize: 14.fss,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  Gap(5.ss),
                                  CommonDropdown(
                                    options: context
                                        .watch<LoginProvider>()
                                        .businessNameDropdownOptions,
                                    selectedValue: context
                                        .watch<LoginProvider>()
                                        .selectedBusiness,
                                    onChange: (value) {
                                      context
                                          .read<LoginProvider>()
                                          .selectedBusiness = value;

                                      context
                                          .read<LoginProvider>()
                                          .changeBusinessDropDown(value);
                                      /*Provider.of<LoginProvider>(context,
                                              listen: false)
                                          .sselectedBusiness = null;
                                      Provider.of<LoginProvider>(context,
                                              listen: false)
                                          .sselectedBusiness = value.id; */

                                      print(
                                          "Dropdown value===>${value.dependentid}");
                                      if (context
                                              .read<LoginProvider>()
                                              .businessNameDropdownOptions
                                              .first
                                              .id ==
                                          -1) {
                                        context
                                            .read<LoginProvider>()
                                            .businessNameDropdownOptions
                                            .removeAt(0);
                                      }
                                      context
                                          .read<LoginProvider>()
                                          .notifyListeners();
                                    },
                                  ),
                                  Gap(10.ss),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0.ss),
                                        child: Row(
                                          children: [
                                            CommonText(
                                              text: "Password",
                                              textStyle: CustomTextStyle(
                                                  fontSize: 14.fss,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Gap(20.ss),
                                            InkWell(
                                                onTap: () {
                                                  ShowDialog(
                                                      context: context,
                                                      title: "Password rules",
                                                      msg:
                                                          PasswordRuleForDialog);
                                                },
                                                child: ImageIcon(
                                                  AssetImage(
                                                      'assets/images/information_button.png'),
                                                  size: 16,
                                                  color:
                                                      AppColor.APP_BAR_COLOUR,
                                                ))
                                          ],
                                        ),
                                      ),
                                      Gap(5.ss),
                                      CommonTextFormField(
                                          textInputAction: TextInputAction.done,
                                          controller:
                                              Provider.of<LoginProvider>(
                                                      context,
                                                      listen: false)
                                                  .passwordController,
                                          onValidator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter password";
                                            } else if (!Utils()
                                                .isValidPassword(value)) {
                                              return "Please enter a valid password";
                                            } else
                                              return null;
                                          },
                                          fontTextStyle:
                                              CustomTextStyle(fontSize: 16.fss),
                                          obscureText: context
                                              .watch<LoginProvider>()
                                              .isPasswordHidden,
                                          decoration: InputDecoration(
                                            hintText: "Enter Password",
                                            border: OutlineInputBorder(
                                                gapPadding: 1),
                                            // isCollapsed: true,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                  context
                                                          .watch<
                                                              LoginProvider>()
                                                          .isPasswordHidden
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: AppColor.BUTTON_COLOR,
                                                  size: 24),
                                              onPressed: () {
                                                if (context
                                                    .read<LoginProvider>()
                                                    .isPasswordHidden) {
                                                  context
                                                      .read<LoginProvider>()
                                                      .isPasswordHidden = false;
                                                  context
                                                      .read<LoginProvider>()
                                                      .notifyListeners();
                                                } else {
                                                  context
                                                      .read<LoginProvider>()
                                                      .isPasswordHidden = true;
                                                  context
                                                      .read<LoginProvider>()
                                                      .notifyListeners();
                                                }
                                              },
                                            ),
                                            isDense: true,
                                            //
                                            enabledBorder: OutlineInputBorder(
                                                gapPadding: 1),
                                            focusedBorder: OutlineInputBorder(
                                                gapPadding: 1),
                                          ))
                                    ],
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.symmetric(
                                  //       horizontal: 10.0.ss),
                                  //   child: Row(
                                  //     children: [
                                  //       CommonText(
                                  //         text: "Password",
                                  //         textStyle: CustomTextStyle(
                                  //             fontSize: 14.fss,
                                  //             fontWeight: FontWeight.w700),
                                  //       ),
                                  //       Gap(20.ss),
                                  //       InkWell(
                                  //           onTap: () {
                                  //             ShowDialog(
                                  //                 context: context,
                                  //                 title: "Password rules",
                                  //                 msg: PasswordRuleForDialog);
                                  //           },
                                  //           child: ImageIcon(
                                  //             AssetImage(
                                  //                 'assets/images/information_button.png'),
                                  //             size: 16,
                                  //             color: AppColor.APP_BAR_COLOUR,
                                  //           ))
                                  //     ],
                                  //   ),
                                  // ),
                                  // Gap(5.ss),
                                  // CommonTextFormField(
                                  //     textInputAction: TextInputAction.done,
                                  //     controller: Provider.of<LoginProvider>(
                                  //             context,
                                  //             listen: false)
                                  //         .passwordController,
                                  //     onValidator: (value) {
                                  //       if (value == null || value.isEmpty) {
                                  //         return "Please enter password";
                                  //       } else if (!Utils()
                                  //           .isValidPassword(value)) {
                                  //         return "Please enter a valid password";
                                  //       } else
                                  //         return null;
                                  //     },
                                  //     fontTextStyle:
                                  //         CustomTextStyle(fontSize: 16.fss),
                                  //     obscureText: context
                                  //         .watch<LoginProvider>()
                                  //         .isPasswordHidden,
                                  //     decoration: InputDecoration(
                                  //       hintText: "Enter Password",
                                  //       border:
                                  //           OutlineInputBorder(gapPadding: 1),
                                  //       // isCollapsed: true,
                                  //       suffixIcon: IconButton(
                                  //         icon: Icon(
                                  //             context
                                  //                     .watch<LoginProvider>()
                                  //                     .isPasswordHidden
                                  //                 ? Icons.visibility_off
                                  //                 : Icons.visibility,
                                  //             color: AppColor.BUTTON_COLOR,
                                  //             size: 24),
                                  //         onPressed: () {
                                  //           if (context
                                  //               .read<LoginProvider>()
                                  //               .isPasswordHidden) {
                                  //             context
                                  //                 .read<LoginProvider>()
                                  //                 .isPasswordHidden = false;
                                  //             context
                                  //                 .read<LoginProvider>()
                                  //                 .notifyListeners();
                                  //           } else {
                                  //             context
                                  //                 .read<LoginProvider>()
                                  //                 .isPasswordHidden = true;
                                  //             context
                                  //                 .read<LoginProvider>()
                                  //                 .notifyListeners();
                                  //           }
                                  //         },
                                  //       ),
                                  //       isDense: true,
                                  //       //
                                  //       enabledBorder:
                                  //           OutlineInputBorder(gapPadding: 1),
                                  //       focusedBorder:
                                  //           OutlineInputBorder(gapPadding: 1),
                                  //     )),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.ss),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // 6
                                        Visibility(
                                          // ignore: unrelated_type_equality_checks
                                          visible: Provider.of<LoginProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedBusiness
                                                  .id !=
                                              "-1",
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0.ss),
                                            child: InkWell(
                                              onTap: () {
                                                Navigate(
                                                    context, forgot_password);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.ss,
                                                    horizontal: 2.0.ss),
                                                child: CommonText(
                                                  text: "Forgot Password?",
                                                  textStyle: TextStyle(
                                                      fontSize: 12.fss,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      // decoration: TextDecoration.underline,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Visibility(
                                        //   visible: Provider.of<LoginProvider>(
                                        //           context,
                                        //           listen: false)
                                        //       .tenantIds
                                        //       .contains(
                                        //           Provider.of<LoginProvider>(
                                        //                   context,
                                        //                   listen: false)
                                        //               .selectedBusiness
                                        //               .dependentid),
                                        //   child: Padding(
                                        //     padding:
                                        //         EdgeInsets.only(right: 8.0.ss),
                                        //     child: InkWell(
                                        //       onTap: () {
                                        //         Navigate(context, staff_login);
                                        //       },
                                        //       child: Padding(
                                        //         padding: EdgeInsets.symmetric(
                                        //             vertical: 0.ss,
                                        //             horizontal: 2.0.ss),
                                        //         child: CommonText(
                                        //           text:
                                        //               "Set Password For Stuff?",
                                        //           textStyle: TextStyle(
                                        //               fontSize: 12.fss,
                                        //               fontWeight:
                                        //                   FontWeight.w500,
                                        //               // decoration: TextDecoration.underline,
                                        //               color: Colors.black),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Gap(10.ss),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0.0.ss),
                                    child: InkWell(
                                        onTap: () {
                                          // Fluttertoast.showToast(msg: "Clicked");
                                          //showMyDialog(context);
                                          //  context.go(Routes.VERIFY_OTP, arguments: {'phno': "9064818788"});
                                          // if (Provider.of<LoginProvider>(
                                          //             context,
                                          //             listen: false)
                                          //         .isPasswordFieldVisibleInLogin ==
                                          //     true) {
                                          if (loginformKey.currentState!
                                              .validate()) {
                                            loginformKey.currentState!.save();
                                          } else {}
                                          controller.validation(context);
                                          // } else {
                                          //   Navigate(context, staff_login);
                                          // }

                                          // context.go(Routes.VERIFY_OTP);
                                        },
                                        child:
                                            //  CustomButton(
                                            //     title: Provider.of<LoginProvider>(
                                            //                     context,
                                            //                     listen: false)
                                            //                 .isPasswordFieldVisibleInLogin ==
                                            //             true
                                            //         ? "Login"
                                            //         : "Set Password")
                                            CustomButton(title: "Login")),
                                  ),
                                  Gap(10.ss),
                                  Center(
                                    child: Text.rich(TextSpan(
                                        text: "New here ?",
                                        style: TextStyle(fontSize: 16),
                                        children: <InlineSpan>[
                                          TextSpan(
                                              text:
                                                  ' Register only as a Business Owner',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () =>
                                                    {Navigate(context, signup)})
                                        ])),
                                  ),
                                  Gap(10.ss),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 8.0.ss),
                                        child: InkWell(
                                          onTap: () async {
                                            await shareBizfins();
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0.ss,
                                                horizontal: 2.0.ss),
                                            child: CommonText(
                                              text: "Refer Bizfns to a friend",
                                              textStyle: TextStyle(
                                                  fontSize: 12.fss,
                                                  fontWeight: FontWeight.w300,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).viewInsets.bottom,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
//)
        ),
      ),
    );
  }
}
