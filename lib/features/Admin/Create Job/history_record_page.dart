import 'package:bizfns/core/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/api_constants.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_field.dart';
import '../../../provider/job_schedule_controller.dart';
import 'model/add_schedule_model.dart';

class HistoryRecordPage extends StatefulWidget {
  const HistoryRecordPage({Key? key}) : super(key: key);

  @override
  State<HistoryRecordPage> createState() => _HistoryRecordPageState();
}

class _HistoryRecordPageState extends State<HistoryRecordPage> {
  int _selectedTabIndex = 0;

  // final List<String> imageList = [
  //   "https://unsplash.com/photos/yC-Yzbqy7PY",
  //   "https://unsplash.com/photos/LNRyGwIJr5c",
  //   "https://unsplash.com/photos/N7XodRrbzS0",
  //   "https://unsplash.com/photos/N7XodRrbzS0"
  //       "https://unsplash.com/photos/N7XodRrbzS0"
  //       "https://unsplash.com/photos/N7XodRrbzS0"
  //   // Add more image paths or URLs as needed
  // ];
  AddScheduleModel? addScheduleModel = AddScheduleModel.addSchedule;
  @override
  void initState() {
    // print("incoming widget.customerId====>${widget.customerId}");
    // List<Map<String, dynamic>> arrayOfObjects = addScheduleModel!.customer!
    //     .map((e) => {"customerId": int.parse(e.customerId.toString())})
    //     .toList();
    // Provider.of<JobScheduleProvider>(context, listen: false)
    //     .getCustomerServiceHistory(
    //         customerId: arrayOfObjects, context: context);
    super.initState();
  }

  String formatTimestamp(int? timestamp) {
    // Convert the timestamp to a DateTime object
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp!);

    // Format the DateTime object into the desired format
    String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        color: Color(0xFFFFFF),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 55,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: AppColor.APP_BAR_COLOUR,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "History Records",
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
          Expanded(
            child: ListView.builder(
              itemCount:
                  Provider.of<JobScheduleProvider>(context, listen: false)
                      .historyList
                      .length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Container(
                    width: double.infinity,
                    child: Card(
                      borderOnForeground: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              width: 1, color: Colors.grey.shade300)),
                      // elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Date: ',
                                    style: TextStyle(
                                      // fontSize: 16,
                                      color: Colors.grey[600],
                                    )),
                                Text(
                                  '${(Provider.of<JobScheduleProvider>(context, listen: false).historyList[index].date)}', // Replace this with your date
                                  style: TextStyle(
                                    // fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Customer: ',
                                    style: TextStyle(
                                      // fontSize: 16,
                                      color: Colors.grey[600],
                                    )),
                                // Text(
                                //   "Demo Service1,Demo Service2,Demo Service3",
                                // ),
                                // ListView.builder(
                                //   itemCount:Provider.of<JobScheduleProvider>(context,
                                //           listen: false)
                                //       .allHistoryData.length ,
                                //   itemBuilder:(context, index) {
                                //     return
                                //   },
                                //   )
                                Text(
                                    Provider.of<JobScheduleProvider>(context,
                                            listen: false)
                                        .historyList[index]
                                        .customerName
                                        .toString(),
                                    style: TextStyle(
                                      // fontSize: 16,
                                      color: Colors.grey[600],
                                    ))
                                // Provider.of<JobScheduleProvider>(context, listen: false).allHistoryData.map((e) => e.)

                                // CustomDetailsField(
                                //     data:
                                //         ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Services: ',
                                    style: TextStyle(
                                      // fontSize: 16,
                                      color: Colors.grey[600],
                                    )),
                                // Text(
                                //   "Demo Service1,Demo Service2,Demo Service3",
                                // ),
                                // ListView.builder(
                                //   itemCount:Provider.of<JobScheduleProvider>(context,
                                //           listen: false)
                                //       .allHistoryData.length ,
                                //   itemBuilder:(context, index) {
                                //     return
                                //   },
                                //   )
                                Text(
                                    Provider.of<JobScheduleProvider>(context,
                                            listen: false)
                                        .historyList[index]
                                        .services!
                                        .map((e) => e)
                                        .join(','),
                                    style: TextStyle(
                                      // fontSize: 16,
                                      color: Colors.grey[600],
                                    ))
                                // Provider.of<JobScheduleProvider>(context, listen: false).allHistoryData.map((e) => e.)

                                // CustomDetailsField(
                                //     data:
                                //         ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Notes: ",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                Text(
                                  '${Provider.of<JobScheduleProvider>(context, listen: false).historyList[index].notes}', // Replace this with your date
                                  style: TextStyle(
                                    // fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            // const SizedBox(height: 8),
                            // GestureDetector(
                            //   onTap: () {
                            //     // Handle the click action
                            //   },
                            //   child: const Text(
                            //     'Click Here', // Replace this with your clickable link text
                            //     style: TextStyle(
                            //       fontSize: 16,
                            //       color: Colors.blue,
                            //       decoration: TextDecoration.underline,
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: Provider.of<JobScheduleProvider>(
                                      context,
                                      listen: false)
                                  .historyList[index]
                                  .images!
                                  .length, // Number of images
                              itemBuilder: (BuildContext context, int idx) {
                                // print(
                                //     "AllImages====>${Provider.of<JobScheduleProvider>(context, listen: false).allHistoryData[0].iMAGE![index]!}");
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Image.network(
                                                'http://182.156.196.67:8085/api/users/downloadMediafile/${Provider.of<JobScheduleProvider>(context, listen: false).historyList[index].images![idx]}'),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Image.network(
                                    '${Urls.MEDIA_URL}${Provider.of<JobScheduleProvider>(context, listen: false).historyList[index].images![idx]}', // Replace this with your image URL
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Placeholder();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
          // ListView.builder(itemBuilder:())
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //   child: DefaultTabController(
          //     length: 2,
          //     child: Column(
          //       children: [
          //         TabBar(
          //           indicator: BoxDecoration(
          //             borderRadius: BorderRadius.circular(8),
          //             color: const Color(0xFFCCEEF7),
          //           ),
          //           tabs: [
          //             Container(
          //               height: 30,
          //               padding: const EdgeInsets.symmetric(
          //                   horizontal: 10),
          //               alignment: Alignment.center,
          //               child: Text(
          //                 "History Records",
          //                 style: TextStyle(color: Colors.black),
          //               ),
          //             ),
          //             Container(
          //               height: 30,
          //               padding: const EdgeInsets.symmetric(
          //                   horizontal: 10),
          //               alignment: Alignment.center,
          //               child: Text(
          //                 "Images",
          //                 style: TextStyle(color: Colors.black),
          //               ),
          //             ),
          //           ],
          //           onTap: (index) {
          //             setState(() {
          //               _selectedTabIndex = index;
          //             });
          //           },
          //         ),
          //         SizedBox(
          //           height: 8,
          //         ),
          //         _selectedTabIndex == 0
          //             ? Container(
          //           child: Center(
          //             child: Text(
          //               "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          //               style: TextStyle(fontSize: 14.0),
          //             ),
          //           ),
          //         )
          //             : Container(
          //           // Content for "Demo 2" tab
          //           color: Colors.grey[300],
          //           child: Center(
          //             child: Text(
          //               "Demo 2",
          //               style: TextStyle(fontSize: 24.0),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
