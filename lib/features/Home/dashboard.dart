import 'dart:developer';

import 'package:bizfns/core/utils/bizfns_layout_widget.dart';
import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/features/Home/documents.dart';
import 'package:bizfns/features/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';
import '../../core/widgets/common_text.dart';
import '../../provider/job_schedule_controller.dart';
import '../Admin/Create Job/model/add_schedule_model.dart';
import '../Admin/admin_page.dart';
import '../Settings/settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int bottomNavIndex = 0;

  @override
  void initState() {
    Provider.of<BottomNavigationProvider>(context, listen: false).getIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Length: ${context
            .watch<BottomNavigationProvider>()
            .routeIndexes
            .length - 1}');

    List<Widget> _widgetOptions = <Widget>[
      HomePage(),

      DocumentsScreen(),

      AdminPage(),
      // AccountPage(),
      SettingsPage(),
    ];
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            height: double.infinity,
            child: Center(
              child: _widgetOptions.elementAt(
                  context
                      .watch<BottomNavigationProvider>()
                      .routeIndexes
                      .last),
            )),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.black,
          selectedItemColor: AppColor.APP_BAR_COLOUR,
          currentIndex: context
              .watch<BottomNavigationProvider>()
              .routeIndexes
              .elementAt(context
              .watch<BottomNavigationProvider>()
              .routeIndexes
              .length -
              1),
          unselectedFontSize: 12,
          selectedFontSize: 14,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/bell 1.svg',
                  width: 25.ss,
                  color: bottomNavIndex == 0
                      ? AppColor.APP_BAR_COLOUR
                      : Colors.black,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/document.svg',
                  width: 25.ss,
                  color: bottomNavIndex == 1
                      ? AppColor.APP_BAR_COLOUR
                      : Colors.black,
                ),
                label: "Documents"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/document.svg',
                  width: 25.ss,
                  color: bottomNavIndex == 2
                      ? AppColor.APP_BAR_COLOUR
                      : Colors.black,
                ),
                label: "Admin"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/settings 1.svg',
                  width: 25.ss,
                  color: bottomNavIndex == 3
                      ? AppColor.APP_BAR_COLOUR
                      : Colors.black,
                ),
                label: "Settings"),
          ],
          onTap: (index) {
            if (index != 0) {
              Provider.of<BottomNavigationProvider>(context, listen: false)
                  .changeIndex(index);
            } else {
              Provider.of<BottomNavigationProvider>(context, listen: false)
                  .refreshIndex();
            }
            /*bottomNavIndex = index;
      setState(() {
      });*/
          },
        ));
  }
}

class BottomNavigationProvider extends ChangeNotifier {
  int bottomIndex = 0;

  List<int> routeIndexes = [];

  getIndex() {
    routeIndexes = [0];
    //notifyListeners();
  }

  changeIndex(int index) {
    bottomIndex = index;
    routeIndexes.add(index);
    routeIndexes.forEach((element) {
      print('index: $element');
    });
    notifyListeners();
  }

  refreshIndex() {
    bottomIndex = 0;
    routeIndexes.clear();
    routeIndexes.add(0);
    notifyListeners();
  }

  popIndex() {
    routeIndexes.removeLast();
    notifyListeners();
  }
}

class ScaffoldWithNestedNavigation extends StatefulWidget {
  ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNestedNavigation> createState() =>
      _ScaffoldWithNestedNavigationState();
}

class _ScaffoldWithNestedNavigationState
    extends State<ScaffoldWithNestedNavigation> {
  AddScheduleModel? addScheduleModel = AddScheduleModel.addSchedule;

  void _goBranch(int index) {
    if (!indexes.contains(index)) {
      indexes.add(index);
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    Provider.of<TitleProvider>(context, listen: false).changeTitle(index == 1
        ? "Documents"
        : index == 2
        ? "Admin"
        : index == 3
        ? "Settings"
        : "");
  }

  List<int> indexes = [0];

  void popBranch() {
    int index = widget.navigationShell.currentIndex;
    int val = indexes.removeLast();

    setState(() {});

    widget.navigationShell.goBranch(
      indexes.last,
      initialLocation: index == widget.navigationShell.currentIndex,
    );

    Provider.of<TitleProvider>(context, listen: false)
        .changeTitle(indexes.last == 1
        ? 'Documents'
        : indexes.last == 2
        ? 'Admin'
        : indexes.last == 3
        ? 'Settings'
        : '');
  }

  String getAppBarTitle(BuildContext context) {
    String routePath =
        GoRouter
            .of(context)
            .routerDelegate
            .currentConfiguration
            .fullPath;

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
    print("Getting key---->${key}");
    Map<String, String> titleMap = {
      'admin': 'Admin',
      'document': 'Document',
    };

    return titleMap[key] ?? '';
  }

  popUpFunc() async {
    //----------clearing recur value-----------//
    // Provider
    //     .of<JobScheduleProvider>(context, listen: false)
    //     .reccurrDateList
    //     .clear();
    // addScheduleModel!.duration = null;
    // addScheduleModel!.totalJobs = null;
    //-----------------------------------------//
    String appBarTitle = getAppBarTitle(context);
    // await Provider.of<JobScheduleProvider>(context, listen: false)
    //     .getScheduleList(context);
    Provider.of<TitleProvider>(context, listen: false).changeTitle(appBarTitle);

    try {
      print('In Dashboard App Bar');

      GoRouter.of(context).pop();
      // Navigator.pop(context);
    } catch (ex) {
      print("Ex------->${ex}");
      popBranch();
    }
  }

  previewPagePopUp() {
    GoRouter.of(context).pop();
    Provider.of<JobScheduleProvider>(context, listen: false).changeEdit(true);
  }

  // dashboardPagePopUp() {
  //   GoRouter.of(context).pop();
  //   Provider.of<TitleProvider>(context, listen: false).title = 'Dashboard';
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    print('Dashboard: ' +
        GoRouter
            .of(context)
            .routerDelegate
            .currentConfiguration
            .fullPath);
    print(GoRouter
        .of(context)
        .routerDelegate
        .currentConfiguration
        .fullPath
        .split('/')
        .length
        .toString());

    String path =
        GoRouter
            .of(context)
            .routerDelegate
            .currentConfiguration
            .fullPath;

    return Scaffold(
      appBar: /*widget.navigationShell.currentIndex == 0 ||
              GoRouter.of(context)
                      .routerDelegate
                      .currentConfiguration
                      .fullPath
                      .split('/')
                      .length >=
                  3
          ? PreferredSize(
              preferredSize: const Size.fromHeight(55),
              child: Container(
                height: 55,
                color: AppColor.APP_BAR_COLOUR,
              ),
            )
          :*/
      PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Provider
              .of<TitleProvider>(context, listen: false)
              .title
              .isEmpty
              ? const SizedBox(
            height: 27,
          )
              : BizfnsAppBar(
              onPop: (val) {
                print('On Pop Val:$val');

                print('Mode: ${Provider
                    .of<JobScheduleProvider>(context, listen: false)
                    .isEdit}');

                print('Job Status: ${addScheduleModel!.jobStatus}');

                /*I/flutter ( 6220): On Pop Val:true
                        I/flutter ( 6220): Mode: true
                        I/flutter ( 6220): Job Status: 0
                        I/flutter ( 6220): Calling Change Edit false*/

                /*I/flutter ( 6220): On Pop Val:true
                        I/flutter ( 6220): Mode: false
                        I/flutter ( 6220): Job Status: 0*/


                ///todo: check the route path
                ///todo: get the pre final element
                ///todo: that will be the title
                ///todo: need to match a appbar title with the route path
                if (Provider
                    .of<JobScheduleProvider>(context, listen: false)
                    .isEdit ==
                    true &&
                    addScheduleModel!.jobStatus != null) {
                  /*Provider.of<JobScheduleProvider>(context,
                      listen: false)
                      .changeEdit(false);*/
                  popUpFunc();
                }
                else if (Provider
                    .of<TitleProvider>(context, listen: false)
                    .title ==
                    'Schedule New-Modify') {
                  previewPagePopUp();
                } else {
                  popUpFunc();
                }
              },
              title: Provider
                  .of<TitleProvider>(context)
                  .title /*widget.navigationShell.currentIndex == 1
                      ? "Documents"
                      : widget.navigationShell.currentIndex == 2
                      ? "Admin"
                      : widget.navigationShell.currentIndex == 3
                      ? "Settings"
                      : "",*/
          )),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        height: 70.0,
        selectedIndex: widget.navigationShell.currentIndex,
        destinations: [
          NavigationDestination(
            label: "Home",
            icon: SvgPicture.asset(
              'assets/images/bell 1.svg',
              width: 25.ss,
              color: AppColor.APP_BAR_COLOUR,
            ),
          ),
          NavigationDestination(
            label: "Documents",
            icon: SvgPicture.asset(
              'assets/images/document.svg',
              width: 25.ss,
              color: AppColor.APP_BAR_COLOUR,
            ),
          ),
          NavigationDestination(
            label: "Admin",
            icon: SvgPicture.asset(
              'assets/images/user 1.svg',
              width: 25.ss,
              color: AppColor.APP_BAR_COLOUR,
            ),
          ),
          NavigationDestination(
            label: "Settings",
            icon: SvgPicture.asset(
              'assets/images/settings 1.svg',
              width: 25.ss,
              color: AppColor.APP_BAR_COLOUR,
            ),
          ),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
