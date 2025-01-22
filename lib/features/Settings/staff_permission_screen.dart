import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import 'package:bizfns/provider/job_schedule_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../easy_drop_down.dart';

class StaffPermissionScreen extends StatefulWidget {
  const StaffPermissionScreen({super.key});

  @override
  State<StaffPermissionScreen> createState() => _StaffPermissionScreenState();
}

class _StaffPermissionScreenState extends State<StaffPermissionScreen> {
  /*List<PrivilegeModel> type1 = List.generate(
    4,
    (index) => PrivilegeModel(
      title: 'Work Order ${index + 1}',
      privileges: List.generate(4, (index) => index % 2 == 0),
    ),
  );

  List<PrivilegeModel> type2 = List.generate(
    20,
    (index) => PrivilegeModel(
      title: 'Work Order ${index + 1}',
      privileges: List.generate(4, (index) => index % 2 == 0),
    ),
  );*/

  String? userType;
  String? user;

  String? phoneNumber;

  List<int> selectedIDs = [];

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<JobScheduleProvider>(context, listen: false)
          .privilegeResponseModel = null;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = context.watch<JobScheduleProvider>();

    return controller.userTypeResponseModel == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : controller.userTypeResponseModel!.data == null
            ? const Center(child: Text('No User Found'))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EasyDropDown(
                      value: userType,
                      hint: const Text('Select User Type'),
                      items: controller.userTypeResponseModel!.data!
                          .map((e) => e.userType!)
                          .toList(),
                      onChanged: (val) {
                        userType = val;
                        user = null;
                        controller.privilegeResponseModel = null;
                        setState(() {});
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EasyDropDown(
                      value: user,
                      hint: const Text('Select User'),
                      items: userType == null
                          ? []
                          : controller.userTypeResponseModel!.data!
                              .firstWhere(
                                  (element) => element.userType == userType!)
                              .users!
                              .map((e) => e.userName!)
                              .toList(),
                      onChanged: (val) async {
                        user = val;
                        phoneNumber = controller.userTypeResponseModel!.data!
                            .firstWhere(
                                (element) => element.userType == userType!)
                            .users!
                            .firstWhere((element) => element.userName == val)
                            .phoneNumber;
                        setState(() {});

                        await Provider.of<JobScheduleProvider>(context,
                                listen: false)
                            .getUserPrivilege(context,
                                phoneNumber: phoneNumber!);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  controller.privilegeResponseModel == null
                      ? SizedBox()
                      : Expanded(
                          flex: 2,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Container(
                                height: 50,
                                color: Colors.grey.withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            minWidth: 100, maxWidth: 100),
                                        child: const Text('Privilege Type'),
                                      ),
                                      Text('View All'),
                                      Text('View Own'),
                                      Text('Edit All'),
                                      Text('Edit Own'),
                                    ],
                                  ),
                                ),
                              ),
                              if (controller.privilegeResponseModel!.data!
                                      .firstWhere(
                                          (element) => element.type == 1)
                                      .privilegeList !=
                                  null) ...{
                                ...controller.privilegeResponseModel!.data!
                                    .firstWhere((element) => element.type == 1)
                                    .privilegeList!
                                    .map((e) => SizedBox(
                                          height: 40,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 100,
                                                          maxWidth: 100),
                                                  child: Text(e.title ?? ""),
                                                ),
                                                ...e.privilege!
                                                    .map((e1) => Checkbox(
                                                          value:
                                                              e1.value ?? false,
                                                          activeColor:
                                                              Colors.green[400],
                                                          onChanged: (val) {},
                                                        ))
                                                    .toList(),
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              },
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 50,
                                color: Colors.grey.withOpacity(0.3),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                            minWidth: 100, maxWidth: 100),
                                        child: const Text('Privilege Type'),
                                      ),
                                      Text('View'),
                                      Text('Add'),
                                      Text('Edit'),
                                      Text('Delete'),
                                    ],
                                  ),
                                ),
                              ),
                              if (controller.privilegeResponseModel!.data!
                                      .firstWhere(
                                          (element) => element.type == 2)
                                      .privilegeList !=
                                  null) ...{
                                ...controller.privilegeResponseModel!.data!
                                    .firstWhere((element) => element.type == 2)
                                    .privilegeList!
                                    .map((e) => SizedBox(
                                          height: 40,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minWidth: 100,
                                                          maxWidth: 100),
                                                  child: Text(e.title ?? ""),
                                                ),
                                                ...e.privilege!
                                                    .map((e1) => Checkbox(
                                                          value:
                                                              e1.value ?? false,
                                                          activeColor:
                                                              Colors.green[400],
                                                          onChanged: (val) {
                                                            e1.value = val;

                                                            if (val == true) {
                                                              selectedIDs
                                                                  .add(e1.id!);
                                                            } else {
                                                              selectedIDs
                                                                  .remove(
                                                                      e1.id!);
                                                            }

                                                            setState(() {});
                                                          },
                                                        ))
                                                    .toList(),
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              },
                            ],
                          ),
                        ),
                  Offstage(
                    offstage: controller.privilegeResponseModel == null,
                    child: InkWell(
                      onTap: () async {
                        if (selectedIDs.isNotEmpty) {
                          await controller.addUserPrivilege(context,
                              privileges: selectedIDs.join(','),
                              type: userType!,
                              phoneNumber: phoneNumber!);
                        }
                      },
                      child: CustomButton(
                        btnColor: selectedIDs.isEmpty
                            ? Colors.grey
                            : AppColor.APP_BAR_COLOUR,
                        title: 'Submit',
                      ),
                    ),
                  )
                ],
              );
  }
}

class PrivilegeModel {
  final String title;
  final List<bool> privileges;

  PrivilegeModel({
    required this.title,
    required this.privileges,
  });
}

Map<String, dynamic> privilegeList = {
  "data": [
    {
      "type": 1,
      "list": [
        {
          "title": "Schedule",
          "privilege": [
            {
              "id": "001",
              "type": "View All",
              "value": true,
            }
          ],
        },
        {
          "title": "Work Order",
          "privilege": [
            {
              "id": "002",
              "type": "View Own",
              "value": true,
            }
          ],
        }
      ]
    },
    {
      "type": 2,
      "list": [
        {
          "title": "Service",
          "privilege": [
            {
              "id": "003",
              "type": "View",
              "value": true,
            }
          ],
        },
        {
          "title": "Customer",
          "privilege": [
            {
              "id": "004",
              "type": "Add",
              "value": true,
            }
          ],
        }
      ]
    }
  ]
};
