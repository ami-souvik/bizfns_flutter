// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';

// import '../../../core/utils/colour_constants.dart';
// import 'history_record_page.dart';
// import 'model/add_schedule_model.dart';

// class AllCustomers extends StatefulWidget {
//   const AllCustomers({super.key});

//   @override
//   State<AllCustomers> createState() => _AllCustomersState();
// }

// class _AllCustomersState extends State<AllCustomers> {
//   AddScheduleModel? addScheduleModel = AddScheduleModel.addSchedule;

//   @override
//   void initState() {
//     print("customer list length====>${addScheduleModel!.customer!.length}");
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(12.0)),
//         color: Color(0xFFFFFF),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             height: 55,
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(10),
//                 bottomRight: Radius.circular(10),
//                 topLeft: Radius.circular(10),
//                 topRight: Radius.circular(10),
//               ),
//               color: AppColor.APP_BAR_COLOUR,
//             ),
//             child: Row(
//               children: [
//                 const Expanded(
//                   child: Text(
//                     "History Records",
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     height: 22,
//                     width: 22,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                       border: Border.all(color: Colors.white, width: 1.5),
//                     ),
//                     child: const Icon(
//                       Icons.clear_rounded,
//                       color: Colors.white,
//                       size: 16,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const Gap(10),
//           Expanded(
//               child: ListView.builder(
//             itemCount: addScheduleModel!.customer!.length,
//             itemBuilder: (context, index) {
//               return InkWell(
//                   onTap: () {
//                     showDialog(
//                       barrierDismissible: false,
//                       context: context,
//                       builder: (context) {
//                         return Dialog(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                           child: StatefulBuilder(
//                               // You need this, notice the parameters below:
//                               builder:
//                                   (BuildContext context, StateSetter setState) {
//                             return HistoryRecordPage(
//                               customerId: int.parse(addScheduleModel!
//                                   .customer![index].customerId
//                                   .toString()),
//                             );
//                           }),
//                         );
//                       },
//                     );
//                   },
//                   child: ListTile(
//                     title: Text(
//                         "${addScheduleModel!.customer![index].customerName}"),
//                   ));
//             },
//           ))
//         ],
//       ),
//     );
//   }
// }
