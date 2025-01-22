import 'package:bizfns/features/Admin/Create%20Job/model/add_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/utils/colour_constants.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';

class WriteNote extends StatefulWidget {
  const WriteNote({Key? key}) : super(key: key);

  @override
  State<WriteNote> createState() => _WriteNoteState();
}

class _WriteNoteState extends State<WriteNote> {
  AddScheduleModel model = AddScheduleModel.addSchedule;

  @override
  void initState() {
    if (model.note != null && model.note != "null") {
      noteController.text = model.note!;
      noteController.selection =
          TextSelection.fromPosition(TextPosition(offset: model.note!.length));

      // noteController.selection(TextSelection(baseOffset: , extentOffset: extentOffset))
    }
    Provider.of<TitleProvider>(context, listen: false).title =
        'Schedule New Modify';
    super.initState();
  }

  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          color: Color(0xFFFFFF),
        ),
        child: Column(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Write Notes",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter Text",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  )),
            ),
            // Gap(10.ss),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: TextField(
                maxLines: 9,
                controller: noteController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  //hintText: 'Enter a search term',
                ),
              ),
            ),
            // const Gap(25),
            GestureDetector(
              onTap: () {
                model.note = noteController.text;
                Navigator.pop(context);
              },
              child: const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
                  child: CustomButton(
                    title: 'Done',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
