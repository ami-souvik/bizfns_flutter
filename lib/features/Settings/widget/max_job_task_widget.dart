import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/common_text_form_field.dart';
import '../../../provider/job_schedule_controller.dart';

class MaxJobTaskWidget extends StatefulWidget {

  final ValueChanged<String> onChanged;

  const MaxJobTaskWidget({super.key, required this.onChanged});

  @override
  State<MaxJobTaskWidget> createState() => _MaxJobTaskWidgetState();
}

class _MaxJobTaskWidgetState extends State<MaxJobTaskWidget> {

  var countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var controller = context.watch<JobScheduleProvider>();

    countController.text = controller.maxJobTask ?? "";

    return Container(
      height: size.height / 3, //1.6
      width: size.width / 1.2,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        color: Colors.grey.withOpacity(0.05),
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
              children: [
                const Expanded(
                  child: Text(
                    "Max Job Task",
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
          const Gap(30),
          // Gap(10.ss),
          CommonTextFormField(
            controller: countController,
            textInputType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            fontTextStyle:
            CustomTextStyle(fontSize: 16.fss),
            decoration: const InputDecoration(
              hintText:
              "No of jobs per time slot",
              border:
              OutlineInputBorder(gapPadding: 1),
              isDense: true,
              enabledBorder:
              OutlineInputBorder(gapPadding: 1),
              focusedBorder:
              OutlineInputBorder(gapPadding: 1),
            ),
          ),
          const Gap(15),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: InkWell(
                child: const CustomButton(
                  title: 'Save',
                ),
                onTap: () {
                  widget.onChanged(countController.text);
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
}
