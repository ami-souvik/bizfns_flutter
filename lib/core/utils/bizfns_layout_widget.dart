import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/Admin/Create Job/model/add_schedule_model.dart';
import '../../features/GoogleDocs/authentication/auth_manager.dart';
import '../../features/Home/provider/home_provider.dart';
import '../../provider/job_schedule_controller.dart';
import '../route/RouteConstants.dart';
import '../shared_pref/shared_pref.dart';
import 'Utils.dart';
import 'colour_constants.dart';

class TitleProvider extends ChangeNotifier {
  String title = "";
  bool isCenter = false;

  changeTitle(String text) {
    title = text;
    // notifyListeners();
  }
}

class BizfnsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ValueChanged onPop;
  bool? isCenter;

  BizfnsAppBar(
      {super.key, required this.title, required this.onPop, this.isCenter});

  AddScheduleModel model = AddScheduleModel.addSchedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.APP_BAR_COLOUR,
      child: SafeArea(
        child: AppBar(
          // centerTitle: Provider.of<TitleProvider>(context, listen: false).isCenter,
          elevation: 0,
          backgroundColor: AppColor.APP_BAR_COLOUR,
          leading: InkWell(
            onTap: () {
              // if (model.images != null) {
              //   model.images = null;

              // }
              if(model.allImageList !=null){
                model.allImageList!.clear();
                model.allImageList!
                    .addAll(model!.copyImages!);
              }
              // if(Provider.of<JobScheduleProvider>(context, listen: false).items.isNotEmpty){
              //   Provider.of<JobScheduleProvider>(context, listen: false).loadPrevData(context);
              // }

              onPop(true);
            },
            /*onTap: () {

            },*/
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: CommonText(text: title),
          centerTitle:
              title == '${context.watch<HomeProvider>().companyName}' ||
                  title == 'Profile' ||
                  title == 'Service-Event Details' ||
                  title == 'Schedule New Modify' ||
                  title == 'Schedule New-Modify' ||
                  title == 'Account',
          actions: title == 'Profile'
              ? [
                  InkWell(
                    child: const Center(
                      child: Text(
                        'Log out  ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.leftSlide,
                        headerAnimationLoop: false,
                        dialogType: DialogType.infoReverse,
                        width: kIsWeb
                            ? MediaQuery.of(context).size.width * 0.4
                            : MediaQuery.of(context).size.width,
                        // showCloseIcon: true,
                        title: 'Warning',
                        desc: "Are you sure you want to logout ?",

                        // desc: 'Dialog description here..................................................',
                        btnOkOnPress: () async {
                          // Utils().printMessage('OnClick');
                          await GlobalHandler.setLogedIn(false);
                          await GlobalHandler.setSequrityQuestionAnswered(
                              false);
                          await GlobalHandler.setLoginData(null);

                          // GoRouter.of(context).pop();
                          Provider.of<TitleProvider>(context, listen: false)
                              .title = '';

                          await DefaultCacheManager().emptyCache();

                          Future.delayed(
                            const Duration(milliseconds: 200),
                            () => context.go(login),
                          );
                        },
                        btnCancelOnPress: () {},
                        btnOkIcon: Icons.check_circle,
                        onDismissCallback: (type) {
                          Utils().printMessage(
                              'Dialog Dismiss from callback $type');
                        },
                      ).show();
                    },
                  ),
                ]
              : title == 'Google-docs' && AuthManager.signIn() != null
                  ? [
                      InkWell(
                        child: const Center(
                          child: Text(
                            'Log out  ',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        onTap: () {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.leftSlide,
                            headerAnimationLoop: false,
                            dialogType: DialogType.infoReverse,
                            width: kIsWeb
                                ? MediaQuery.of(context).size.width * 0.4
                                : MediaQuery.of(context).size.width,
                            // showCloseIcon: true,
                            title: 'Warning',
                            desc:
                                "Are you sure you want to logout from your Google Account?",

                            // desc: 'Dialog description here..................................................',
                            btnOkOnPress: () async {
                              await AuthManager.signOut();
                              Provider.of<TitleProvider>(context, listen: false)
                                  .title = 'Documents';
                              GoRouter.of(context).pop();
                              // GoRouter.of(context).pop();

                              // setState((){});
                              // Utils().printMessage('OnClick');
                              // await GlobalHandler.setLogedIn(false);
                              // await GlobalHandler.setSequrityQuestionAnswered(
                              //     false);
                              // await GlobalHandler.setLoginData(null);

                              // // GoRouter.of(context).pop();
                              // Provider.of<TitleProvider>(context, listen: false)
                              //     .title = '';

                              // await DefaultCacheManager().emptyCache();

                              // Future.delayed(
                              //   const Duration(milliseconds: 200),
                              //   () => context.go(login),
                              // );
                            },
                            btnCancelOnPress: () {},
                            btnOkIcon: Icons.check_circle,
                            onDismissCallback: (type) {
                              Utils().printMessage(
                                  'Dialog Dismiss from callback $type');
                            },
                          ).show();
                        },
                      ),
                    ]
                  : [],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
