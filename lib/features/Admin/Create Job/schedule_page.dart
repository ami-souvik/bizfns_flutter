import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/core/utils/route_function.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/route/RouteConstants.dart';
import '../../../core/utils/bizfns_layout_widget.dart';
import '../../../core/widgets/HeaderJobPageWidget/header_jon_page_widget.dart';
import '../../../core/widgets/TimeJobScheduleListWidget/time_job_schedule_list.dart';
import '../../../provider/job_schedule_controller.dart';
import '../../Home/provider/home_provider.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        String appBarTitle = getAppBarTitle(context);

        Provider.of<TitleProvider>(context, listen: false)
            .changeTitle(appBarTitle);

        // try {
        //   print('In Dashboard App Bar');

        //   GoRouter.of(context).pop();
        // } catch (ex) {
        //   popBranch();
        // }
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        // appBar: BizfnsAppBar(
        //     onPop: (val) {
        //       Provider.of<JobScheduleProvider>(context, listen: false)
        //           .clearChanges();
        //       Navigate.NavigateAndReplace(context, home);
        //     },
        //     title: Provider.of<TitleProvider>(context)
        //         .title /*widget.navigationShell.currentIndex == 1
        //                 ? "Documents"
        //                 : widget.navigationShell.currentIndex == 2
        //                 ? "Admin"
        //                 : widget.navigationShell.currentIndex == 3
        //                 ? "Settings"
        //                 : "",*/
        //     )
        //  AppBar(
        //     backgroundColor: AppColor.APP_BAR_COLOUR,
        //     elevation: 0,
        //     centerTitle: true,
        //     title: CommonText(
        //       text: context.watch<HomeProvider>().companyName,
        //       textStyle: TextStyle(color: Colors.white),
        //     )
        //     // Text(
        //     //   context.watch<HomeProvider>().companyName,
        //     //   style: TextStyle(color: Colors.black, fontSize: 16),
        //     // )
        //     ,
        //     leading: GestureDetector(
        //         onTap: () {
        //           // print("here we are backing from ")
        //           // Navigator.pop(context);
        //           // Fluttertoast.showToast(msg: "back");
        //           Provider.of<JobScheduleProvider>(context, listen: false)
        //               .clearChanges();
        //           Navigate.NavigateAndReplace(context, home);
        //         },
        //         child: Icon(
        //           Icons.arrow_back,
        //           color: Colors.white,
        //         ) /*Padding(
        //     padding: const EdgeInsets.all(15.0),
        //     child: Container(
        //       //margin: const EdgeInsets.all(4),
        //       alignment: Alignment.center,
        //       height: 18,
        //       width: 18,
        //       decoration: const BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Color(0xff093d52),
        //       ),
        //       child: const Icon(Icons.arrow_back,
        //           color: Colors.white, size: 14),
        //     ),
        //   ),*/
        //         ))
        // ,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderJobPage(
              isShow: true,
              provider: Provider.of<JobScheduleProvider>(context),
            ),
            const Expanded(
              flex: 2,
              child: TimeJobScheduleList(),
            ),
          ],
        ),
      ),
    );
  }
}
