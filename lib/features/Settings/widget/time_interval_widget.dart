import 'package:bizfns/core/utils/Utils.dart';
import 'package:bizfns/provider/job_schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../../core/utils/colour_constants.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/common_text_form_field.dart';

class TimeIntervalWidget extends StatefulWidget {
  final ValueChanged<List<String>> onChanged;

  const TimeIntervalWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<TimeIntervalWidget> createState() => _TimeIntervalWidgetState();
}

class _TimeIntervalWidgetState extends State<TimeIntervalWidget> {
  ///todo: if it is not set default will be 1
  ///
  /// todo: if set then need to fetch API
  String? startTime; // = '01:00 Hrs';

  String? hour;
  String? min;

  bool hourChanged = false;
  bool minChanged = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var controller = context.watch<JobScheduleProvider>();

    return Container(
      height: size.height / 3, //1.6
      width: size.width / 1.2,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        color: Colors.grey.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // width: size.w,
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
                    "Time Interval",
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
                      //border: Border.all(color: Colors.white, width: 1.5),
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
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How long',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: Container(
                      height: 30,
                      width: size.width / 1.5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.schedule,
                              color: Colors.grey,
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
                            SizedBox(
                              width: 60,
                              child: TextFormField(
                                maxLength: 2,
                                initialValue: controller.timeInterval!.hour!,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enableInteractiveSelection: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    counterText: '',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)))),
                                onChanged: (val) {
                                  hour = val;
                                  if (controller.timeInterval!.hour! == val) {
                                    hourChanged = false;
                                  } else {
                                    hourChanged = true;
                                  }
                                  absorb(hour, min);
                                  setState(() {});
                                },
                              ),
                            ),
                            Text(' Hrs'),
                            const Spacer(
                              flex: 1,
                            ),
                            SizedBox(
                              width: 60,
                              child: TextFormField(
                                maxLength: 2,
                                initialValue: controller.timeInterval!.minute!,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                enableInteractiveSelection: false,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    counterText: '',

                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)))),
                                onChanged: (val) {
                                  min = val;
                                  if (controller.timeInterval!.minute == val) {
                                    minChanged = false;
                                  } else {
                                    minChanged = true;
                                  }
                                  absorb(hour, min);
                                  setState(() {});
                                },
                              ),
                            ),
                            Text(' Min'),
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
          controller.timeInterval == null
              ? SizedBox()
              : Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: InkWell(
                      child: CustomButton(
                        title: 'Save',
                        btnColor: (hourChanged || minChanged)
                            ? AppColor.APP_BAR_COLOUR
                            : Colors.grey,
                      ),
                      onTap: () {
                        if (hourChanged || minChanged) {
                          widget.onChanged([
                            hour ??
                                (controller.timeInterval == null
                                    ? "00"
                                    : controller.timeInterval!.hour!),
                            min ??
                                (controller.timeInterval == null
                                    ? "00"
                                    : controller.timeInterval!.minute!),
                          ]);
                        }
                        context.pop();
                      },
                    ),
                  ),
                ),
          Gap(10.ss),
        ],
      ),
    );
  }

  bool absorb(String? hour, String? minute) {
    int min = 0;

    print('Minute: $minute');

    min = int.parse(hour ?? '00') * 60 + int.parse(minute ?? "00");

    return min < 10 || min > 1440;
  }

  String getValue(int data) =>
      data.toString().length < 2 ? '0$data' : data.toString();
}
