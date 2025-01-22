import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bizfns/core/utils/fonts.dart';
import 'package:bizfns/core/utils/route_function.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/ManageProfile/provider/manage_profile_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

// import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:gap/gap.dart';
import '../../../core/widgets/common_button.dart';
import '../../../core/utils/colour_constants.dart';
import '../../core/route/RouteConstants.dart';
import '../../core/shared_pref/shared_pref.dart';
import '../../core/utils/Utils.dart';
import '../../core/utils/api_constants.dart';
import '../../core/utils/bizfns_layout_widget.dart';
import '../../core/utils/image_controller.dart';
import '../../core/widgets/AddModifyScheduleCustomField/custom_field.dart';
import '../auth/Login/model/login_otp_verification_model.dart';
import 'common/custom_details_fields_others.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isAdmin = true;
  OtpVerificationData? data;
  double subContainerHeight = 50.ss;
  Color subContainerColor = const Color(0xFFeaeaea);
  double allArrowIconSize = 40;
  // bool isTextFieldEnabled = false;
  String getAppBarTitle(BuildContext context) {
    String routePath =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

    print(routePath);

    ///todo: has be to split by / and remove the last element
    ///todo: then get the last element of the current list
    ///
    ///
    List<String> items = routePath.split('/');
    items.removeLast();

    return getTitle(items.last);
  }

  String getTitle(String key) {
    Map<String, String> titleMap = {
      'admin': 'Admin',
    };

    return titleMap[key] ?? '';
  }

  TextStyle allContainerStyle = TextStyle(color: Colors.black, fontSize: 14);

  @override
  void initState() {
    print("This is our account page");
    getUserData();
    Provider.of<ManageProfileProvider>(context, listen: false)
        .getCompanyDetails();
    Provider.of<ManageProfileProvider>(context, listen: false).getProfile();
    super.initState();
  }

  pickProfileImage() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () async {
              await Provider.of<ManageProfileProvider>(context, listen: false)
                  .pickProfileImageFromCamera();
              setState(() {});
              GoRouter.of(context).pop();
            },
            child: const Text('Open Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              await Provider.of<ManageProfileProvider>(context, listen: false)
                  .pickProfileImageFromGallery();
              setState(() {});
              GoRouter.of(context).pop();
            },
            child: const Text('Select from gallery'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as delete or exit and turns
          /// the action's text color to red.
          isDestructiveAction: true,
          onPressed: () {
            GoRouter.of(context).pop();
            // Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, String label,
      TextEditingController controller, TextInputType inputType) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                keyboardType: inputType,
                controller: controller,
                // initialValue: 'panjasoumyadip',
                decoration: InputDecoration(
                  labelText: 'Enter your $label',
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<ManageProfileProvider>(context, listen: false)
                          .setProfileData();
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // @override
  // void dispose() {
  //   Provider.of<ManageProfileProvider>(context, listen: false)
  //       .disposeController();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //  popUpFunc() {
        String appBarTitle = getAppBarTitle(context);

        Provider.of<TitleProvider>(context, listen: false).changeTitle('');

        // try {
        //   print('In Dashboard App Bar');

        //   GoRouter.of(context).pop();
        // } catch (ex) {
        //   print("exception======>$ex");
        //   // popBranch();
        // }
        // }
        return true;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   leading: InkWell(
        //     onTap: (){
        //       GoRouter.of(context).pop();
        //     },
        //     child: Icon(Icons.arrow_back),
        //   ),
        //   title: CommonText(text: "Profile"),
        //   backgroundColor: AppColor.BUTTON_COLOR,
        //   actions: [
        //     InkWell(
        //       child: const Center(
        //         child: Text('Log out  ',style: TextStyle(
        //           fontSize: 16,
        //         ),),
        //       ),
        //       onTap: () {
        //         AwesomeDialog(
        //           context: context,
        //           animType: AnimType.leftSlide,
        //           headerAnimationLoop: false,
        //           dialogType: DialogType.infoReverse,
        //           width: kIsWeb
        //               ? MediaQuery.of(context).size.width * 0.4
        //               : MediaQuery.of(context).size.width,
        //           // showCloseIcon: true,
        //           title: 'Warning',
        //           desc: "Are you sure you want to logout ?",

        //           // desc: 'Dialog description here..................................................',
        //           btnOkOnPress: () async {
        //             // Utils().printMessage('OnClick');
        //             await GlobalHandler.setLogedIn(false);
        //             await GlobalHandler.setSequrityQuestionAnswered(
        //                 false);
        //             await GlobalHandler.setLoginData(null);
        //             Future.delayed(
        //               const Duration(milliseconds: 200),
        //                   () => context.go(login),
        //             );
        //           },
        //           btnCancelOnPress: () {},
        //           btnOkIcon: Icons.check_circle,
        //           onDismissCallback: (type) {
        //             Utils().printMessage(
        //                 'Dialog Dismiss from callback $type');
        //           },
        //         ).show();
        //       },
        //     ),
        //   ],
        // ),
        body: Container(
          height: kIsWeb
              ? MediaQuery.of(context).size.height * 0.90.ss
              : MediaQuery.of(context).size.height * 0.90.ss,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.withOpacity(0.05),
          child: Column(
            children: [
              Gap(20.0.ss),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Provider.of<ManageProfileProvider>(context, listen: false)
                            .imageName
                            .isEmpty
                        ? Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 70.ss,
                                  child: Image.asset(
                                    'assets/images/user.png',
                                    width: 60.ss,
                                    height: 80.ss,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: InkWell(
                                      onTap: () {
                                        pickProfileImage();
                                      },
                                      child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor:
                                              AppColor.APP_BAR_COLOUR,
                                          child: Icon(
                                            Icons.camera_alt_rounded,
                                            size: 18,
                                            color: Colors.white,
                                          )),
                                    ))
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(
                                            context); // Close the dialog when tapped
                                      },
                                      child: Image.network(
                                        '${Urls.MEDIA_URL}${Provider.of<ManageProfileProvider>(context, listen: false).imageName}',
                                        fit: BoxFit
                                            .contain, // Fit the image within the dialog
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Center(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 70.ss,
                                    backgroundImage: NetworkImage(
                                        '${Urls.MEDIA_URL}${Provider.of<ManageProfileProvider>(context, listen: false).imageName}'),
                                    // backgroundColor: Colors.transparent,
                                  ),
                                  Positioned(
                                      right: 10,
                                      bottom: 10,
                                      child: InkWell(
                                        onTap: () {
                                          pickProfileImage();
                                        },
                                        child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                AppColor.APP_BAR_COLOUR,
                                            child: Icon(
                                              Icons.camera_alt_rounded,
                                              size: 18,
                                              color: Colors.white,
                                            )),
                                      ))
                                ],
                              ),
                            ),
                          ),
                    Column(
                      children: [
                        profileCommonCards(
                          allContainerStyle: allContainerStyle,
                          allArrowIconSize: allArrowIconSize,
                          descriptionText: 'Business Name',
                        ),
                        InkWell(
                          onTap: () {
                            _showModalBottomSheet(
                                context,
                                'Business Name.',
                                Provider.of<ManageProfileProvider>(context,
                                        listen: false)
                                    .businessNameController,
                                TextInputType.text);
                          },
                          child: CustomDetailsFieldForOthers(
                            data:
                                '${Provider.of<ManageProfileProvider>(context, listen: false).businessNameController.text}',
                            isEditable: true,
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileCommonCards(
                          allContainerStyle: allContainerStyle,
                          allArrowIconSize: allArrowIconSize,
                          descriptionText: 'Business Type',
                        ),
                        CustomDetailsFieldForOthers(
                          data:
                              '${Provider.of<ManageProfileProvider>(context, listen: false).businessType}',
                          isEditable: false,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        profileCommonCards(
                          allContainerStyle: allContainerStyle,
                          allArrowIconSize: allArrowIconSize,
                          descriptionText: ' Business Contact Person',
                        ),
                        // SizedBox(
                        //   height: 80.ss,
                        //   child: Padding(
                        //     padding:
                        //         EdgeInsets.fromLTRB(20.ss, 10.ss, 20.ss, 0),
                        //     child: InkWell(
                        //       onTap: () {
                        //         print("Business Contact Person calling");
                        //         Provider.of<ManageProfileProvider>(context,
                        //                 listen: false)
                        //             .changeBusinessContactPersonVisibility();
                        //       },
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //           shape: BoxShape.rectangle,
                        //           borderRadius: BorderRadius.circular(5.0.ss),
                        //           border: Border.all(
                        //             color: Colors.white,
                        //             width: 1.0.ss,
                        //           ),
                        //           color: Colors.white,
                        //         ),
                        //         padding: EdgeInsets.all(10.0.ss),
                        //         child: Row(
                        //           children: [
                        //             CircleAvatar(
                        //               backgroundColor: Colors.grey[200],
                        //               radius: 20, // Adjust the radius as needed
                        //               child: Image.asset(
                        //                 'assets/images/four-squares-button.png',
                        //                 width: 20.ss,
                        //                 height: 20.ss,
                        //                 fit: BoxFit.cover,
                        //               ),
                        //             ),
                        //             SizedBox(width: 8.ss),
                        //             CommonText(
                        //               text: '  Business Contact Person',
                        //               textStyle: CustomTextStyle(
                        //                 fontSize: 15.fss,
                        //                 fontWeight: FontWeight.w700,
                        //                 color: Colors.black,
                        //               ),
                        //             ),
                        //             // Spacer(),
                        //             // Icon(
                        //             //   Provider.of<ManageProfileProvider>(
                        //             //             context,
                        //             //           ).isBusinessContactPersonVisible ==
                        //             //           false
                        //             //       ? Icons.keyboard_arrow_right
                        //             //       : Icons.keyboard_arrow_down,
                        //             //   size: 40,
                        //             // ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            _showModalBottomSheet(
                                context,
                                'Business Contact Person.',
                                Provider.of<ManageProfileProvider>(context,
                                        listen: false)
                                    .businessContactPersonController,
                                TextInputType.text);
                          },
                          child: Provider.of<ManageProfileProvider>(
                            context,
                          ).businessContactPersonController.text.isNotEmpty
                              ? CustomDetailsFieldForOthers(
                                  data: Provider.of<ManageProfileProvider>(
                                    context,
                                  ).businessContactPersonController.text,
                                  isEditable: true,
                                )
                              : CustomDetailsFieldForOthers(
                                  data: "add business contact person",
                                  isEditable: true,
                                  secondaryColor: Colors.grey,
                                ),
                        ),
                        // Visibility(
                        //   visible: Provider.of<ManageProfileProvider>(
                        //         context,
                        //       ).isBusinessContactPersonVisible ==
                        //       true,
                        //   child: Padding(
                        //     padding: EdgeInsets.fromLTRB(20.ss, 0, 20.ss, 0),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: Container(
                        //             height: subContainerHeight,
                        //             decoration: BoxDecoration(
                        //               color: subContainerColor,
                        //               // border: Border.all(
                        //               //   color: Colors.grey,
                        //               //   width: 1.0,
                        //               // ),
                        //               borderRadius: BorderRadius.only(
                        //                   bottomLeft: Radius.circular(5),
                        //                   bottomRight: Radius.circular(5)),
                        //             ),
                        //             child: Row(
                        //               children: [
                        //                 Expanded(
                        //                   child: TextField(
                        //                     style: CustomTextStyle(
                        //                       fontSize: 15.fss,
                        //                       fontWeight: FontWeight.w700,
                        //                       color: Colors.black,
                        //                     ),
                        //                     controller: Provider.of<
                        //                         ManageProfileProvider>(
                        //                       context,
                        //                     ).businessContactPersonController,
                        //                     enabled: Provider.of<
                        //                             ManageProfileProvider>(
                        //                           context,
                        //                         ).isBusinessContactPersonTextFieldEditable ==
                        //                         true,
                        //                     decoration: InputDecoration(
                        //                       hintText: 'Enter text here...',
                        //                       hintStyle: CustomTextStyle(
                        //                         fontSize: 15.fss,
                        //                         fontWeight: FontWeight.w700,
                        //                         color: Colors.black,
                        //                       ),
                        //                       border: InputBorder.none,
                        //                       contentPadding:
                        //                           EdgeInsets.all(10.0),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 IconButton(
                        //                   icon: Icon(Icons.border_color_sharp),
                        //                   onPressed: () {
                        //                     Provider.of<ManageProfileProvider>(
                        //                             context,
                        //                             listen: false)
                        //                         .editBusinessContactPerson();
                        //                   },
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    isAdmin
                        ? Column(
                            children: [
                              profileCommonCards(
                                allContainerStyle: allContainerStyle,
                                allArrowIconSize: allArrowIconSize,
                                descriptionText: '  Mobile Number',
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     Provider.of<ManageProfileProvider>(context,
                              //             listen: false)
                              //         .changeMobileNoVisibility();
                              //     /*
                              //     // setState(() {
                              //     //   Provider.of<TitleProvider>(context,
                              //     //           listen: false)
                              //     //       .title = '';
                              //     // });
                              //     Navigate(context, change_mobile_no_page);*/
                              //     //  Navigate(context, change_password);
                              //   },
                              //   child: SizedBox(
                              //     height: 80,
                              //     child: Padding(
                              //       padding: const EdgeInsets.fromLTRB(
                              //           20, 10, 20, 0),
                              //       child: Container(
                              //         decoration: BoxDecoration(
                              //           shape: BoxShape.rectangle,
                              //           borderRadius:
                              //               BorderRadius.circular(5.0),
                              //           border: Border.all(
                              //             color: Colors.white,
                              //             width: 1.0,
                              //           ),
                              //           color: Colors.white,
                              //         ),
                              //         padding: const EdgeInsets.all(10.0),
                              //         child: Row(
                              //           children: [
                              //             CircleAvatar(
                              //               backgroundColor: Colors.grey[200],
                              //               radius:
                              //                   20, // Adjust the radius as needed
                              //               child: Image.asset(
                              //                 'assets/images/four-squares-button.png',
                              //                 width: 20,
                              //                 height: 20,
                              //                 fit: BoxFit.cover,
                              //               ),
                              //             ),
                              //             SizedBox(width: 8),
                              //             CommonText(
                              //               text: '  Mobile Number',
                              //               textStyle: CustomTextStyle(
                              //                 fontSize: 15,
                              //                 fontWeight: FontWeight.w700,
                              //                 color: Colors.black,
                              //               ),
                              //             ),
                              //             // Spacer(),
                              //             // Icon(
                              //             //   Provider.of<ManageProfileProvider>(
                              //             //             context,
                              //             //           ).isMobileNoVisible ==
                              //             //           false
                              //             //       ? Icons.keyboard_arrow_right
                              //             //       : Icons.keyboard_arrow_down,
                              //             //   size: allArrowIconSize,
                              //             // ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              InkWell(
                                onTap: () {
                                  Navigate(context, verify_password);
                                },
                                child: CustomDetailsFieldForOthers(
                                  data: Provider.of<ManageProfileProvider>(
                                    context,
                                  ).primaryMobileNumberController.text,
                                  isEditable: true,
                                ),
                              )
                              // Padding(
                              //   padding:
                              //       EdgeInsets.fromLTRB(20.ss, 0, 20.ss, 0),
                              //   child: Row(
                              //     children: [
                              //       Expanded(
                              //         child: Container(
                              //           height: subContainerHeight,
                              //           decoration: BoxDecoration(
                              //             color: subContainerColor,
                              //             // border: Border.all(
                              //             //   color: Colors.grey,
                              //             //   width: 1.0,
                              //             // ),
                              //             borderRadius:
                              //                 BorderRadius.circular(5.0),
                              //           ),
                              //           child: Row(
                              //             children: [
                              //               Expanded(
                              //                 child: TextField(
                              //                   style: CustomTextStyle(
                              //                     fontSize: 15.fss,
                              //                     fontWeight: FontWeight.w700,
                              //                     color: Colors.black,
                              //                   ),
                              //                   controller: Provider.of<
                              //                       ManageProfileProvider>(
                              //                     context,
                              //                   ).primaryMobileNumberController,
                              //                   keyboardType:
                              //                       TextInputType.phone,
                              //                   enabled: Provider.of<
                              //                           ManageProfileProvider>(
                              //                         context,
                              //                       ).isBackUpPhoneTextFieldEditable ==
                              //                       true,
                              //                   decoration: InputDecoration(
                              //                     hintText:
                              //                         'Enter your Phone here...',
                              //                     hintStyle: CustomTextStyle(
                              //                       fontSize: 15.fss,
                              //                       fontWeight:
                              //                           FontWeight.w700,
                              //                       color: Colors.black,
                              //                     ),
                              //                     border: InputBorder.none,
                              //                     contentPadding:
                              //                         EdgeInsets.all(10.0),
                              //                   ),
                              //                 ),
                              //               ),
                              //               IconButton(
                              //                 icon: Icon(
                              //                     Icons.border_color_sharp),
                              //                 onPressed: () {
                              //                   Provider.of<ManageProfileProvider>(
                              //                           context,
                              //                           listen: false)
                              //                       .editBackUpPhone();
                              //                 },
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          )
                        : SizedBox(),
                    Column(
                      children: [
                        profileCommonCards(
                          allContainerStyle: allContainerStyle,
                          allArrowIconSize: allArrowIconSize,
                          descriptionText: '  Business Email',
                        ),
                        // SizedBox(
                        //   height: 80.ss,
                        //   child: Padding(
                        //     padding:
                        //         EdgeInsets.fromLTRB(20.ss, 10.ss, 20.ss, 0.ss),
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.rectangle,
                        //         borderRadius: BorderRadius.circular(5.0.ss),
                        //         border: Border.all(
                        //           color: Colors.white,
                        //           width: 1.0,
                        //         ),
                        //         color: Colors.white,
                        //       ),
                        //       padding: EdgeInsets.all(10.0.ss),
                        //       child: Row(
                        //         children: [
                        //           CircleAvatar(
                        //             backgroundColor: Colors.grey[200],
                        //             radius:
                        //                 20.ss, // Adjust the radius as needed
                        //             child: Image.asset(
                        //               'assets/images/four-squares-button.png',
                        //               width: 20.ss,
                        //               height: 20.ss,
                        //               fit: BoxFit.cover,
                        //             ),
                        //           ),
                        //           SizedBox(width: 8),
                        //           Column(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               CommonText(
                        //                 text: '  Business Email',
                        //                 textStyle: CustomTextStyle(
                        //                   fontSize: 15,
                        //                   fontWeight: FontWeight.w700,
                        //                   color: Colors.black,
                        //                 ),
                        //               ),
                        //               // CommonText(
                        //               //   text: context
                        //               //               .watch<ManageProfileProvider>()
                        //               //               .loginData !=
                        //               //           null
                        //               //       ? context
                        //               //           .watch<ManageProfileProvider>()
                        //               //           .loginData!
                        //               //           .cOMPANYBACKUPEMAIL
                        //               //       : "",
                        //               //   textStyle: CustomTextStyle(
                        //               //     fontSize: 12,
                        //               //     fontWeight: FontWeight.w400,
                        //               //     color: Colors.black,
                        //               //   ),
                        //               // ),
                        //             ],
                        //           ),
                        //           // Spacer(),
                        //           // Icon(
                        //           //   Icons.keyboard_arrow_right,
                        //           //   size: allArrowIconSize,
                        //           // ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            _showModalBottomSheet(
                                context,
                                'Primary Business Email',
                                Provider.of<ManageProfileProvider>(context,
                                        listen: false)
                                    .primaryBusinessEmailController,
                                TextInputType.emailAddress);
                          },
                          child: CustomDetailsFieldForOthers(
                            data: Provider.of<ManageProfileProvider>(
                              context,
                            ).primaryBusinessEmailController.text,
                            isEditable: true,
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigate(context, change_password);
                      },
                      child: profileCommonCards(
                        allContainerStyle: allContainerStyle,
                        allArrowIconSize: allArrowIconSize,
                        descriptionText: '  Change Password',
                      ),
                    ),
                    profileCommonCards(
                      allContainerStyle: allContainerStyle,
                      allArrowIconSize: allArrowIconSize,
                      descriptionText: '  Security Questions',
                    ),
                    // SizedBox(
                    //   height: 80.ss,
                    //   child: Padding(
                    //     padding: EdgeInsets.fromLTRB(20.ss, 10.ss, 20.ss, 0),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.rectangle,
                    //         borderRadius: BorderRadius.circular(5.0.ss),
                    //         border: Border.all(
                    //           color: Colors.white,
                    //           width: 1.0.ss,
                    //         ),
                    //         color: Colors.white,
                    //       ),
                    //       padding: EdgeInsets.all(10.0.ss),
                    //       child: Row(
                    //         children: [
                    //           CircleAvatar(
                    //             backgroundColor: Colors.grey[200],
                    //             radius: 20.ss, // Adjust the radius as needed
                    //             child: Image.asset(
                    //               'assets/images/four-squares-button.png',
                    //               width: 20.ss,
                    //               height: 20.ss,
                    //               fit: BoxFit.cover,
                    //             ),
                    //           ),
                    //           SizedBox(width: 8.ss),
                    //           CommonText(
                    //             text: '  Security Questions',
                    //             textStyle: CustomTextStyle(
                    //               fontSize: 15.fss,
                    //               fontWeight: FontWeight.w700,
                    //               color: Colors.black,
                    //             ),
                    //           ),
                    //           Spacer(),
                    //           Icon(
                    //             Icons.keyboard_arrow_right,
                    //             size: allArrowIconSize,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Column(
                      children: [
                        profileCommonCards(
                          allContainerStyle: allContainerStyle,
                          allArrowIconSize: allArrowIconSize,
                          descriptionText: '  Subscription Plan',
                        ),
                        // SizedBox(
                        //   height: 80.ss,
                        //   child: Padding(
                        //     padding:
                        //         EdgeInsets.fromLTRB(20.ss, 10.ss, 20.ss, 0.ss),
                        //     child: InkWell(
                        //       onTap: () {
                        //         Provider.of<ManageProfileProvider>(context,
                        //                 listen: false)
                        //             .changeSubscriptionPlanVisibility();
                        //       },
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //           shape: BoxShape.rectangle,
                        //           borderRadius: BorderRadius.circular(5.0.ss),
                        //           border: Border.all(
                        //             color: Colors.white,
                        //             width: 1.0.ss,
                        //           ),
                        //           color: Colors.white,
                        //         ),
                        //         padding: EdgeInsets.all(10.0.ss),
                        //         child: Row(
                        //           children: [
                        //             CircleAvatar(
                        //               backgroundColor: Colors.grey[200],
                        //               radius:
                        //                   20.ss, // Adjust the radius as needed
                        //               child: Image.asset(
                        //                 'assets/images/four-squares-button.png',
                        //                 width: 20.ss,
                        //                 height: 20.ss,
                        //                 fit: BoxFit.cover,
                        //               ),
                        //             ),
                        //             SizedBox(width: 8.ss),
                        //             CommonText(
                        //               text: '  Subscription Plan',
                        //               textStyle: CustomTextStyle(
                        //                 fontSize: 15.fss,
                        //                 fontWeight: FontWeight.w700,
                        //                 color: Colors.black,
                        //               ),
                        //             ),
                        //             Spacer(),
                        //             Icon(
                        //               Provider.of<ManageProfileProvider>(
                        //                         context,
                        //                       ).isSubscriptionPlanVisible ==
                        //                       false
                        //                   ? Icons.keyboard_arrow_right
                        //                   : Icons.keyboard_arrow_down,
                        //               size: allArrowIconSize,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        CustomDetailsFieldForOthers(
                          data: 'Free Plans - 10 Users',
                          isEditable: false,
                        )
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(20.ss, 0, 20.ss, 0),
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: Container(
                        //           height: subContainerHeight,
                        //           decoration: BoxDecoration(
                        //             color: subContainerColor,
                        //             // border: Border.all(
                        //             //   color: Colors.grey,
                        //             //   width: 1.0,
                        //             // ),
                        //             borderRadius: BorderRadius.circular(5.0),
                        //           ),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Padding(
                        //                 padding: EdgeInsets.only(left: 10.0),
                        //                 child: CommonText(
                        //                   text: 'Free Plans - 10 Users',
                        //                   textStyle: CustomTextStyle(
                        //                     fontSize: 15.fss,
                        //                     fontWeight: FontWeight.w700,
                        //                     color: Colors.black,
                        //                   ),
                        //                 ),
                        //               ),
                        //               IconButton(
                        //                 icon: Icon(Icons.border_color_sharp),
                        //                 onPressed: () {},
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    Column(
                      children: [
                        profileCommonCards(
                          allContainerStyle: allContainerStyle,
                          allArrowIconSize: allArrowIconSize,
                          descriptionText: '  Backup Email & Mobile No.',
                        ),
                        // SizedBox(
                        //   height: 80.ss,
                        //   child: Padding(
                        //     padding:
                        //         EdgeInsets.fromLTRB(20.ss, 10.ss, 20.ss, 0),
                        //     child: InkWell(
                        //       onTap: () {
                        //         Provider.of<ManageProfileProvider>(context,
                        //                 listen: false)
                        //             .changeBackUpEmailPhoneNoVisibility();
                        //       },
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //           shape: BoxShape.rectangle,
                        //           borderRadius: BorderRadius.circular(5.0.ss),
                        //           border: Border.all(
                        //             color: Colors.white,
                        //             width: 1.0.ss,
                        //           ),
                        //           color: Colors.white,
                        //         ),
                        //         padding: EdgeInsets.all(10.0.ss),
                        //         child: Row(
                        //           children: [
                        //             CircleAvatar(
                        //               backgroundColor: Colors.grey[200],
                        //               radius: 20, // Adjust the radius as needed
                        //               child: Image.asset(
                        //                 'assets/images/four-squares-button.png',
                        //                 width: 20.ss,
                        //                 height: 20.ss,
                        //                 fit: BoxFit.cover,
                        //               ),
                        //             ),
                        //             SizedBox(width: 8.ss),
                        //             CommonText(
                        //               text: '  Backup Email & Mobile No.',
                        //               textStyle: CustomTextStyle(
                        //                 fontSize: 15.fss,
                        //                 fontWeight: FontWeight.w700,
                        //                 color: Colors.black,
                        //               ),
                        //             ),
                        //             // Spacer(),
                        //             // Icon(
                        //             //   Provider.of<ManageProfileProvider>(
                        //             //             context,
                        //             //           ).isBackUpEmailPhoneNoVisible ==
                        //             //           false
                        //             //       ? Icons.keyboard_arrow_right
                        //             //       : Icons.keyboard_arrow_down,
                        //             //   size: allArrowIconSize,
                        //             // ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            _showModalBottomSheet(
                                context,
                                'Back-up email',
                                Provider.of<ManageProfileProvider>(context,
                                        listen: false)
                                    .trustedBackupEmailController,
                                TextInputType.emailAddress);
                          },
                          child: Provider.of<ManageProfileProvider>(
                            context,
                          ).trustedBackupEmailController.text.isNotEmpty
                              ? CustomDetailsFieldForOthers(
                                  data: Provider.of<ManageProfileProvider>(
                                    context,
                                  ).trustedBackupEmailController.text,
                                  isEditable: true,
                                )
                              : CustomDetailsFieldForOthers(
                                  data: "add backup email",
                                  isEditable: true,
                                  secondaryColor: Colors.grey,
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            _showModalBottomSheet(
                                context,
                                'Back-up Mobile No.',
                                Provider.of<ManageProfileProvider>(context,
                                        listen: false)
                                    .trustedBackupMobileNumberController,
                                TextInputType.phone);
                          },
                          child: Provider.of<ManageProfileProvider>(
                            context,
                          ).trustedBackupMobileNumberController.text.isNotEmpty
                              ? CustomDetailsFieldForOthers(
                                  data: Provider.of<ManageProfileProvider>(
                                    context,
                                  ).trustedBackupMobileNumberController.text,
                                  isEditable: true,
                                )
                              : CustomDetailsFieldForOthers(
                                  data: "add backup phone no",
                                  isEditable: true,
                                  secondaryColor: Colors.grey,
                                ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(20.ss, 0, 20.ss, 0),
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: Container(
                        //           height: subContainerHeight,
                        //           decoration: BoxDecoration(
                        //             color: subContainerColor,
                        //             // border: Border.all(
                        //             //   color: Colors.grey,
                        //             //   width: 1.0,
                        //             // ),
                        //             borderRadius: BorderRadius.circular(5.0),
                        //           ),
                        //           child: Row(
                        //             children: [
                        //               Expanded(
                        //                 child: TextField(
                        //                   style: CustomTextStyle(
                        //                     fontSize: 15.fss,
                        //                     fontWeight: FontWeight.w700,
                        //                     color: Colors.black,
                        //                   ),
                        //                   controller: Provider.of<
                        //                       ManageProfileProvider>(
                        //                     context,
                        //                   ).trustedBackupEmailController,
                        //                   keyboardType:
                        //                       TextInputType.emailAddress,
                        //                   enabled: Provider.of<
                        //                           ManageProfileProvider>(
                        //                         context,
                        //                       ).isBackUpEmailTextFieldEditable ==
                        //                       true,
                        //                   decoration: InputDecoration(
                        //                     hintText:
                        //                         'Enter your email here...',
                        //                     hintStyle: CustomTextStyle(
                        //                       fontSize: 15.fss,
                        //                       fontWeight: FontWeight.w700,
                        //                       color: Colors.black,
                        //                     ),
                        //                     border: InputBorder.none,
                        //                     contentPadding:
                        //                         EdgeInsets.all(10.0),
                        //                   ),
                        //                 ),
                        //               ),
                        //               IconButton(
                        //                 icon: Icon(Icons.border_color_sharp),
                        //                 onPressed: () {
                        //                   Provider.of<ManageProfileProvider>(
                        //                           context,
                        //                           listen: false)
                        //                       .editBackUpEmail();
                        //                 },
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 2.0,
                        // ),
                        // Visibility(
                        //   visible: Provider.of<ManageProfileProvider>(
                        //         context,
                        //       ).isBackUpEmailPhoneNoVisible ==
                        //       true,
                        //   child: Padding(
                        //     padding: EdgeInsets.fromLTRB(20.ss, 0, 20.ss, 0),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: Container(
                        //             height: subContainerHeight,
                        //             decoration: BoxDecoration(
                        //               color: subContainerColor,
                        //               // border: Border.all(
                        //               //   color: Colors.grey,
                        //               //   width: 1.0,
                        //               // ),
                        //               borderRadius: BorderRadius.circular(5.0),
                        //             ),
                        //             child: Row(
                        //               children: [
                        //                 Expanded(
                        //                   child: TextField(
                        //                     style: CustomTextStyle(
                        //                       fontSize: 15.fss,
                        //                       fontWeight: FontWeight.w700,
                        //                       color: Colors.black,
                        //                     ),
                        //                     controller: Provider.of<
                        //                         ManageProfileProvider>(
                        //                       context,
                        //                     ).trustedBackupMobileNumberController,
                        //                     keyboardType: TextInputType.phone,
                        //                     enabled: Provider.of<
                        //                             ManageProfileProvider>(
                        //                           context,
                        //                         ).isBackUpPhoneTextFieldEditable ==
                        //                         true,
                        //                     decoration: InputDecoration(
                        //                       hintText:
                        //                           'Enter your Phone here...',
                        //                       hintStyle: CustomTextStyle(
                        //                         fontSize: 15.fss,
                        //                         fontWeight: FontWeight.w700,
                        //                         color: Colors.black,
                        //                       ),
                        //                       border: InputBorder.none,
                        //                       contentPadding:
                        //                           EdgeInsets.all(10.0),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 IconButton(
                        //                   icon: Icon(Icons.border_color_sharp),
                        //                   onPressed: () {
                        //                     Provider.of<ManageProfileProvider>(
                        //                             context,
                        //                             listen: false)
                        //                         .editBackUpPhone();
                        //                   },
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    Column(
                      children: [
                        profileCommonCards(
                          allContainerStyle: allContainerStyle,
                          allArrowIconSize: allArrowIconSize,
                          descriptionText: '  Registration Date',
                        ),
                        // SizedBox(
                        //   height: 80.ss,
                        //   child: Padding(
                        //     padding:
                        //         EdgeInsets.fromLTRB(20.ss, 10.ss, 20.ss, 0),
                        //     child: InkWell(
                        //       onTap: () {
                        //         Provider.of<ManageProfileProvider>(context,
                        //                 listen: false)
                        //             .changeRegistrationDateVisibility();
                        //         print("changeRegistrationDateVisibility");
                        //       },
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //           shape: BoxShape.rectangle,
                        //           borderRadius: BorderRadius.circular(5.0.ss),
                        //           border: Border.all(
                        //             color: Colors.white,
                        //             width: 1.0.ss,
                        //           ),
                        //           color: Colors.white,
                        //         ),
                        //         padding: EdgeInsets.all(10.0.ss),
                        //         child: Row(
                        //           children: [
                        //             CircleAvatar(
                        //               backgroundColor: Colors.grey[200],
                        //               radius:
                        //                   20.ss, // Adjust the radius as needed
                        //               child: Image.asset(
                        //                 'assets/images/four-squares-button.png',
                        //                 width: 20.ss,
                        //                 height: 20.ss,
                        //                 fit: BoxFit.cover,
                        //               ),
                        //             ),
                        //             SizedBox(width: 8.ss),
                        //             CommonText(
                        //               text: '  Registration Date',
                        //               textStyle: CustomTextStyle(
                        //                 fontSize: 15.fss,
                        //                 fontWeight: FontWeight.w700,
                        //                 color: Colors.black,
                        //               ),
                        //             ),
                        //             // Spacer(),
                        //             // Icon(
                        //             //   Provider.of<ManageProfileProvider>(
                        //             //             context,
                        //             //           ).isRegistrationDateVisible ==
                        //             //           false
                        //             //       ? Icons.keyboard_arrow_right
                        //             //       : Icons.keyboard_arrow_down,
                        //             //   size: allArrowIconSize,
                        //             // ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        CustomDetailsFieldForOthers(
                          data: '${Provider.of<ManageProfileProvider>(
                            context,
                          ).registrationDate}',
                          isEditable: false,
                        ),
                        // Visibility(
                        //   visible: Provider.of<ManageProfileProvider>(
                        //         context,
                        //       ).isRegistrationDateVisible ==
                        //       true,
                        //   child: Padding(
                        //     padding: EdgeInsets.fromLTRB(20.ss, 0, 20.ss, 0),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: Container(
                        //             height: subContainerHeight,
                        //             decoration: BoxDecoration(
                        //               color: subContainerColor,
                        //               // border: Border.all(
                        //               //   color: Colors.grey,
                        //               //   width: 1.0,
                        //               // ),
                        //               borderRadius: BorderRadius.circular(5.0),
                        //             ),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Padding(
                        //                   padding: EdgeInsets.only(left: 10.0),
                        //                   child: CommonText(
                        //                     text:
                        //                         '${Provider.of<ManageProfileProvider>(
                        //                       context,
                        //                     ).registrationDate}',
                        //                     textStyle: CustomTextStyle(
                        //                       fontSize: 15.fss,
                        //                       fontWeight: FontWeight.w700,
                        //                       color: Colors.black,
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 // IconButton(
                        //                 //   icon: Icon(Icons.border_color_sharp),
                        //                 //   onPressed: () {},
                        //                 // ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigate(context, marketing);
                          },
                          child: profileCommonCards(
                            allContainerStyle: allContainerStyle,
                            allArrowIconSize: allArrowIconSize,
                            descriptionText: '  Marketing',
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigate(context, marketing);
                          },
                          child: Provider.of<ManageProfileProvider>(
                            context,
                          ).locations.isNotEmpty
                              ? CustomDetailsFieldForOthers(
                                  data: Provider.of<ManageProfileProvider>(
                                    context,
                                  ).locations.join(', '),
                                  isEditable: true,
                                )
                              : CustomDetailsFieldForOthers(
                                  data: "add customer locations",
                                  isEditable: true,
                                  secondaryColor: Colors.grey,
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigate(context, marketing);
                          },
                          child: Provider.of<ManageProfileProvider>(
                            context,
                          ).marketing.text.isNotEmpty
                              ? CustomDetailsFieldForOthers(
                                  data: Provider.of<ManageProfileProvider>(
                                    context,
                                  ).marketing.text,
                                  isEditable: true,
                                )
                              : CustomDetailsFieldForOthers(
                                  data: "add marketing description",
                                  isEditable: true,
                                  secondaryColor: Colors.grey,
                                ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        profileCommonCards(
                          allContainerStyle: allContainerStyle,
                          allArrowIconSize: allArrowIconSize,
                          descriptionText: '  Address',
                        ),
                        // SizedBox(
                        //   height: 80.ss,
                        //   child: Padding(
                        //     padding:
                        //         EdgeInsets.fromLTRB(20.ss, 10.ss, 20.ss, 0),
                        //     child: InkWell(
                        //       onTap: () {
                        //         Provider.of<ManageProfileProvider>(context,
                        //                 listen: false)
                        //             .changeAddressVisibility();
                        //       },
                        //       child: Container(
                        //         decoration: BoxDecoration(
                        //           shape: BoxShape.rectangle,
                        //           borderRadius: BorderRadius.circular(5.0.ss),
                        //           border: Border.all(
                        //             color: Colors.white,
                        //             width: 1.0.ss,
                        //           ),
                        //           color: Colors.white,
                        //         ),
                        //         padding: EdgeInsets.all(10.0.ss),
                        //         child: Row(
                        //           children: [
                        //             CircleAvatar(
                        //               backgroundColor: Colors.grey[200],
                        //               radius: 20, // Adjust the radius as needed
                        //               child: Image.asset(
                        //                 'assets/images/four-squares-button.png',
                        //                 width: 20.ss,
                        //                 height: 20.ss,
                        //                 fit: BoxFit.cover,
                        //               ),
                        //             ),
                        //             SizedBox(width: 8.ss),
                        //             CommonText(
                        //               text: '  Address',
                        //               textStyle: CustomTextStyle(
                        //                 fontSize: 15.fss,
                        //                 fontWeight: FontWeight.w700,
                        //                 color: Colors.black,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            _showModalBottomSheet(
                                context,
                                'address',
                                Provider.of<ManageProfileProvider>(context,
                                        listen: false)
                                    .addressController,
                                TextInputType.streetAddress);
                          },
                          child: Provider.of<ManageProfileProvider>(
                            context,
                          ).addressController.text.isNotEmpty
                              ? CustomDetailsFieldForOthers(
                                  data: Provider.of<ManageProfileProvider>(
                                    context,
                                  ).addressController.text,
                                  isEditable: true,
                                )
                              : CustomDetailsFieldForOthers(
                                  data: "add address",
                                  isEditable: true,
                                  secondaryColor: Colors.grey,
                                ),
                        ),
                        // Visibility(
                        //     visible: Provider.of<ManageProfileProvider>(
                        //           context,
                        //         ).isAddressVisible ==
                        //         true,
                        //     child: Padding(
                        //       padding: EdgeInsets.fromLTRB(20.ss, 0, 20.ss, 0),
                        //       child: Row(
                        //         children: [
                        //           Expanded(
                        //             child: Container(
                        //               height: subContainerHeight,
                        //               decoration: BoxDecoration(
                        //                 color: subContainerColor,
                        //                 // border: Border.all(
                        //                 //   color: Colors.grey,
                        //                 //   width: 1.0,
                        //                 // ),
                        //                 borderRadius:
                        //                     BorderRadius.circular(5.0),
                        //               ),
                        //               child: Row(
                        //                 children: [
                        //                   Expanded(
                        //                     child: TextField(
                        //                       style: CustomTextStyle(
                        //                         fontSize: 15.fss,
                        //                         fontWeight: FontWeight.w700,
                        //                         color: Colors.black,
                        //                       ),
                        //                       controller: Provider.of<
                        //                           ManageProfileProvider>(
                        //                         context,
                        //                       ).addressController,
                        //                       keyboardType: TextInputType.phone,
                        //                       enabled: Provider.of<
                        //                               ManageProfileProvider>(
                        //                             context,
                        //                           ).isAddressTextFieldVisible ==
                        //                           true,
                        //                       decoration: InputDecoration(
                        //                         hintText:
                        //                             'Enter your Address here...',
                        //                         hintStyle: CustomTextStyle(
                        //                           fontSize: 15.fss,
                        //                           fontWeight: FontWeight.w700,
                        //                           color: Colors.black,
                        //                         ),
                        //                         border: InputBorder.none,
                        //                         contentPadding:
                        //                             EdgeInsets.all(10.0),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   IconButton(
                        //                     icon:
                        //                         Icon(Icons.border_color_sharp),
                        //                     onPressed: () {
                        //                       Provider.of<ManageProfileProvider>(
                        //                               context,
                        //                               listen: false)
                        //                           .editAddress();
                        //                     },
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     )
                        // ),
                        // SizedBox(
                        //   // height: 80.ss,
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Padding(
                        //     padding:
                        //         EdgeInsets.fromLTRB(20.ss, 10.ss, 20.ss, 0),
                        //     child: InkWell(
                        //       onTap: () {
                        //         _showModalBottomSheet(
                        //             context,
                        //             'address',
                        //             Provider.of<ManageProfileProvider>(context,
                        //                     listen: false)
                        //                 .primaryMobileNumberController);
                        //       },
                        //       child: Container(
                        //           decoration: BoxDecoration(
                        //             shape: BoxShape.rectangle,
                        //             borderRadius: BorderRadius.circular(5.0.ss),
                        //             border: Border.all(
                        //               color: Colors.white,
                        //               width: 1.0.ss,
                        //             ),
                        //             color: Colors.white,
                        //           ),
                        //           padding: EdgeInsets.all(10.0.ss),
                        //           child: Center(
                        //             child: CommonText(
                        //               text: 'Save',
                        //               textStyle: CustomTextStyle(
                        //                 fontSize: 15.fss,
                        //                 fontWeight: FontWeight.w700,
                        //                 color: Colors.black,
                        //               ),
                        //             ),
                        //           )),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    Gap(10.0.ss),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getUserData() async {
    data = await GlobalHandler.getLoginData();
    if (data != null && data!.userType != "1") {
      isAdmin = false;
      setState(() {});
    }
  }
}

class profileCommonCards extends StatelessWidget {
  final TextStyle allContainerStyle;
  final double allArrowIconSize;
  final String descriptionText;
  const profileCommonCards(
      {super.key,
      required this.allContainerStyle,
      required this.allArrowIconSize,
      required this.descriptionText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.ss,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.ss, 10.ss, 20.ss, 0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5.0.ss),
            border: Border.all(
              color: Colors.white,
              width: 1.0.ss,
            ),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10.0.ss),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 20.ss, // Adjust the radius as needed
                  child: Image.asset(
                    'assets/images/four-squares-button.png',
                    width: 20.ss,
                    height: 20.ss,
                    fit: BoxFit.cover,
                  )),
              SizedBox(width: 8.ss),
              CommonText(
                text: descriptionText,
                textStyle: allContainerStyle,
              ),
              // Padding(padding: const EdgeInsets.all(16.0),),
              // Spacer(),
              // Icon(
              //   Icons.keyboard_arrow_right,
              //   size: allArrowIconSize,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
