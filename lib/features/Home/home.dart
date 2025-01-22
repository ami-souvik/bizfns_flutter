import 'dart:io';

import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/core/utils/fonts.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/Home/bizfins_share_widget.dart';
import 'package:bizfns/features/Home/provider/home_provider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../core/route/RouteConstants.dart';
import '../../core/shared_pref/shared_pref.dart';
import '../../core/utils/route_function.dart';
import '../../core/widgets/common_text_form_field.dart';
import '../auth/Login/model/login_otp_verification_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

var listName = ["Schedule ", "Accounts", "Customer", "Staff"];
OtpVerificationData? data;
var colors = [
  Color(0xFF00ACD8).withOpacity(0.8),
  Colors.indigoAccent.withOpacity(0.5),
  Colors.blueAccent.withOpacity(0.6),
  Colors.blueAccent.withOpacity(0.5),
  /*Colors.blueAccent.withOpacity(0.4),
  Colors.blueAccent.withOpacity(0.3),*/
];
var listImage = [
  "assets/images/calendar_icon.png",
  "assets/images/profit 1.png",
  "assets/images/customer 1.png",
  "assets/images/team 1.png"
];
var navPoint = [SCHEDULE_PAGE, add_staff, customer_list, staff_list];

class _HomePageState extends State<HomePage> {
  FlipCardController? _flipScheduleController,
      _flipAccountsController,
      _flipCustomerController,
      _flipStaffController;

  //List<FlipCardController> _flipController = [];

  @override
  void initState() {
    _flipScheduleController = FlipCardController();
    _flipAccountsController = FlipCardController();
    _flipCustomerController = FlipCardController();
    _flipStaffController = FlipCardController();
    Provider.of<HomeProvider>(context, listen: false).getCompanyDetails();
    extractLoginData();

    super.initState();
  }

  extractLoginData() async {
    data = await GlobalHandler.getLoginData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0.ss),
        child: Column(
          // shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 10.ss, vertical: 50.ss),
              padding: EdgeInsets.only(
                  top: 30.ss, right: 10.ss, bottom: 40.ss, left: 10.ss),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: context.watch<HomeProvider>().companyName.length >
                                20
                            ? '${context.watch<HomeProvider>().companyName.substring(0, 20)}...'
                            : context.watch<HomeProvider>().companyName,
                        maxLine: 3,
                        textOverflow: TextOverflow.ellipsis,
                        textStyle: CustomTextStyle(
                            fontSize: 26.fss,
                            color: AppColor.BUTTON_COLOR,
                            fontWeight: FontWeight.w800),
                      ),
                      data != null && data!.userTypeId == "2"
                          ? CommonText(
                              text: "Staff",
                            )
                          : Text('')
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).pushNamed('accounts');
                      //Navigate(context, account_page);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/profile.svg',
                          width: 25.ss,
                          height: 30.ss,
                          color: AppColor.APP_BAR_COLOUR,
                        ),
                        CommonText(
                          text: "Profile",
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CommonTextFormField(
              hintText: "Search",
              decoration: InputDecoration(
                border: OutlineInputBorder(gapPadding: 1),
                isDense: false,
                // isCollapsed: true,
                prefixIcon: IntrinsicHeight(
                  child: Row(
                    children: [
                      SizedBox(width: 5.ss),
                      ImageIcon(
                        AssetImage('assets/images/bell 2.png'),
                        color: AppColor.BUTTON_COLOR,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0.ss, vertical: 5.ss),
                        child: VerticalDivider(
                          width: 5.ss,
                          color: AppColor.BUTTON_COLOR,
                        ),
                      )
                    ],
                  ),
                ),
                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 24),
                enabledBorder: OutlineInputBorder(gapPadding: 1),
                focusedBorder: OutlineInputBorder(gapPadding: 1),
                // prefix:  IntrinsicHeight(
                //   child: Row(
                //     children: [
                //       ImageIcon(
                //         AssetImage('assets/images/bell 2.png'),
                //         color: AppColor.BUTTON_COLOR,
                //
                //       ),
                //       Padding(
                //         padding:  EdgeInsets.symmetric(horizontal: 2.0.ss),
                //         child: VerticalDivider(width: 5.ss,color: AppColor.BUTTON_COLOR,),
                //       )
                //     ],
                //   ),
                // ),
              ),
            ),
            Gap(50.ss),
            Expanded(
              flex: 1,
              child: GridView.builder(
                itemCount: 4,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0),
                itemBuilder: (context, index) {
                  return MenuBuild(listName[index], listImage[index], size,
                      colors[index], navPoint[index], context, index);
                },
              ),
            ),
            Gap(2.ss),
            BizfinsShareWidget(),
          ],
        ),
      ),
    );
  }

  Widget MenuBuild(String text, String img, Size size, Color color,
      String navPoint, BuildContext context, int index) {
    FlipCardController? controller = index == 0
        ? _flipScheduleController
        : index == 1
            ? _flipAccountsController
            : index == 2
                ? _flipCustomerController
                : _flipStaffController;

    return MouseRegion(
      onHover: (val) async {
        await controller!.toggleCard();
      },
      onExit: (val) async {
        if (controller!.state!.isFront == false) {
          await controller!.toggleCard();
        }
      },
      child: FlipCard(
        fill: Fill.fillBack,
        direction: FlipDirection.HORIZONTAL,
        // default
        side: CardSide.FRONT,
        speed: 1000,
        controller: controller,
        flipOnTouch: false,
        back: Container(
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.width / 2.5,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              color: color,
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(10)),
        ),
        front: InkWell(
          onTap: () {
            // context.go(navPoint);
            print(navPoint);
            //Navigate(context, navPoint);
            if (index == 0) {
              GoRouter.of(context).goNamed('schedule');
            } else if (index == 1) {
              GoRouter.of(context).goNamed('accounts2');
            } else if (index == 2) {
              GoRouter.of(context).goNamed('all-customer');
            } else {
              GoRouter.of(context).goNamed('staff');
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width / 2.5,
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                color: color,
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    // padding: EdgeInsets.all(10),
                    // height: MediaQuery.of(context).size.height * 0.12,
                    // width: MediaQuery.of(context).size.height * 0.12,
                    // child: SvgPicture.asset("assets/images/profit 1.svg",height: 50.ss, width: 50.ss,color: Colors.red, )
                    child: Row(
                  children: [
                    img == "assets/images/calendar_icon.png"
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 10),
                            child: Image(
                              image: AssetImage(img),
                              width: 30.ss,
                              height: 30.ss,
                              color: Colors.white,
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                            ),
                          )
                        : Image(
                            image: AssetImage(img),
                            width: 80.ss,
                            height: 80.ss,
                            color: Colors.white,
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                          ),
                    Spacer(),
                    Image(
                      image: AssetImage(
                        "assets/images/triple_dot.png",
                      ),
                      width: 60.ss,
                      height: 60.ss,
                      color: Colors.white,
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                    ),
                  ],
                )),
                // Gap(10.ss),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.0.ss, vertical: 20.ss),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 18.fss,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
