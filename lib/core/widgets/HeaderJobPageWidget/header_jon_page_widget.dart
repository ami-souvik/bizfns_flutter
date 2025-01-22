import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/core/utils/fonts.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/JobScheduleModel/schedule_list_response_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../provider/job_schedule_controller.dart';
import '../../route/RouteConstants.dart';
import '../../utils/Utils.dart';
import '../../utils/route_function.dart';
import '../common_text.dart';
import 'package:sizing/sizing.dart';

class HeaderJobPage extends StatefulWidget {
  final bool isShow;

  final JobScheduleProvider provider;

  HeaderJobPage({Key? key, required this.isShow, required this.provider})
      : super(key: key);

  @override
  State<HeaderJobPage> createState() => _HeaderJobPageState();
}

class _HeaderJobPageState extends State<HeaderJobPage>
    with TickerProviderStateMixin {
  TabController? _tabController;

  ItemScrollController _controller = ItemScrollController();

  @override
  void initState() {
    //widget.provider.getDay();

    generateDates();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //auth = Provider.of<Auth>(context, listen: false);
      Provider.of<JobScheduleProvider>(context, listen: false).getDay();
    });

    //if (!mounted) {
    // Provider.of<JobScheduleProvider>(context, listen: false).getDay();
    //}

    /*_tabController =
        TabController(length: 7, vsync: this, animationDuration: Duration.zero);
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        print('click, ${_tabController!.index}');
      }
    });*/

    super.initState();

    widget.provider.dayCount = widget.provider.getDayCount();
  }

  onAcceptWithDetails(int value, ScheduleModel model) {}

  List<DateTime> dateList = [];

  int toDayIndex = 0;
  int selectedIndex = 0;

  generateDates() {
    dateList.clear();
    for (int index = 1000; index > 0; index--) {
      dateList.add(DateTime.now().subtract(Duration(days: index)));
    }
    for (int index = 0; index < 1000; index++) {
      dateList.add(DateTime.now().add(Duration(days: index)));
    }

    toDayIndex = dateList.indexWhere((element) =>
        DateFormat('dd-MMM-yyyy').format(element) ==
        DateFormat('dd-MMM-yyyy').format(DateTime.now()));

    selectedIndex = toDayIndex;

    String day =
        DateFormat('EEEE').format(dateList[toDayIndex]).substring(0, 3);

    toDayIndex = toDayIndex - getDayIndex(day);

    setState(() {});
  }

  int getDayIndex(String day) {
    switch (day) {
      case 'Sun':
        return 0;
      case 'Mon':
        return 1;
      case 'Tue':
        return 2;
      case 'Wed':
        return 3;
      case 'Thu':
        return 4;
      case 'Fri':
        return 5;
      case 'Sat':
        return 6;
      default:
        return 0;
    }
  }

  @override
  void didUpdateWidget(covariant HeaderJobPage oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      selectedIndex = selectedIndex +
          (Provider.of<JobScheduleProvider>(context, listen: false).swipeValue);

      String day =
          DateFormat('EEEE').format(dateList[selectedIndex]).substring(0, 3);

      toDayIndex = selectedIndex - getDayIndex(day);
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => _controller.jumpTo(index: toDayIndex));

    return Column(
      children: [
        const Gap(15),
        widget.isShow
            ? Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Schedule This",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    const Gap(5),
                    Container(
                      //width: 150,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onPressed: () {
                                selectedIndex = selectedIndex - 7;

                                String day = DateFormat('EEEE')
                                    .format(dateList[selectedIndex])
                                    .substring(0, 3);

                                int val = selectedIndex - getDayIndex(day);

                                Provider.of<JobScheduleProvider>(context,
                                            listen: false)
                                        .date =
                                    DateFormat('yyyy-MM-dd')
                                        .format(dateList[selectedIndex]);

                                Provider.of<JobScheduleProvider>(context,
                                        listen: false)
                                    .changeData(DateFormat('yyyy-MM-dd')
                                        .format(dateList[selectedIndex]));

                                Provider.of<JobScheduleProvider>(context,
                                        listen: false)
                                    .getScheduleList(context);

                                toDayIndex = val;

                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 14,
                                color: Colors.black,
                              )),
                          const Text(
                            "Week",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onPressed: () {
                                //todo: load next week

                                selectedIndex = selectedIndex + 7;

                                print(
                                    'Selected Index: $selectedIndex ${dateList[selectedIndex]} ${DateFormat('yyyy-MM-dd').format(dateList[selectedIndex])}');

                                String day = DateFormat('EEEE')
                                    .format(dateList[selectedIndex])
                                    .substring(0, 3);

                                int val = selectedIndex - getDayIndex(day);

                                Provider.of<JobScheduleProvider>(context,
                                            listen: false)
                                        .date =
                                    DateFormat('yyyy-MM-dd')
                                        .format(dateList[selectedIndex]);

                                Provider.of<JobScheduleProvider>(context,
                                        listen: false)
                                    .changeData(DateFormat('yyyy-MM-dd')
                                        .format(dateList[selectedIndex]));

                                Provider.of<JobScheduleProvider>(context,
                                        listen: false)
                                    .getScheduleList(context);

                                toDayIndex = val;

                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ),
                    const Gap(5),
                    GestureDetector(
                      onTap: () {
                        // context.go(Routes.DATE_SELECT);

                        /*GoRouter.of(context)
                            .pushNamed('date-select')
                            .then((value) => {
                                  Utils().printMessage('Received: $value'),
                                  widget.provider
                                      .changeDay(value.toString().trim()),
                                  Utils().printMessage(
                                      'Day: ${widget.provider.day} Day Count: ${widget.provider.dayCount}'),
                                  setState(() {})
                                });*/

                        GoRouter.of(context)
                            .pushNamed('date-select')
                            .then((value) {
                          int valueIndex = dateList.indexWhere((element) =>
                              DateFormat('dd-MMM-yyyy').format(element) ==
                              DateFormat('dd-MMM-yyyy')
                                  .format(value as DateTime));

                          String day = DateFormat('EEEE')
                              .format(dateList[valueIndex])
                              .substring(0, 3);

                          selectedIndex = valueIndex;

                          toDayIndex = valueIndex - getDayIndex(day);

                          setState(() {});
                        });
                      },
                      child: Container(
                        //width: 150,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                "Month",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 6),
                                child: Container(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              //const Gap(6),
                              const Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: Color(0xff093d52),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        )
            : Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Schedule This",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    const Gap(5),
                    Container(
                      //width: 150,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "Month",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 4),
                              child: Container(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            //const Gap(6),
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Color(0xff093d52),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Gap(5),
                    GestureDetector(
                      onTap: () {
                        //GoRouter.of(context).pop();
                        //GoRouter.of(context).pushNamed('/home/schedule');
                        //context.go(SCHEDULE_PAGE);
                      },
                      child: Container(
                        //width: 150,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 14,
                                  color: Colors.black,
                                )),
                            const Text(
                              "Week",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        // const Gap(20),
        widget.isShow
            ? widget.provider.dates.isEmpty
                ? const SizedBox(
                    height: 20,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: 40,
                      child: ScrollablePositionedList.builder(
                        itemScrollController: _controller,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: DragTarget<ScheduleModel>(
                            builder: (BuildContext context,
                                List<ScheduleModel?> candidateData,
                                List<dynamic> rejectedData) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });

                                  Provider.of<JobScheduleProvider>(context,
                                              listen: false)
                                          .date =
                                      DateFormat('yyyy-MM-dd')
                                          .format(dateList[index]);

                                  Provider.of<JobScheduleProvider>(context,
                                          listen: false)
                                      .changeData(DateFormat('yyyy-MM-dd')
                                          .format(dateList[index]));

                                  Provider.of<JobScheduleProvider>(context,
                                          listen: false)
                                      .getScheduleList(context);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 8.4,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    color: DateFormat('dd-MMM-yyyy')
                                                .format(dateList[index]) ==
                                            DateFormat('dd-MMM-yyyy')
                                                .format(DateTime.now())
                                        ? Colors.grey
                                        : selectedIndex == index
                                            ? AppColor.APP_BAR_COLOUR
                                            : Colors.white,
                                  ),
                                  child: Center(
                                    child: WeekDateText(
                                      text: DateFormat('EEEE')
                                          .format(dateList[index])
                                          .substring(0, 3),
                                      date: DateFormat('dd\nMMM')
                                          .format(dateList[index]),
                                      textStyle: CustomTextStyle(
                                        fontSize: 9.fss,
                                        fontWeight: FontWeight.w700,
                                        color: DateFormat('dd-MMM-yyyy')
                                                    .format(dateList[index]) ==
                                                DateFormat('dd-MMM-yyyy')
                                                    .format(DateTime.now())
                                            ? Colors.white
                                            : selectedIndex == index
                                                ? Colors.white
                                                : Colors.grey.shade700,
                                      ),
                                      isSelected: DateFormat('dd-MMM-yyyy')
                                                  .format(dateList[index]) ==
                                              DateFormat('dd-MMM-yyyy')
                                                  .format(DateTime.now()) ||
                                          selectedIndex == index,
                                    ),
                                  ),
                                ),
                              );
                            },
                            onAcceptWithDetails: (details) async {
                              print(
                                  'Value: $index job ID: ${details.data.pKJOBID}');

                              selectedIndex = index;

                              setState(() {});
                            },
                          ),
                        ),
                        itemCount: dateList.length,
                      ),
                    ),
                  )
            : Container(),
      ],
    );
  }

  String getDay(int val) {
    return val == 0
        ? "Sun"
        : val == 1
            ? "Mon"
            : val == 2
                ? "Tue"
                : val == 3
                    ? "Wed"
                    : val == 4
                        ? "Thu"
                        : val == 5
                            ? "Fri"
                            : "Sat";
  }
}
