import 'package:bizfns/core/utils/Utils.dart';
import 'package:bizfns/core/utils/fonts.dart';
import 'package:bizfns/features/auth/Signup/provider/signup_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';
import '../../../core/model/dropdown_model.dart';
import '../../../core/route/RouteConstants.dart';
import '../../../core/utils/alert_dialog.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/const.dart';
import '../../../core/widgets/common_button.dart';
import '../../../core/widgets/common_dropdown.dart';
import '../../../core/widgets/common_text.dart';
import '../../../core/widgets/common_text_form_field.dart';
import '../../../core/widgets/registration_plan_card.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    context.read<SignupProvider>().loading = true;
    context.read<SignupProvider>().LoadData(context);
    context.read<SignupProvider>().InitialControllers();
    context.read<SignupProvider>().DisposeControllers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: context.watch<SignupProvider>().loading
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator(), Text("Loading...")],
                ),
              )
            : Container(
                child: Stack(
                  children: [
                    Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.height / 3.7
                            : MediaQuery.of(context).size.width / 3.7,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFF0B4A6B), Color(0xFF278EB8)]),
                        )),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: kIsWeb
                              ? MediaQuery.of(context).size.width / 4
                              : 10.0.ss,
                          vertical: 10.ss),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(MediaQuery.of(context).size.height / 24),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0.ss),
                            child: SizedBox(
                              height: 80.ss,
                              child: Center(
                                child: Image.asset(
                                  "assets/images/logo.png",
                                  color: Colors.white,
                                ),
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
                          // Center(
                          //   child: Text(
                          //     "Simple Services",
                          //     style: TextStyle(
                          //         fontSize: 16.fss,
                          //         fontFamily: "Roboto",
                          //         color: Colors.white),
                          //   ),
                          // ),
                          Gap(10.ss),
                          Text(
                            "Register",
                            style: CustomTextStyle(
                                fontSize: 20.fss,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          Gap(10.ss),
                          context.watch<SignupProvider>().planList.isNotEmpty
                              ? SizedBox(
                                  height: MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? MediaQuery.of(context).size.height / 4.5
                                      : MediaQuery.of(context).size.width / 4.5,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: context
                                          .watch<SignupProvider>()
                                          .planList
                                          .length,
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          RegistrationPlanCard(
                                              index,
                                              index ==
                                                      context
                                                          .watch<
                                                              SignupProvider>()
                                                          .selectedPlan
                                                  ? true
                                                  : false,
                                              context
                                                  .watch<SignupProvider>()
                                                  .planList
                                                  .elementAt(index), () {
                                            print(index);
                                            // context.watch<SignupProvider>().selectedPlan = index;
                                            Provider.of<SignupProvider>(context,
                                                    listen: false)
                                                .selectedPlan = index;
                                            setState(() {});
                                          })),
                                )
                              : Offstage(),
                          SizedBox(
                            height: 10.ss,
                          ),
                          Form(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: Provider.of<SignupProvider>(context,
                                    listen: false)
                                .formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.ss),
                                  child: CommonText(text: "Business Name *"),
                                ),
                                SizedBox(
                                  height: 5.ss,
                                ),
                                CommonTextFormField(
                                  onValidator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter business name";
                                    } else if (value.trim().length < 4) {
                                      return "Business name should have minimum 4 characters";
                                    } else
                                      return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  controller: Provider.of<SignupProvider>(
                                          context,
                                          listen: false)
                                      .businessNameController,
                                  hintText: "Business Name",
                                  fontTextStyle:
                                      CustomTextStyle(fontSize: 16.fss),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Business Name",
                                    border: OutlineInputBorder(gapPadding: 1),
                                    enabledBorder:
                                        OutlineInputBorder(gapPadding: 1),
                                    focusedBorder:
                                        OutlineInputBorder(gapPadding: 1),
                                  ),
                                  onSave: (value) {},
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.ss),
                                  child: SizedBox(
                                    height: 20.ss,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.ss),
                                  child: Row(
                                    children: [
                                      CommonText(text: "Business Category *"),
                                      Gap(20.ss),
                                      InkWell(
                                          onTap: () {
                                            ShowDialog(
                                                context: context,
                                                title: "Business Category",
                                                msg: WhatBusinessCategoryIs);
                                          },
                                          child: ImageIcon(
                                            AssetImage(
                                                'assets/images/information_button.png'),
                                            size: 18,
                                            color: AppColor.APP_BAR_COLOUR,
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5.ss,
                                ),
                                CommonDropdown(
                                  isInfoVisible: true,
                                  options: context
                                      .watch<SignupProvider>()
                                      .businessCategory,
                                  selectedValue: context
                                      .watch<SignupProvider>()
                                      .selectedBusinessCategory,
                                  onChange: (val) {
                                    context
                                        .read<SignupProvider>()
                                        .selectedBusinessCategory = val;
                                    if (context
                                            .read<SignupProvider>()
                                            .businessCategory
                                            .first
                                            .id ==
                                        -1) {
                                      context
                                          .read<SignupProvider>()
                                          .businessCategory
                                          .removeAt(0);
                                      context
                                          .read<SignupProvider>()
                                          .notifyListeners();
                                    }
                                    context
                                        .read<SignupProvider>()
                                        .businessTypes
                                        .clear();
                                    context
                                        .read<SignupProvider>()
                                        .businessTypes
                                        .add(DropdownModel(
                                            id: "-1",
                                            dependentid: "-1",
                                            name: val.id == "-1"
                                                ? "Select Business Category First"
                                                : "Select One"));
                                    context
                                            .read<SignupProvider>()
                                            .selectedBusinessType =
                                        context
                                            .read<SignupProvider>()
                                            .businessTypes
                                            .first;
                                    if (val.id != -1) {
                                      for (int i = 0;
                                          i <
                                              context
                                                  .read<SignupProvider>()
                                                  .allBusinessCategory
                                                  .length;
                                          i++) {
                                        var cat = context
                                            .read<SignupProvider>()
                                            .allBusinessCategory[i];

                                        if (cat.pKCATEGORYID.toString() ==
                                            val.id.toString()) {
                                          Utils().printMessage("ID==>>>" +
                                              cat.pKCATEGORYID.toString() +
                                              "  ," +
                                              val.id.toString());
                                          setState(() {
                                            context
                                                .read<SignupProvider>()
                                                .businessTypes
                                                .add(DropdownModel(
                                                    dependentid: cat
                                                        .pKCATEGORYID
                                                        .toString(),
                                                    name:
                                                        cat.bUSINESSTYPEENTITY,
                                                    id: cat.pKBUSINESSTYPEID
                                                        .toString()));
                                          });
                                        }
                                      }
                                    }
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: 20.ss,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.ss),
                                  child: Row(
                                    children: [
                                      CommonText(text: "Business Type *"),
                                      Gap(20.ss),
                                      InkWell(
                                          onTap: () {
                                            ShowDialog(
                                                context: context,
                                                title: "Business Type",
                                                msg: WhatBusinessTypeIs);
                                          },
                                          child: ImageIcon(
                                            AssetImage(
                                                'assets/images/information_button.png'),
                                            size: 18,
                                            color: AppColor.APP_BAR_COLOUR,
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5.ss,
                                ),
                                CommonDropdown(
                                  options: context
                                      .watch<SignupProvider>()
                                      .businessTypes,
                                  selectedValue: context
                                      .watch<SignupProvider>()
                                      .selectedBusinessType,
                                  onChange: (value) {
                                    context
                                        .read<SignupProvider>()
                                        .selectedBusinessType = value;
                                    if (context
                                            .read<SignupProvider>()
                                            .businessTypes
                                            .first
                                            .id ==
                                        -1) {
                                      context
                                          .read<SignupProvider>()
                                          .businessTypes
                                          .removeAt(0);
                                    }
                                    context
                                        .read<SignupProvider>()
                                        .notifyListeners();
                                  },
                                ),
                                // CommonDropdown(selectedValue: "Business Category", options: context.watch<SignupProvider>().planList,
                                //     borderRadius:5.0,
                                //     borderColor:Colors.black87,onChange: (val){}),
                                SizedBox(
                                  height: 20.ss,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.ss),
                                  child: CommonText(text: "Mobile Number *"),
                                ),
                                SizedBox(
                                  height: 5.ss,
                                ),
                                Focus(
                                  onFocusChange: (val) {
                                    print('Focus Change: $val');

                                    if (!val) {
                                      if (Provider.of<SignupProvider>(context,
                                                  listen: false)
                                              .phoneController
                                              .text
                                              .length ==
                                          14) {
                                        // await controller.getBusinessId(context);
                                        Provider.of<SignupProvider>(context,
                                                listen: false)
                                            .phoneNoRegCheck(context);
                                      }
                                    }
                                  },
                                  child: CommonTextFormField(
                                    /*onChanged: (val) async {
                                      if (val != null) {
                                        // Check if val is a 10-digit numeric string
                                        if (Provider.of<SignupProvider>(
                                            context,
                                            listen: false)
                                            .phoneController.text.length == 14) {
                                          // await controller.getBusinessId(context);
                                          Provider.of<SignupProvider>(context,
                                                  listen: false)
                                              .phoneNoRegCheck(context);
                                        }
                                      }
                                    },*/
                                    onValidator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return "Please enter 10 digit mobile no";
                                      } else if (value != null &&
                                          !value.isEmpty &&
                                          value.length < 14) {
                                        return "Please enter 10 digit mobile no";
                                      } else
                                        return null;
                                    },
                                    onTap: () {
                                      Provider.of<SignupProvider>(context,
                                              listen: false)
                                          .validationLevelOne(context);
                                    },
                                    textInputAction: TextInputAction.next,
                                    textInputType: TextInputType.number,
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                          mask: '(###) ###-####',
                                          filter: {"#": RegExp(r'[0-9]')},
                                          type: MaskAutoCompletionType.lazy),
                                    ],
                                    controller: Provider.of<SignupProvider>(
                                            context,
                                            listen: false)
                                        .phoneController,
                                    fontTextStyle:
                                        CustomTextStyle(fontSize: 16.fss),
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
                                ),
                                SizedBox(
                                  height: 20.ss,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.ss),
                                  child: CommonText(text: "Business Email "),
                                ),
                                SizedBox(
                                  height: 5.ss,
                                ),
                                CommonTextFormField(
                                    textInputAction: TextInputAction.next,
                                    textInputType: TextInputType.emailAddress,
                                    controller: Provider.of<SignupProvider>(
                                            context,
                                            listen: false)
                                        .emailController,
                                    onValidator: (value) {
                                      if (value != null &&
                                          !value.isEmpty &&
                                          value.isNotEmpty &&
                                          !Utils.IsValidEmail(value)) {
                                        return "Please enter a valid email id";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () {
                                      Provider.of<SignupProvider>(context,
                                              listen: false)
                                          .ValidationLevelTwo(context);
                                    },
                                    fontTextStyle:
                                        CustomTextStyle(fontSize: 16.fss),
                                    decoration: const InputDecoration(
                                      hintText: "Enter valid Email Id",
                                      border: OutlineInputBorder(gapPadding: 1),
                                      isDense: true,
                                      // isCollapsed: true,
                                      enabledBorder:
                                          OutlineInputBorder(gapPadding: 1),
                                      focusedBorder:
                                          OutlineInputBorder(gapPadding: 1),
                                    )),
                                SizedBox(
                                  height: 20.ss,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.ss),
                                  child: CommonText(text: "Password *"),
                                ),
                                SizedBox(
                                  height: 5.ss,
                                ),
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
                                  onTap: () {
                                    Provider.of<SignupProvider>(context,
                                            listen: false)
                                        .ValidationLevelThree(context);
                                  },
                                  textInputAction: TextInputAction.next,
                                  controller: Provider.of<SignupProvider>(
                                          context,
                                          listen: false)
                                      .passwordController,
                                  obscureText: context
                                      .watch<SignupProvider>()
                                      .isPasswordVisible,
                                  fontTextStyle:
                                      CustomTextStyle(fontSize: 16.fss),
                                  decoration: InputDecoration(
                                    hintText: "Create Password",
                                    border: OutlineInputBorder(gapPadding: 1),
                                    isDense: true,
                                    // isCollapsed: true,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                          context
                                                  .watch<SignupProvider>()
                                                  .isPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColor.BUTTON_COLOR,
                                          size: 24),
                                      onPressed: () {
                                        if (context
                                            .read<SignupProvider>()
                                            .isPasswordVisible) {
                                          context
                                              .read<SignupProvider>()
                                              .isPasswordVisible = false;
                                          context
                                              .read<SignupProvider>()
                                              .notifyListeners();
                                        } else {
                                          context
                                              .read<SignupProvider>()
                                              .isPasswordVisible = true;
                                          context
                                              .read<SignupProvider>()
                                              .notifyListeners();
                                        }
                                      },
                                    ),
                                    enabledBorder:
                                        OutlineInputBorder(gapPadding: 1),
                                    focusedBorder:
                                        OutlineInputBorder(gapPadding: 1),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.ss),
                                  child: CommonText(
                                      text: PasswordRule,
                                      textStyle: CustomTextStyle(
                                          fontSize: 10.fss,
                                          color: AppColor.GERY)),
                                ),
                                SizedBox(
                                  height: 20.ss,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.ss),
                                  child: CommonText(text: "Confirm Password *"),
                                ),
                                SizedBox(
                                  height: 5.ss,
                                ),
                                CommonTextFormField(
                                    onValidator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter password you have set";
                                      } else if (value !=
                                          context
                                              .read<SignupProvider>()
                                              .passwordController
                                              .text) {
                                        return "Password and confirm password should be same";
                                      } else
                                        return null;
                                    },
                                    onTap: () {
                                      Provider.of<SignupProvider>(context,
                                              listen: false)
                                          .ValidationLevelFour(context);
                                    },
                                    textInputAction: TextInputAction.next,
                                    controller: Provider.of<SignupProvider>(
                                            context,
                                            listen: false)
                                        .confirmPasswordController,
                                    obscureText: context
                                        .watch<SignupProvider>()
                                        .isConfirmPasswordHidden,
                                    fontTextStyle:
                                        CustomTextStyle(fontSize: 16.fss),
                                    decoration: InputDecoration(
                                      hintText: "Confirm Password",
                                      border: OutlineInputBorder(gapPadding: 1),
                                      // isDense: false,
                                      // isCollapsed: true,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            context
                                                    .watch<SignupProvider>()
                                                    .isConfirmPasswordHidden
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: AppColor.BUTTON_COLOR,
                                            size: 24),
                                        onPressed: () {
                                          if (context
                                              .read<SignupProvider>()
                                              .isConfirmPasswordHidden) {
                                            context
                                                    .read<SignupProvider>()
                                                    .isConfirmPasswordHidden =
                                                false;
                                            context
                                                .read<SignupProvider>()
                                                .notifyListeners();
                                          } else {
                                            context
                                                .read<SignupProvider>()
                                                .isConfirmPasswordHidden = true;
                                            context
                                                .read<SignupProvider>()
                                                .notifyListeners();
                                          }
                                        },
                                      ),
                                      isDense: true,
                                      enabledBorder:
                                          OutlineInputBorder(gapPadding: 1),
                                      focusedBorder:
                                          OutlineInputBorder(gapPadding: 1),
                                    )),
                                Row(
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.black,
                                      activeColor: Colors.black26,
                                      hoverColor: Colors.red,
                                      value: context
                                          .watch<SignupProvider>()
                                          .isChecked,
                                      onChanged: (value) {
                                        context
                                            .read<SignupProvider>()
                                            .ChangeCheck(value ?? true);
                                      },
                                    ),
                                    SizedBox(
                                      width: 10.ss,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Utils().printMessage("TAPP========");
                                        ShowDialog(
                                            isFullScreen: true,
                                            context: context,
                                            title: "Terms & Conditions",
                                            msg: context
                                                .read<SignupProvider>()
                                                .TermsAndCondition,
                                            okTap: () {
                                              context
                                                  .read<SignupProvider>()
                                                  .isChecked = true;
                                              context
                                                  .read<SignupProvider>()
                                                  .notifyListeners();
                                            },
                                            okButtonName: "Accept");
                                      },
                                      child: CommonText(
                                          text:
                                              "Agree to BIZFNS Terms & Conditions",
                                          textStyle: CustomTextStyle(
                                            color: AppColor.APP_BAR_COLOUR,
                                            decoration:
                                                TextDecoration.underline,
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: context.watch<SignupProvider>().isChecked
                                ? CommonButton(
                                    solidColor: AppColor.BUTTON_COLOR,
                                    label: "REGISTER",
                                    buttonHeight: 60,
                                    buttonWidth: kIsWeb
                                        ? MediaQuery.of(context).size.width /
                                            3.ss
                                        : MediaQuery.of(context).size.width -
                                            30.ss,
                                    onClicked: () {
                                      Provider.of<SignupProvider>(context,
                                              listen: false)
                                          .validition(context);
                                    },
                                  )
                                : CommonButton(
                                    solidColor: Colors.grey,
                                    label: "REGISTER",
                                    buttonHeight: 50,
                                    buttonWidth: kIsWeb
                                        ? MediaQuery.of(context).size.width /
                                            3.ss
                                        : MediaQuery.of(context).size.width -
                                            30.ss,
                                  ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0.ss),
                              child: Text.rich(TextSpan(
                                  text: "Already Registered?",
                                  children: <InlineSpan>[
                                    TextSpan(
                                        text: "  Login",
                                        style: CustomTextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w800),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            GoRouter.of(context).go(login);
                                          }),
                                  ])),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    ));
  }
}
