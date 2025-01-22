import 'dart:math';

import 'package:bizfns/provider/job_schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../../core/utils/colour_constants.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';

class WorkingHourWidget extends StatefulWidget {
  final ValueChanged<List<String>> onChanged;

  const WorkingHourWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<WorkingHourWidget> createState() => _WorkingHourWidgetState();
}

class _WorkingHourWidgetState extends State<WorkingHourWidget> {
  var startDate = DateTime.now();
  var endDate = DateTime.now();

  ///todo: if it is not set default will be 8 to 5
  ///
  /// todo: if set then need to fetch API
  String? startTime;
  String? endTime;

  bool startTimeChanged = false;
  bool endTimeChanged = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var controller = context.watch<JobScheduleProvider>();

    return Container(
      height: size.height / 3.4, //1.6
      width: size.width / 1.2,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        color: Colors.grey.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 55,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              color: AppColor.APP_BAR_COLOUR,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Working Hours",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.clear_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Gap(10),
          // Gap(10.ss),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                  text: TextSpan(
                      text: 'New changes will be applicable \nfrom ',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      children: [
                    TextSpan(
                        text: DateFormat('dd MMM, yyyy').format(
                            DateTime.now().add(const Duration(days: 1))),
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColor.APP_BAR_COLOUR,
                            fontWeight: FontWeight.bold))
                  ]))),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(
                          color: AppColor.APP_BAR_COLOUR,
                        ),
                      ),
                      height: 45,
                      width: size.width / 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.schedule,
                              color: Colors.grey,
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            const Text(
                              '|',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Text(
                              startTime ??
                                  controller
                                      .workingHoursResponseModel!.data!.start!,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      await _selectStartTime(context);
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      await _selectEndTime(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          border: Border.all(
                            color: AppColor.APP_BAR_COLOUR,
                          )),
                      height: 45,
                      width: size.width / 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.schedule,
                              color: Colors.grey,
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            const Text(
                              '|',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Text(
                              endTime ??
                                  controller
                                      .workingHoursResponseModel!.data!.end!,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(15),
          GestureDetector(
            onTap: () {
              // call save job api
            },
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: InkWell(
                  onTap: (startTimeChanged || endTimeChanged)
                      ? () {
                          print(
                              'Time: $startTime ${controller.workingHoursResponseModel!.data!.end!}');

                          if (startTime == null && endTime != null) {
                            widget.onChanged([
                              getPostFormat(controller
                                  .workingHoursResponseModel!.data!.start!),
                              getPostFormat(endTime!),
                            ]);
                          } else if (startTime != null && endTime == null) {
                            widget.onChanged([
                              getPostFormat(startTime!),
                              getPostFormat(controller.workingHoursResponseModel!.data!.end!),
                            ]);
                          } else if (startTime != null && endTime != null) {
                            widget.onChanged([
                              getPostFormat(startTime!),
                              getPostFormat(endTime!),
                            ]);
                          }
                          context.pop();
                        }
                      : null,
                  child: CustomButton(
                    btnColor: (startTimeChanged || endTimeChanged)
                        ? AppColor.APP_BAR_COLOUR
                        : Colors.grey,
                    title: 'Save',
                  ),
                ),
              ),
            ),
          ),
          Gap(5.ss),
        ],
      ),
    );
  }

  String getPostFormat(String time){
    String hour = time.split(":")[0];
    String minute = time.split(":")[1].replaceAll(RegExp(r'[^0-9]'), '');

    if(time.contains('P')){
      hour = (int.parse(hour) + 12).toString();
    }
    return '$hour:$minute:00';
  }

  Future<void> _selectStartTime(BuildContext context) async {
    var controller = context.read<JobScheduleProvider>();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      builder: (context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
      initialTime: TimeOfDay(
        hour: int.parse(startTime == null
                ? controller.workingHoursResponseModel!.data!.start!
                    .split(":")[0]
                : startTime!.split(':')[0]) +
            (startTime == null
                ? controller.workingHoursResponseModel!.data!.start!
                        .contains('P')
                    ? 12
                    : 0
                : startTime!.contains('P')
                    ? 12
                    : 0),
        minute: int.parse(startTime == null
            ? controller.workingHoursResponseModel!.data!.start!
                .split(":")[1]
                .replaceAll(RegExp(r'[^0-9]'), '')
            : startTime!.split(':')[1].replaceAll(RegExp(r'[^0-9]'), '')),
      ),
    );

    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final dt =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        final format = DateFormat.jm(); //"6:00 AM"

        startTime = format.format(dt);
        //     '${picked.hour < 10 ? '0${picked.hour}' : picked.hour} : 00';
        startTimeChanged =
            controller.workingHoursResponseModel!.data!.start! != startTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    var controller = context.read<JobScheduleProvider>();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      hourLabelText: 'Hour',
      minuteLabelText: 'Minute',
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(
        hour: int.parse(endTime == null
                ? controller.workingHoursResponseModel!.data!.end!.split(":")[0]
                : endTime!.split(':')[0]) +
            (endTime == null
                ? controller.workingHoursResponseModel!.data!.end!.contains('P')
                    ? 12
                    : 0
                : endTime!.contains('P')
                    ? 12
                    : 0),
        minute: int.parse(endTime == null
            ? controller.workingHoursResponseModel!.data!.end!
                .split(":")[1]
                .replaceAll(RegExp(r'[^0-9]'), '')
            : endTime!.split(':')[1].replaceAll(RegExp(r'[^0-9]'), '')),
      ),
      builder: (context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final dt =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        final format = DateFormat.jm(); //"6:00 AM"

        endTime = format.format(dt);

        endTimeChanged =
            controller.workingHoursResponseModel!.data!.end! != endTime;
      });
    }
  }

  Widget selectDate(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        //_selectDate(context, startDate);
      },
      child: Container(
          alignment: Alignment.center,
          height: 55,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: const Icon(
            Icons.calendar_month_outlined,
            color: Colors.black,
            size: 30,
          )),
    );
  }
}
