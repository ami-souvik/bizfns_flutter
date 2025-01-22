import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/ManageProfile/provider/manage_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizing/sizing.dart';
import 'package:provider/provider.dart';

import '../../core/utils/colour_constants.dart';
import '../../core/utils/fonts.dart';
import '../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../core/widgets/common_text_form_field.dart';

class SequrityQuestionPage extends StatefulWidget {
  final String fromWhere;
  const SequrityQuestionPage({Key? key, required this.fromWhere})
      : super(key: key);

  @override
  State<SequrityQuestionPage> createState() => _SequrityQuestionPageState();
}

class _SequrityQuestionPageState extends State<SequrityQuestionPage> {
  @override
  void dispose() {
    // Provider.of<ManageProfileProvider>(context,listen: false).userIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<ManageProfileProvider>(context, listen: false)
        .getSequrityQuestions(context);
    print("ForWhat ====>${widget.fromWhere}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var controller = Provider.of<ManageProfileProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFf4feff),
        // body: controller.loading?
        //      Center(
        //       child: CircularProgressIndicator(color: AppColor.APP_BAR_COLOUR,),
        //     )
        //     :
        body: Container(
          // padding: EdgeInsets.symmetric(horizontal: 20.ss),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.ss),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(30.ss),
                Padding(
                  padding: EdgeInsets.all(8.0.ss),
                  child: SizedBox(
                    height: 20.ss,
                    child: Center(
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Simple Services",
                      style: TextStyle(
                          fontSize: 18.fss,
                          fontFamily: "Roboto",
                          color: Colors.black),
                    ),
                  ],
                ),
                Gap(0.ss),
                CommonText(
                    text: "Security Questions",
                    textStyle: CustomTextStyle(
                        fontSize: 22.fss, fontWeight: FontWeight.w700)),
                Gap(10.ss),
                context
                        .watch<ManageProfileProvider>()
                        .sequrityquestions
                        .isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: context
                            .watch<ManageProfileProvider>()
                            .sequrityquestions
                            .length,
                        itemBuilder: (context, i) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //key: _containerKey,
                          // key: _key[i],
                          children: [
                            Gap(20.ss),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CommonText(
                                text: context
                                    .watch<ManageProfileProvider>()
                                    .sequrityquestions[i]
                                    .qUESTION,
                                maxLine: 3,
                              ),
                            ),
                            Gap(0.ss),
                            CommonTextFormField(
                              hintText: "Enter answer",
                              fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                              decoration: const InputDecoration(
                                hintText: "Enter answer",
                                border: OutlineInputBorder(gapPadding: 1),
                                isDense: true,
                                // isCollapsed: true,
                                enabledBorder:
                                    OutlineInputBorder(gapPadding: 1),
                                focusedBorder:
                                    OutlineInputBorder(gapPadding: 1),
                              ),
                              onChanged: (value) {
                                debugPrint(value ?? 'value');
                                context
                                    .read<ManageProfileProvider>()
                                    .sequrityquestions[i]
                                    .answeer = value!.trimRight().trimLeft();
                              },
                            ),
                          ],
                        ),
                      )
                    : controller.loading
                        ? SizedBox()
                        : CommonText(
                            text: "No Item Found",
                          ),
                Gap(30.ss),
                Visibility(
                  visible: context
                      .watch<ManageProfileProvider>()
                      .sequrityquestions
                      .isNotEmpty,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0.ss),
                    child: Column(
                      children: [
                        InkWell(
                            onTap: () {
                              widget.fromWhere == ""?
                              controller.validition(context):controller.validitionForPh(context,widget.fromWhere)
                              ;
                            },
                            child: const CustomButton(title: "Submit")),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
//)
      ),
    );
  }
}
