import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bizfns/core/utils/route_function.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/add_schedule_model.dart';
import 'package:bizfns/provider/job_schedule_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/route/RouteConstants.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../../core/utils/colour_constants.dart';
import '../../../../core/utils/image_controller.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_field.dart';
import '../../../../core/widgets/common_text.dart';
import '../api-client/schedule_api_client_implementation.dart';
import '../model/JobScheduleModel/schedule_list_response_model.dart';

class Preview extends StatefulWidget {
  // final int timeIndex;
  // final int jobIndex;
  const Preview({
    Key? key,
    //  required this.timeIndex,
    //   required this.jobIndex
  }) : super(key: key);

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  AddScheduleModel model = AddScheduleModel.addSchedule;
  bool isImageLoading = false;

  @override
  Widget build(BuildContext context) {
    print("model.customer=====================>${model.customer}");
    print("write notes -===>${model.note.toString()}");
    // print("timeIndex======>${widget.timeIndex}");
    // print("jobIndex======>${widget.jobIndex}");
    return model.serviceList == null
        ? const SizedBox()
        : Provider.of<JobScheduleProvider>(context, listen: false).loading ==
                true
            ? Center(child: CircularProgressIndicator())
            : isImageLoading == true
                ? Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: Scaffold(
                    backgroundColor: Color(0xFFFFFF),
                    // appBar: AppBar(
                    //     backgroundColor: AppColor.APP_BAR_COLOUR,
                    //     elevation: 0,
                    //     centerTitle: true,
                    //     title: CommonText(
                    //       text: "Schedule New - Modify",
                    //       textStyle: TextStyle(color: Colors.white),
                    //     )
                    //     // const Text(
                    //     //   "Schedule New - Modify",
                    //     //   style: TextStyle(color: Colors.black, fontSize: 16),
                    //     // )
                    //     ,
                    //     leading: GestureDetector(
                    //       onTap: () {
                    //         // Navigator.pop(context);
                    //         //context.go(SCHEDULE_PAGE);
                    //         // Fluttertoast.showToast(msg: "back");
                    //         //Navigate.NavigateAndReplace(context, SCHEDULE_PAGE);
                    //         context.pop();
                    //       },
                    //       child: const Padding(
                    //           padding: EdgeInsets.all(15.0),
                    //           child: Icon(
                    //             Icons.arrow_back,
                    //             color: Colors.white,
                    //           )),
                    //     ))
                    // ,
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text("  Status: "),
                                            model.jobStatus != null
                                                ? model.jobStatus == 0
                                                    ? const Text("OPEN")
                                                    : model.jobStatus == 1
                                                        ? const Text(
                                                            "COMPLETED")
                                                        : const Text("")
                                                : const Text("")
                                          ],
                                        )),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        child: const Text("Invoice No")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(25),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Starting:",
                                        style: TextStyle(
                                            color: Color(0xFF00ACD8),
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const Gap(10),
                                      Text(
                                        model.startDate!.split(' ')[0],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.watch_later_outlined,
                                        color: Color(0xFF00ACD8),
                                        size: 24,
                                      ),
                                      const Gap(10),
                                      Text(
                                        "${getTimeFormat(model.startTime!)}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(15),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Ending:",
                                        style: TextStyle(
                                            color: Color(0xFF00ACD8),
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      const Gap(17),
                                      Text(
                                        model.endDate!.split(' ')[0],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.watch_later_outlined,
                                        color: Color(0xFF00ACD8),
                                        size: 24,
                                      ),
                                      const Gap(10),
                                      Text(
                                        "${getTimeFormat(model.endTime!)}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Customer-",
                                  style: TextStyle(
                                      color: Color(0xFF00ACD8),
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    spacing: 2,
                                    runSpacing: 10,
                                    runAlignment: WrapAlignment.start,
                                    children: [
                                      if (model.customer != null)
                                        ...model.customer!
                                            .map((e) => Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.start,
                                                  // crossAxisAlignment:
                                                  //     CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 30,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color:
                                                                Colors.white),
                                                        child: Text(
                                                          '${e.customerName.toString()} - ${e.serviceEntityName!.map((e) => e.toString()).join(',')}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ),
                                                    // const SizedBox(
                                                    //   width: 10,
                                                    // ),
                                                  ],
                                                ))
                                            .toList(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 16),
                          //   child: Row(
                          //     children: [
                          //       Wrap(
                          //         direction: Axis.horizontal,
                          //         alignment: WrapAlignment.start,
                          //         crossAxisAlignment: WrapCrossAlignment.start,
                          //         spacing: 2,
                          //         runSpacing: 10,
                          //         runAlignment: WrapAlignment.start,
                          //         children: [
                          //           const Text(
                          //             "Customer-",
                          //             style: TextStyle(
                          //                 color: Color(0xFF00ACD8),
                          //                 fontSize: 16,
                          //                 fontWeight: FontWeight.normal),
                          //           ),
                          //           const SizedBox(
                          //             width: 10,
                          //           ),
                          //           model.customer != null
                          //               ? CustomDetailsField(
                          //                   data: List.generate(
                          //                       model!.customer!.length, (index) {
                          //                     print(
                          //                         "service entitiy name ===========>${model!.customer![index].serviceEntityName.toString()!}");
                          //                     return '${model!.customer![index].customerName}: ${model!.customer![index].serviceEntityName!.join(', ')}';
                          //                   }).join('\n'),
                          //                 )
                          //               : const SizedBox(),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const Gap(25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Service -    ",
                                  style: TextStyle(
                                      color: Color(0xFF00ACD8),
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    spacing: 2,
                                    runSpacing: 10,
                                    runAlignment: WrapAlignment.start,
                                    children: [
                                      ...model.serviceList!
                                          .map((e) => Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: Colors.white),
                                                    child: Text(
                                                      e.serviceName!
                                                          .toString()
                                                          .capitalizeFirst!,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ))
                                          .toList(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Locaiton -",
                                  style: TextStyle(
                                      color: Color(0xFF00ACD8),
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                model.location != null &&
                                        model.location.toString().isNotEmpty
                                    ? model.location.toString().length >= 30
                                        ? Expanded(
                                            flex: 2,
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                alignment: Alignment.centerLeft,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white),
                                                child: Text(model.location
                                                    .toString()
                                                    .capitalizeFirst!)),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.all(10),
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white),
                                            child: Text(model.location
                                                .toString()
                                                .capitalizeFirst!))
                                    : const Text(''),
                              ],
                            ),
                          ),
                          const Gap(25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Staff-         ",
                                  style: TextStyle(
                                      color: Color(0xFF00ACD8),
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    spacing: 2,
                                    runSpacing: 10,
                                    runAlignment: WrapAlignment.start,
                                    children: [
                                      if (model.staffList != null)
                                        ...model.staffList!
                                            .map((e) => Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.white),
                                                      child: Text(
                                                        e.staffName,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ))
                                            .toList(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Material-  ",
                                  style: TextStyle(
                                      color: Color(0xFF00ACD8),
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    spacing: 2,
                                    runSpacing: 10,
                                    runAlignment: WrapAlignment.start,
                                    children: [
                                      if (model.materialList != null)
                                        ...model.materialList!
                                            .map((e) => Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.white),
                                                      child: Text(
                                                        e.materialName!
                                                            .toString()
                                                            .capitalizeFirst!,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ))
                                            .toList(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(25),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: const [
                                  Text(
                                    "History Records -",
                                    style: TextStyle(
                                        color: Color(0xFF00ACD8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Gap(10),
                                ],
                              )),
                          const Gap(25),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Write Notes - ",
                                    style: TextStyle(
                                        color: Color(0xFF00ACD8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  model.note != null || model.note!.isNotEmpty
                                      ? model.note.toString().length >= 30
                                          ? Expanded(
                                              flex: 2,
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.white),
                                                  child:
                                                      Text(model.note ?? '')),
                                            )
                                          : model.note.toString().length >= 55
                                              ? Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.white),
                                                      child: Text(
                                                          '${model.note!.substring(0, 50)}...')),
                                                )
                                              : model.note!.isNotEmpty &&
                                                      model.note != "null"
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.white),
                                                      child: Text(
                                                          model.note ?? ''))
                                                  : const Text('')
                                      : SizedBox(),
                                  const Gap(10),
                                ],
                              )),
                          const Gap(25),
                          Visibility(
                            visible: Provider.of<JobScheduleProvider>(context)
                                    .isPaymentDone ==
                                true,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Payment Terms - ",
                                      style: TextStyle(
                                          color: Color(0xFF00ACD8),
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    // model.note != null
                                    //     ?
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                          padding: const EdgeInsets.all(10),
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${Provider.of<JobScheduleProvider>(context).selectedValue}, ',
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .black), // Adjust the color as needed
                                                ),
                                                const TextSpan(
                                                  text: ' ', // Add space here
                                                ),
                                                Provider.of<JobScheduleProvider>(
                                                                context)
                                                            .selectedValue ==
                                                        'PayLater'
                                                    ? const TextSpan(
                                                        text: 'Dur: ',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black), // Make "Dur" bold
                                                      )
                                                    : const TextSpan(text: ''),
                                                Provider.of<JobScheduleProvider>(
                                                                context)
                                                            .selectedValue ==
                                                        'PayLater'
                                                    ? TextSpan(
                                                        text:
                                                            '${Provider.of<JobScheduleProvider>(context).selectedPayLetterDurationValue}, ',
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .black), // Adjust the color as needed
                                                      )
                                                    : const TextSpan(text: ''),
                                                const TextSpan(
                                                  text: ' ', // Add space here
                                                ),
                                                const TextSpan(
                                                  text: 'Deposit: ',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black), // Make "Deposit" bold
                                                ),
                                                TextSpan(
                                                  text:
                                                      '\$${Provider.of<JobScheduleProvider>(context).depositAmount}',
                                                  style: const TextStyle(
                                                      color: Colors
                                                          .black), // Adjust the color as needed
                                                ),
                                              ],
                                            ),
                                          )),
                                    )
                                    // : Text('')
                                    ,
                                    const Gap(10),
                                  ],
                                )),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Images -    ",
                                      style: TextStyle(
                                          color: Color(0xFF00ACD8),
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    (AddScheduleModel.addSchedule.images !=
                                                null ||
                                            AddScheduleModel.addSchedule
                                                        .allImageList !=
                                                    null &&
                                                AddScheduleModel.addSchedule
                                                    .allImageList!.isNotEmpty)
                                        ? Expanded(
                                            child: SizedBox(
                                                height: 120,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [
                                                    if (AddScheduleModel
                                                            .addSchedule
                                                            .allImageList !=
                                                        null)
                                                      ...AddScheduleModel
                                                          .addSchedule
                                                          .allImageList!
                                                          .asMap()
                                                          .entries
                                                          .map(
                                                            (e) => Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return Dialog(
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context); // Close the dialog when tapped
                                                                          },
                                                                          child:
                                                                              Image.network(
                                                                            '${Urls.MEDIA_URL}${e.value.fILENAME!}',
                                                                            fit:
                                                                                BoxFit.contain, // Fit the image within the dialog
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: Image
                                                                    .network(
                                                                  // 'http://182.156.196.67:8085/api/users/downloadMediafile/${e.value.fILENAME!}',
                                                                  '${Urls.MEDIA_URL}${e.value.fILENAME!}',
                                                                  height: 100,
                                                                  width: 80,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                    if (AddScheduleModel
                                                            .addSchedule
                                                            .images !=
                                                        null)
                                                      ...AddScheduleModel
                                                          .addSchedule.images!
                                                          .asMap()
                                                          .entries
                                                          .map(
                                                            (e) => Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return Dialog(
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context); // Close the dialog when tapped
                                                                          },
                                                                          child:
                                                                              Image.file(
                                                                            File(
                                                                              e.value.path,
                                                                            ),
                                                                            // height:
                                                                            //     400,
                                                                            // width:
                                                                            //     80,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Image.file(
                                                                  File(
                                                                    e.value
                                                                        .path,
                                                                  ),
                                                                  height: 100,
                                                                  width: 80,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                  ],
                                                )))
                                        : SizedBox()

                                    // if (model.jobId == null)
                                    // Offstage(
                                    //   offstage: AddScheduleModel.addSchedule.images !=
                                    //           null &&
                                    //       AddScheduleModel
                                    //           .addSchedule.images!.isEmpty,
                                    //   child: SizedBox(
                                    //     width:
                                    //         MediaQuery.of(context).size.width - 120,
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.only(left: 12),
                                    //       child: AddScheduleModel
                                    //                   .addSchedule.images !=
                                    //               null
                                    //           ? SizedBox(
                                    //               height: 60,
                                    //               child: ListView(
                                    //                 shrinkWrap: true,
                                    //                 scrollDirection: Axis.horizontal,
                                    //                 children: [
                                    //                   ...AddScheduleModel
                                    //                       .addSchedule.images!
                                    //                       .map(
                                    //                         (e) => Padding(
                                    //                           padding:
                                    //                               const EdgeInsets
                                    //                                   .all(8.0),
                                    //                           child: Image.file(
                                    //                             File(
                                    //                               e.path,
                                    //                             ),
                                    //                             height: 100,
                                    //                             width: 80,
                                    //                             fit: BoxFit.fill,
                                    //                           ),
                                    //                         ),
                                    //                       )
                                    //                       .toList(),
                                    //                 ],
                                    //               ))
                                    //           : SizedBox(),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                                // Offstage(
                                //   offstage:
                                //       AddScheduleModel.addSchedule.images !=
                                //               null &&
                                //           AddScheduleModel
                                //               .addSchedule.images!.isEmpty,
                                //   child: SizedBox(
                                //     width:
                                //         MediaQuery.of(context).size.width - 120,
                                //     child: Padding(
                                //       padding: const EdgeInsets.only(left: 12),
                                //       child: AddScheduleModel
                                //                   .addSchedule.images !=
                                //               null
                                //           ? SizedBox(
                                //               height: 60,
                                //               child: ListView(
                                //                 shrinkWrap: true,
                                //                 scrollDirection:
                                //                     Axis.horizontal,
                                //                 children: [
                                //                   ...AddScheduleModel
                                //                       .addSchedule.images!
                                //                       .map(
                                //                         (e) => Padding(
                                //                           padding:
                                //                               const EdgeInsets
                                //                                   .all(8.0),
                                //                           child: Image.file(
                                //                             File(
                                //                               e.path,
                                //                             ),
                                //                             height: 100,
                                //                             width: 80,
                                //                             fit: BoxFit.fill,
                                //                           ),
                                //                         ),
                                //                       )
                                //                       .toList(),
                                //                 ],
                                //               ))
                                //           : SizedBox(),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                          // if (model!.allImageList != null)
                          //   Visibility(
                          //     visible: model!.allImageList!.isNotEmpty,
                          //     child: Padding(
                          //       padding: EdgeInsets.only(left: 12.0),
                          //       child: SizedBox(
                          //         height: 60,
                          //         width: 60,
                          //         child: ListView(
                          //           shrinkWrap: true,
                          //           scrollDirection: Axis.horizontal,
                          //           children: [
                          //             ...model!.allImageList!.map((e) => Padding(
                          //                   padding: EdgeInsets.symmetric(
                          //                       horizontal: 5.0),
                          //                   child: Image.network(
                          //                       'http://182.156.196.67:8085/api/users/downloadMediafile/$e'),
                          //                 ))
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          const Gap(25),
                          // Center(
                          //   child: TextButton(
                          //       onPressed: () async {
                          //         for (var i = 0; i < model.images!.length; i++) {
                          //           print('obj1');
                          //           await ScheduleAPIClientImpl()
                          //               .addImage(image: model.images![i]);
                          //         }
                          //       },
                          //       child: Text('Confirm your images')),
                          // ),
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () async {
                                        Provider.of<JobScheduleProvider>(
                                                context,
                                                listen: false)
                                            .clearAllPayment();
                                        List<String> deviceDetails =
                                            await Utils.getDeviceDetails();
                                        String? userId =
                                            await GlobalHandler.getUserId();
                                        String? companyId =
                                            await GlobalHandler.getCompanyId();

                                        Map<String, dynamic> data =
                                            model.toJson(
                                          deviceDetails,
                                          userId,
                                          companyId,
                                        );

                                        var body = jsonEncode(data);
                                        //--------------------------here we are adding schedule-------------------//
                                        if (model.isAdding) {
                                          setState(() {
                                            isImageLoading = true;
                                          });
                                          if (model.images != null) {
                                            if (model.images!.isNotEmpty) {
                                              await ScheduleAPIClientImpl()
                                                  .addImage(
                                                      image: model.images!);
                                            }
                                          }
                                          setState(() {
                                            isImageLoading = false;
                                          });
                                          print(
                                              "addScheduleJson===>${model.toJson(
                                            deviceDetails,
                                            userId,
                                            companyId,
                                          )}");
                                          await Provider.of<
                                                      JobScheduleProvider>(
                                                  context,
                                                  listen: false)
                                              .addSchedule(
                                                  context,
                                                  model.toJson(
                                                    deviceDetails,
                                                    userId,
                                                    companyId,
                                                  ));
                                          // ignore: use_build_context_synchronously

                                          setState(() {});
                                          model!.isEdit = false;
                                          model!.isEdit = false;

                                          setState(() {});
                                          //------------------adding schedule end----------------------//
                                        } else {
                                          //------------------editing schedule start------------------//
                                          setState(() {
                                            isImageLoading = true;
                                          });
                                          // for (var i = 0;
                                          //     i < model!.allImageList!.length;
                                          //     i++) {
                                          //   log("mainImageList data---->${model!.allImageList![i].iMAGEID}");
                                          // }

                                          // for (var i = 0;
                                          //     i < model!.copyImages!.length;
                                          //     i++) {
                                          //   log("copyImage data---->${model!.copyImages![i].iMAGEID}");
                                          // }

                                          List<String> copyImages = model
                                              .copyImages!
                                              .map((e) => e.iMAGEID!)
                                              .toList();

                                          List<String> allImages = model
                                              .allImageList!
                                              .map((e) => e.iMAGEID!)
                                              .toList();

                                          List res = model.allImageList!.isEmpty
                                              ? copyImages
                                              : copyImages
                                                  .where((element) => !model
                                                      .allImageList!
                                                      .map((e) => e.iMAGEID)
                                                      .contains(element))
                                                  .toList();
                                          log('delete response---->${res.toSet().toList()}');

                                          // for (var i = 0;
                                          //     i < res.toSet().toList().length;
                                          //     i++) {
                                          //   log("xxxxxxxxx----->${res.toSet().toList()[i].toString()}");
                                          //   await ImageController()
                                          //       .deleteMedia(res
                                          //           .toSet()
                                          //           .toList()[i]
                                          //           .toString());
                                          // }

                                          //edit -------------------------------------
                                          //---------------adding-------------//

                                          if (model.images != null) {
                                            if (model.images!.isNotEmpty) {
                                              await ScheduleAPIClientImpl()
                                                  .addImage(
                                                      image: model.images!);
                                            }
                                          }

                                          if (model.imageId.isNotEmpty) {
                                            log("New image not emoty");
                                            copyImages.addAll(
                                                model.imageId.split(','));
                                          } else {
                                            log("new image empty");
                                          }

                                          List res1 =
                                              model.allImageList!.isEmpty
                                                  ? copyImages
                                                  : copyImages
                                                      .where((element) => model
                                                          .allImageList!
                                                          .map((e) => e.iMAGEID)
                                                          .contains(element))
                                                      .toList();

                                          // res1.add(model.imageId);

                                          log("editResult--------->${res1.toSet().toList()}");

                                          List<String> editList = [];
                                          res1
                                              .toSet()
                                              .toList()
                                              .forEach((element) {
                                            if (!editList.contains(element)) {
                                              editList.add(element);
                                            }
                                          });

                                          // model.imageId = editList.join(',');

                                          log("newEditList-------->${editList}");
                                          //-----------------------------------//

//   print(res);

                                          // List<String> allImageIds =
                                          //     model.imageId.split(',');
                                          // allImageIds.removeWhere((id) =>
                                          //     Provider.of<JobScheduleProvider>(
                                          //             context,
                                          //             listen: false)
                                          //         .temporaryImageIdList
                                          //         .contains(id));
                                          // // model.imageId;
                                          // model.imageId =
                                          //     allImageIds.join(',');
                                          // for (var i = 0;
                                          //     i <
                                          //         Provider.of<JobScheduleProvider>(
                                          //                 context,
                                          //                 listen: false)
                                          //             .temporaryPkMediaIdList
                                          //             .length;
                                          //     i++) {
                                          //   await ImageController()
                                          //       .deleteMedia(Provider.of<
                                          //                   JobScheduleProvider>(
                                          //               context,
                                          //               listen: false)
                                          //           .temporaryPkMediaIdList[i]
                                          //           .toString());
                                          // }
                                          // }

                                          setState(() {
                                            isImageLoading = false;
                                          });
                                          Map<String, dynamic> data =
                                              model.toJson(
                                            deviceDetails,
                                            userId,
                                            companyId,
                                          );

                                          log("editData----->${data}");

                                          //calling edit schedule function//
                                          await Provider.of<
                                                      JobScheduleProvider>(
                                                  context,
                                                  listen: false)
                                              .editSchedule(
                                                  context, data, model.jobId!);

                                          Provider.of<JobScheduleProvider>(
                                                  context,
                                                  listen: false)
                                              .changeEdit(false);
                                          model!.isEdit = false;
                                          setState(() {});
                                        }
                                      },
                                      child: const CustomButton(
                                        title: 'Save',
                                        btnColor: Colors.green,
                                      ))),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Provider.of<JobScheduleProvider>(
                                                context,
                                                listen: false)
                                            .changeEdit(true);
                                        context.pop();
                                      },
                                      child: const CustomButton(title: 'Edit')))
                            ],
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          //   child: Provider.of<JobScheduleProvider>(context).loading
                          //       ? const Center(
                          //           child: CircularProgressIndicator(
                          //             color: const Color(0xFF093E52),
                          //           ),
                          //         )
                          //       : AnimatedButton(
                          //           text:
                          //               model.isAdding ? 'Save' : 'Confirm and Submit',
                          //           color: const Color(0xFF093E52), //Colors.green,
                          //           pressEvent: () async {
                          //             List<String> deviceDetails =
                          //                 await Utils.getDeviceDetails();
                          //             String? userId = await GlobalHandler.getUserId();
                          //             String? companyId =
                          //                 await GlobalHandler.getCompanyId();

                          //             Map<String, dynamic> data = model.toJson(
                          //               deviceDetails,
                          //               userId,
                          //               companyId,
                          //             );

                          //             var body = jsonEncode(data);

                          //             print(body);

                          //             if (model.isAdding) {
                          //               setState(() {});
                          //               Provider.of<JobScheduleProvider>(context,
                          //                       listen: false)
                          //                   .addSchedule(context, data);
                          //               setState(() {});
                          //             } else {
                          //               Provider.of<JobScheduleProvider>(context,
                          //                       listen: false)
                          //                   .editSchedule(context, data, model.jobId!);
                          //               setState(() {});
                          //             }

                          //             /*AwesomeDialog(
                          //   context: context,
                          //   animType: AnimType.leftSlide,
                          //   headerAnimationLoop: false,
                          //   dialogType: DialogType.success,
                          //   showCloseIcon: true,
                          //   title: 'Success',

                          //   // desc: 'Dialog description here..................................................',
                          //   btnOkOnPress: () {
                          //     // Utils().printMessage('OnClick');
                          //     Future.delayed(
                          //       const Duration(milliseconds: 800),
                          //       () => context.go(home),
                          //     );
                          //   },
                          //   btnOkIcon: Icons.check_circle,
                          //   onDismissCallback: (type) {
                          //     Utils().printMessage('Dialog Dismiss from callback $type');
                          //   },
                          // ).show();*/
                          //           },
                          //         ),
                          // ),

                          /*GestureDetector(
              onTap: (){
                // Navigator.pop(context);

              },
              child: const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: CustomButton(title: 'Pay Now',),
                ),
              ),
            ),*/
                          const Gap(15),
                        ],
                      ),
                    ),
                  ));
  }

  getTimeFormat(String value) {
    // String time = value.split(" ")[0];

    // String hour = int.parse(time.split(":")[0]) > 12
    //     ? '${int.parse(time.split(":")[0]) - 12}'
    //     : time.split(":")[0];

    // String minute = time.split(":")[1];

    // String timeOfDay = int.parse(time.split(":")[0]) >= 12 ? "PM" : "AM";

    // String resHour = hour.length < 2 ? '0$hour' : hour;
    // String resMinute = minute.length < 2 ? '0$minute' : minute;

    // String resTime = '$resHour:$resMinute $timeOfDay';

    // return resTime;
    try {
      // Parse the time string using DateFormat
      DateTime parsedTime = DateFormat("hh:mm:ss a").parse(value);

      // Format the time to the desired output without seconds
      String formattedTime = DateFormat("hh:mm a").format(parsedTime);

      return formattedTime;
    } catch (e) {
      // Handle any parsing errors
      print('Error formatting time: $e');
      return value; // Return the original string if parsing fails
    }
  }
}
