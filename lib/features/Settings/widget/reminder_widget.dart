import 'dart:convert';

import 'package:bizfns/features/Admin/Create%20Job/api-client/schedule_api_client_implementation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis/binaryauthorization/v1.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../../core/utils/colour_constants.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../provider/job_schedule_controller.dart';

class ReminderWidget extends StatefulWidget {
  const ReminderWidget({super.key});

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  PostReminderModel postReminderModel = PostReminderModel();

  @override
  Widget build(BuildContext context) {
    var controller = context.watch<JobScheduleProvider>();

    return controller.reminderResponseModel == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : controller.reminderResponseModel!.data == null
            ? const Center(child: Text('No Data Found'))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Gap(10),
                    ...controller.reminderResponseModel!.data!.events!
                        .map((e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        e.eventName!,
                                        style: const TextStyle(
                                          color: AppColor.APP_BAR_COLOUR,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const Spacer(
                                      flex: 2,
                                    ),
                                    const Text(
                                      'SMS',
                                      style: TextStyle(
                                        color: AppColor.APP_BAR_COLOUR,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Text(
                                      'Push',
                                      style: TextStyle(
                                        color: AppColor.APP_BAR_COLOUR,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ...e.reminders!
                                    .map((e1) => Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  e1.reminder!,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[700]),
                                                ),
                                              ),
                                              const Spacer(
                                                flex: 2,
                                              ),
                                              Transform.scale(
                                                scale: 0.8,
                                                child: Checkbox(
                                                  value: e1.sms == true,
                                                  onChanged: (val) {
                                                    e1.sms = val ?? false;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              Transform.scale(
                                                scale: 0.8,
                                                child: Checkbox(
                                                  value: e1.push == true,
                                                  onChanged: (val) {
                                                    e1.push = val ?? false;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ))
                        .toList(),
                    const Gap(15),
                    Offstage(
                      offstage: controller.reminderResponseModel == null,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: InkWell(
                            onTap: () async {
                              postReminderModel.reminder =
                                  postReminderModel.reminder ?? [];

                              controller.reminderResponseModel!.data!.events!
                                  .forEach((element) {
                                element.reminders!.forEach((element) {
                                  postReminderModel.reminder!.add(element);
                                });
                              });

                              print(postReminderModel.toJson());

                              await controller.setReminder(
                                context,
                                reminder: postReminderModel.toJson(),
                              );
                            },
                            child: const CustomButton(
                              title: 'Save',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Gap(10.ss),
                  ],
                ),
              );
  }
}
