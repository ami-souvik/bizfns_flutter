import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bizfns/core/utils/fonts.dart';
import 'package:bizfns/core/utils/route_function.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/Home/bizfins_share_widget.dart';
import 'package:bizfns/features/Home/dashboard.dart';
import 'package:bizfns/features/auth/Login/model/login_otp_verification_model.dart';
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
import '../../core/utils/bizfns_layout_widget.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isAdmin = false;
  OtpVerificationData? data;

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

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // String appBarTitle = getAppBarTitle(context);

        GoRouter.of(context).goNamed('home');
        return false;
      },
      child: Scaffold(
        /*appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Provider.of<BottomNavigationProvider>(context,listen: false).popIndex();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: CommonText(text: "Admin"),
          backgroundColor: AppColor.BUTTON_COLOR,
          // leading: BackButton(color: Colors.white,),
        ),*/
        body: data == null
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                  color: Colors.blue,
                ),
              )
            : Container(
                height: kIsWeb
                    ? MediaQuery.of(context).size.height * 0.90.ss
                    : MediaQuery.of(context).size.height * 0.90.ss,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[200],
                child: Column(
                  children: [
                    Gap(2.ss),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          isAdmin
                              ? InkWell(
                                  child: SizedBox(
                                    height: 80.ss,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          14.ss, 12.ss, 14.ss, 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5.0.ss),
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
                                                backgroundColor:
                                                    Colors.grey[200],
                                                radius: 20.ss,
                                                // Adjust the radius as needed
                                                child: Image.asset(
                                                  'assets/images/four-squares-button.png',
                                                  width: 20.ss,
                                                  height: 20.ss,
                                                  fit: BoxFit.cover,
                                                )),
                                            SizedBox(width: 8.ss),
                                            CommonText(
                                              text: '  Staff',
                                              textStyle: CustomTextStyle(
                                                fontSize: 15.fss,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                            // Padding(padding: const EdgeInsets.all(16.0),),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    // Navigate(context, add_staff);
                                    //Navigate(context, staff_list);
                                    GoRouter.of(context).goNamed('view-staff');
                                  },
                                )
                              : SizedBox(),
                          isAdmin
                              ? InkWell(
                                  onTap: () {
                                    GoRouter.of(context)
                                        .goNamed('view-customer');
                                    //Navigate(context, customer_list);
                                  },
                                  child: SizedBox(
                                    height: 80.ss,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          14.ss, 12.ss, 14.ss, 0.ss),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5.0.ss),
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
                                              radius: 20
                                                  .ss, // Adjust the radius as needed
                                              child: Image.asset(
                                                'assets/images/four-squares-button.png',
                                                width: 20.ss,
                                                height: 20.ss,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(width: 8.ss),
                                            CommonText(
                                              text: '  Customer',
                                              textStyle: CustomTextStyle(
                                                fontSize: 15.fss,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          isAdmin
                              ? InkWell(
                                  child: SizedBox(
                                    height: 80.ss,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          14.ss, 12.ss, 14.ss, 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5.0.ss),
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
                                                backgroundColor:
                                                    Colors.grey[200],
                                                radius: 20.ss,
                                                // Adjust the radius as needed
                                                child: Image.asset(
                                                  'assets/images/four-squares-button.png',
                                                  width: 20.ss,
                                                  height: 20.ss,
                                                  fit: BoxFit.cover,
                                                )),
                                            SizedBox(width: 8.ss),
                                            CommonText(
                                              text: '  Materials',
                                              textStyle: CustomTextStyle(
                                                fontSize: 15.fss,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                            // Padding(padding: const EdgeInsets.all(16.0),),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    GoRouter.of(context)
                                        .goNamed('view-materials');
                                    //Navigate(context, material_list);
                                  },
                                )
                              : SizedBox(),
                          isAdmin
                              ? InkWell(
                                  child: SizedBox(
                                    height: 80.ss,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          14.ss, 12.ss, 14.ss, 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5.0.ss),
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
                                                backgroundColor:
                                                    Colors.grey[200],
                                                radius: 20.ss,
                                                // Adjust the radius as needed
                                                child: Image.asset(
                                                  'assets/images/four-squares-button.png',
                                                  width: 20.ss,
                                                  height: 20.ss,
                                                  fit: BoxFit.cover,
                                                )),
                                            SizedBox(width: 8.ss),
                                            CommonText(
                                              text: '  Services',
                                              textStyle: CustomTextStyle(
                                                fontSize: 15.fss,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                            // Padding(padding: const EdgeInsets.all(16.0),),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    GoRouter.of(context)
                                        .goNamed('view-services');
                                    //Navigate(context, service_list);
                                  },
                                )
                              : SizedBox(),
                          isAdmin
                              ? InkWell(
                                  child: SizedBox(
                                    height: 80.ss,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          14.ss, 12.ss, 14.ss, 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5.0.ss),
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
                                                backgroundColor:
                                                    Colors.grey[200],
                                                radius: 20.ss,
                                                // Adjust the radius as needed
                                                child: Image.asset(
                                                  'assets/images/four-squares-button.png',
                                                  width: 20.ss,
                                                  height: 20.ss,
                                                  fit: BoxFit.cover,
                                                )),
                                            SizedBox(width: 8.ss),
                                            CommonText(
                                              text: '  Category',
                                              textStyle: CustomTextStyle(
                                                fontSize: 15.fss,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                            // Padding(padding: const EdgeInsets.all(16.0),),
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    GoRouter.of(context)
                                        .goNamed('view-category');
                                    //Navigate(context, service_list);
                                  },
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    BizfinsShareWidget(),
                  ],
                ),
              ),
      ),
    );
  }

  void getUserData() async {
    data = await GlobalHandler.getLoginData();
    //inbefore staff login it was if (data != null && data!.userType != "1")
    if (data != null && data!.userType != "1" && data!.userType != "2") {
      isAdmin = false;
      setState(() {});
    } else {
      isAdmin = true;
      setState(() {});
    }
  }
}
