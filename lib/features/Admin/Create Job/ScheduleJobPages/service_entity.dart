import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/core/utils/Utils.dart';
import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/add_schedule_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/service_entity_question_answer_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/service_entity_question_model.dart';
import 'package:bizfns/provider/job_schedule_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/route/RouteConstants.dart';
import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/utils/route_function.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../Customer/provider/customer_provider.dart';
import 'widget/service_entity_group_widget.dart';
import 'widget/service_entity_widget.dart';

class ServiceEntityWidget extends StatefulWidget {
  final bool hasDetails;
  final String customerID;
  final String entityID;

  final ValueChanged onEntityAdd;

  final String? customerName;
  final String? phoneNumber;

  const ServiceEntityWidget(
      {Key? key,
      required this.hasDetails,
      required this.customerID,
      required this.entityID,
      required this.onEntityAdd,
      this.customerName,
      this.phoneNumber})
      : super(key: key);

  @override
  State<ServiceEntityWidget> createState() => _ServiceEntityWidgetState();
}

class _ServiceEntityWidgetState extends State<ServiceEntityWidget> {
  @override
  void initState() {
    print('ID in Service Entity ID: ${widget.entityID}');
    context.read<JobScheduleProvider>().serviceEntityItems.clear();
    if (widget.hasDetails) {
      print('if case');
      context.read<JobScheduleProvider>().getServiceEntityDetails(
            context,
            widget.customerID,
            widget.entityID,
          );
    } else {
      print('else case');
      context.read<JobScheduleProvider>().getServiceEntity(context);
    }
    Provider.of<TitleProvider>(context, listen: false).title =
        'Schedule New Modify';
    super.initState();
  }

  bool triggered = false;

  bool self = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var provider = context.watch<JobScheduleProvider>();

    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: Color.fromARGB(0, 88, 8, 8),
        ),
        height: size.height / 1.5,
        width: size.width,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    Expanded(
                      child: Text(
                        "Service Object ${Provider.of<JobScheduleProvider>(context).entityType}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
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
              const Gap(15),
              context.watch<JobScheduleProvider>().loading
                  ? const CircularProgressIndicator()
                  : context.watch<JobScheduleProvider>().serviceEntityStatus ==
                          1
                      ? Expanded(
                          child: ListView(
                            children: [
                              Offstage(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Self',style: TextStyle(
                                      fontSize: 18,
                                      color: AppColor.APP_BAR_COLOUR,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    CupertinoSwitch(
                                      value: self,
                                      onChanged: (val){
                                        if(val){
                                          var items =
                                              Provider.of<JobScheduleProvider>(
                                                  context,
                                                  listen: false)
                                                  .serviceEntityItems;
                                          var item1 = items.firstWhere(
                                                  (element) => element.typeId == 7);
                                          int indexOfItem1 = items.indexOf(item1);
                                          item1 = item1.copyWith(
                                            answer: widget.phoneNumber,
                                          );
                                          items.removeAt(indexOfItem1);
                                          items.insert(indexOfItem1, item1);

                                          var item2 = items.firstWhere((element) =>
                                              element.question!.contains('Name'));
                                          int indexOfItem2 = items.indexOf(item2);
                                          item2 = item2.copyWith(
                                            answer: widget.customerName,
                                          );
                                          items.removeAt(indexOfItem2);
                                          items.insert(indexOfItem2, item2);

                                          if (items.isNotEmpty) {
                                            provider.updateServiceEntity(items);
                                          }
                                        }else{
                                          var items =
                                              Provider.of<JobScheduleProvider>(
                                                  context,
                                                  listen: false)
                                                  .serviceEntityItems;
                                          var item1 = items.firstWhere(
                                                  (element) => element.typeId == 7);
                                          int indexOfItem1 = items.indexOf(item1);
                                          item1 = item1.copyWith(
                                            answer: '',
                                          );
                                          items.removeAt(indexOfItem1);
                                          items.insert(indexOfItem1, item1);

                                          var item2 = items.firstWhere((element) =>
                                              element.question!.contains('Name'));
                                          int indexOfItem2 = items.indexOf(item2);
                                          item2 = item2.copyWith(
                                            answer: '',
                                          );
                                          items.removeAt(indexOfItem2);
                                          items.insert(indexOfItem2, item2);

                                          if (items.isNotEmpty) {
                                            provider.updateServiceEntity(items);
                                          }
                                        }

                                        setState(() {
                                          self = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                offstage: widget.hasDetails,
                              ),
                              ...context
                                  .watch<JobScheduleProvider>()
                                  .serviceEntityItems
                                  .map((e) {
                                if (e.typeId == 11) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 3,
                                      right: 3,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: e.rowItems == null
                                        ? const SizedBox()
                                        : ServiceEntityGroupWidget(
                                            items: e.rowItems!,
                                          ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    child: e.question == null
                                        ? const SizedBox()
                                        : ServiceEntityItemWidget(
                                            key: ValueKey(e),
                                            items: e.items!,
                                            onAnswerAdd: (val) {
                                              e.answer = val;
                                              if (e.typeId == 7) {
                                                if (e.answer!.length >= 14) {
                                                  setState(() {});
                                                }
                                              } else {
                                                setState(() {});
                                              }
                                            },
                                            question: e.question!,
                                            typeID: e.typeId!,
                                            answer: e.answer,
                                          ),
                                  );
                                }
                              }).toList(),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: SizedBox(
                            child: Center(
                              child: Text(
                                  'Questions related to service object are not available'),
                            ),
                          ),
                        ),
              const SizedBox(
                height: 20,
              ),
              !context.watch<JobScheduleProvider>().loading
                  ? context.watch<JobScheduleProvider>().serviceEntityStatus ==
                          1
                      ? GestureDetector(
                          onTap: () {
                            if (Provider.of<CustomerProvider>(context,
                                    listen: false)
                                .loading) {
                              null;
                            } else {
                              // if (Provider.of<JobScheduleProvider>(context,
                              //         listen: false)
                              //     .serviceEntityItems![0]
                              //     .answer!
                              //     .isNotEmpty) {
                              List<Map<String, dynamic>> answerList = [];

                              List<ServiceEntityItems>? items =
                                  Provider.of<JobScheduleProvider>(context,
                                          listen: false)
                                      .serviceEntityItems;

                              answerList.clear();

                              for (int index = 0;
                                  index < items.length;
                                  index++) {
                                if (items[index].rowItems != null) {
                                  for (int rowIndex = 0;
                                      rowIndex < items[index].rowItems!.length;
                                      rowIndex++) {
                                    print(items[index]
                                        .rowItems![rowIndex]
                                        .rowQuestion);
                                    Map<String, dynamic> rowAnswer = {
                                      "question_id": items[index]
                                          .rowItems![rowIndex]
                                          .rowQuestionId,
                                      "question": items[index]
                                          .rowItems![rowIndex]
                                          .rowQuestion,
                                      "answer": items[index]
                                          .rowItems![rowIndex]
                                          .rowAnswer,
                                      "answer_type": items[index]
                                          .rowItems![rowIndex]
                                          .rowTypeId!
                                          .toString(),
                                    };

                                    print(rowAnswer);

                                    answerList.add(rowAnswer);

                                    setState(() {});
                                  }
                                } else {
                                  Map<String, dynamic> answer = {
                                    "question_id": items[index].questionId,
                                    "question": items[index].question,
                                    "answer": Provider.of<JobScheduleProvider>(
                                            context,
                                            listen: false)
                                        .serviceEntityItems[index]
                                        .answer,
                                    "answer_type":
                                        items[index].typeId.toString(),
                                  };

                                  answerList.add(answer);

                                  setState(() {});
                                }
                              }

                              Map<String, dynamic> map = {
                                "item": "",
                                "data": answerList
                                    .map((e) => {
                                          "question_id":
                                              e['question_id'].toString(),
                                          "question_name": e['question'],
                                          "answer": e['answer'],
                                          "answer_type_id": e['answer_type'],
                                        })
                                    .toList()
                              };

                              var data = jsonEncode(map);

                              log("service entity dataxxxxxxxxxx==>${jsonEncode(map)}");

                              //print(jsonEncode(map));

                              AddScheduleModel? model =
                                  AddScheduleModel.addSchedule;

                              /*model.serviceEntity =
                                ServiceEntityQuestionAnswerModel.fromJson(map)
                                    .data;*/
                              model.serviceEntity = map;

                              //print(map);

                              if (model.serviceEntity != null) {
                                //Navigator.pop(context);
                                widget.onEntityAdd(true);
                                /*Navigate.NavigateAndReplace(
                                      context, SCHEDULE_JOB);*/
                              }

                              //  else {
                              //   showCupertinoDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return CupertinoAlertDialog(
                              //         content: Center(
                              //           child: RichText(
                              //               text: const TextSpan(
                              //             children: [
                              //               TextSpan(
                              //                   text: 'Please Add ',
                              //                   style: TextStyle(
                              //                       color: Color(0xff093d52))),
                              //               TextSpan(
                              //                   text: 'Name',
                              //                   style:
                              //                       TextStyle(color: Colors.red))
                              //             ],
                              //           )),
                              //         ),
                              //         actions: [
                              //           CupertinoButton(
                              //             child: const Text("ok"),
                              //             onPressed: () {
                              //               context.pop();
                              //             },
                              //           )
                              //         ],
                              //       );
                              //     },
                              //   );
                              //   // showDialog(
                              //   //     context: context,
                              //   //     builder: (_) => const AlertDialog(
                              //   //           title: Text('Error'),
                              //   //           content: Text('Please enter name'),
                              //   //         ));
                              // }
                            }
                          },
                          child: const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50.0),
                              child: CustomButton(
                                title: 'Done',
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50.0),
                              child: CustomButton(
                                title: 'Go Back',
                              ),
                            ),
                          ),
                        )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
