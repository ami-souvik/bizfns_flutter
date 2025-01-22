import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bizfns/core/utils/fonts.dart';
import 'package:bizfns/core/utils/route_function.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/Admin/Staff/provider/staff_provider.dart';
import 'package:bizfns/features/Home/bizfins_share_widget.dart';
import 'package:bizfns/features/Settings/widget/max_job_task_widget.dart';
import 'package:bizfns/features/Settings/widget/reminder_widget.dart';
import 'package:bizfns/features/Settings/widget/time_interval_widget.dart';
import 'package:bizfns/features/Settings/widget/working_hour_widget.dart';
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
import '../../provider/job_schedule_controller.dart';
import '../Home/dashboard.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var controller = context.watch<JobScheduleProvider>();

    return Scaffold(
      body: Container(
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
                  InkWell(
                    child: SizedBox(
                      height: 80.ss,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14.ss, 12.ss, 14.ss, 0),
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
                                text: '  Working Hours',
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
                    onTap: () async {
                      await Provider.of<JobScheduleProvider>(context,
                              listen: false)
                          .getWorkingHours(
                              context: context,
                              isRedirect: false,
                              openDialogue: true);
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      await Provider.of<JobScheduleProvider>(context,
                              listen: false)
                          .getTimeInterval(
                              context: context,
                              isRedirect: false,
                              openDialogue: true);
                    },
                    child: SizedBox(
                      height: 80.ss,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14.ss, 12.ss, 14.ss, 0),
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
                                ),
                              ),
                              SizedBox(width: 8.ss),
                              CommonText(
                                text: '  Time Interval',
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
                  ),
                  InkWell(
                    onTap: () async{


                      Provider.of<JobScheduleProvider>(context, listen: false)
                          .reminderResponseModel = null;

                      await Provider.of<JobScheduleProvider>(context,
                          listen: false)
                          .getReminder(context,openDialogue: true);

                      GoRouter.of(context)
                          .pushNamed(
                        'reminder',
                      )
                          .then((value) {
                        Provider.of<TitleProvider>(context, listen: false)
                            .changeTitle('Settings');
                      });
                    },
                    child: SizedBox(
                      height: 80.ss,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14.ss, 12.ss, 14.ss, 0),
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
                                ),
                              ),
                              SizedBox(width: 8.ss),
                              CommonText(
                                text: '  Auto Reminders',
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
                  ),
                  InkWell(
                    onTap: () async {
                      Provider.of<JobScheduleProvider>(context, listen: false)
                          .privilegeResponseModel = null;

                      await Provider.of<JobScheduleProvider>(context,
                              listen: false)
                          .getUserType(context: context, isRedirect: false);

                      GoRouter.of(context)
                          .pushNamed(
                        'staff-permission',
                      )
                          .then((value) {
                        Provider.of<TitleProvider>(context, listen: false)
                            .changeTitle('Settings');
                      });
                    },
                    child: SizedBox(
                      height: 80.ss,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14.ss, 12.ss, 14.ss, 0),
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
                                ),
                              ),
                              SizedBox(width: 8.ss),
                              CommonText(
                                text: '  Staff Permissions',
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
                  ),
                  InkWell(
                    onTap: () async {
                      await Provider.of<JobScheduleProvider>(context,
                              listen: false)
                          .getMaxJobTask(
                              context: context,
                              isRedirect: false,
                              openDialogue: true);
                    },
                    child: SizedBox(
                      height: 80.ss,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14.ss, 12.ss, 14.ss, 0),
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
                                ),
                              ),
                              SizedBox(width: 8.ss),
                              CommonText(
                                text: '  Max jobs-Tasks',
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
                  ),
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                      height: 80.ss,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14.ss, 12.ss, 14.ss, 0),
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
                                ),
                              ),
                              SizedBox(width: 8.ss),
                              CommonText(
                                text: '  Templates',
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
                  ),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context)
                          .pushNamed('tax-setting')
                          .then((value) {
                        Provider.of<TitleProvider>(context, listen: false)
                            .changeTitle('Settings');
                      });
                    },
                    child: SizedBox(
                      height: 80.ss,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14.ss, 12.ss, 14.ss, 0),
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
                                ),
                              ),
                              SizedBox(width: 8.ss),
                              CommonText(
                                text: '  Tax Table',
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
                  ),
                  InkWell(
                    onTap: () {
                      context
                          .read<StaffProvider>()
                          .getStaffDetailsWhileStaffLogin(context: context);
                      // GoRouter.of(context)
                      //     .pushNamed('time-sheet')
                      //     .then((value) {
                      //   Provider.of<TitleProvider>(context, listen: false)
                      //       .changeTitle('Settings');
                      // });
                    },
                    child: SizedBox(
                      height: 80.ss,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14.ss, 12.ss, 14.ss, 0),
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
                                ),
                              ),
                              SizedBox(width: 8.ss),
                              CommonText(
                                text: '  Time Sheet Bill',
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
                  ),
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                      height: 80.ss,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(14.ss, 12.ss, 14.ss, 0),
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
                                ),
                              ),
                              SizedBox(width: 8.ss),
                              CommonText(
                                text: '  All User List',
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
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BizfinsShareWidget(),
          ],
        ),
      ),
    );
  }

  showMyDialog(String str, [String? time]) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child:
                StatefulBuilder(// You need this, notice the parameters below:
                    builder: (BuildContext context, StateSetter setState) {
              return str == "working-hours"
                  ? WorkingHourWidget(
                      onChanged: (val) async {
                        print('Val: $val');
                        await Provider.of<JobScheduleProvider>(context,
                                listen: false)
                            .addWorkingHours(
                          context,
                          startTime: val[0],
                          endTime: val[1],
                        );
                      },
                    )
                  : str == "time-interval"
                      ? TimeIntervalWidget(
                          onChanged: (val) async {
                            print('Val: $val');
                            await Provider.of<JobScheduleProvider>(context,
                                    listen: false)
                                .addTimeInterval(context,
                                    hour: val[0], minute: val[1]);
                          },
                        )
                      : str == "max-job-task"
                          ? MaxJobTaskWidget(
                              onChanged: (val) async {
                                await Provider.of<JobScheduleProvider>(context,
                                        listen: false)
                                    .addMaxJobTask(context, maxJob: val);
                              },
                            )
                          : str == "reminder"
                              ? ReminderWidget()
                              : Container();
            }));
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          // text=value;WriteNote
        });
      } else if (value is List) {
        //todo set working hours
        print(value.toString());
      } else if (value is Map<String, int?>) {
        if (value['interval'] == null) {
          //todo maxJob
        } else if (value['max_job'] == null) {
          //todo interval
        }
      }
    });
  }
}
