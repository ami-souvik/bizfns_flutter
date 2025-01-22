import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:flutter/material.dart';

import 'service_entity_date_widget.dart';
import 'service_entity_drop_down_widget.dart';
import 'service_entity_email_id_widget.dart';
import 'service_entity_mobile_number_widget.dart';
import 'service_entity_multiple_option_widget.dart';
import 'service_entity_number_widget.dart';
import 'service_entity_radio_button_widget.dart';
import 'service_entity_text_widget.dart';
import 'service_entity_toggle_widget.dart';

// todo: 1 Text Done
// todo 2 Number Done
// todo 3 Multiple Done
// todo 4 Dropdown Done
// todo 5 RadioButton Done
// todo 6 Toggle Done
// todo 7 MobileNumber Done
// todo 8 Email Done
// todo 9 Date Done
// todo 10 Float Done
// todo 11 Row Done

class ServiceEntityItemWidget extends StatefulWidget {
  final String question;
  final int typeID;
  final List<String> items;
  final Function(String) onAnswerAdd;
  final String? answer;

  const ServiceEntityItemWidget(
      {super.key,
      required this.question,
      required this.typeID,
      required this.items,
      required this.onAnswerAdd,
      this.answer});

  @override
  State<ServiceEntityItemWidget> createState() =>
      _ServiceEntityItemWidgetState();
}

class _ServiceEntityItemWidgetState extends State<ServiceEntityItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question,
          style: const TextStyle(
            color: AppColor.APP_BAR_COLOUR,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        generateWidget(context, widget.question, widget.typeID,
            answer: widget.answer),
      ],
    );
  }

  Widget generateWidget(BuildContext context, String question, int id,
      {String? answer}) {
    switch (id) {
      case 1:
        return ServiceEntityTextWidget(
          initialText: answer ?? '',
          onAnswerAdd: (val) => widget.onAnswerAdd(val),
          question: question,
          answer: answer ?? '',
        );
      case 2:
        return ServiceEntityNumberWidget(
          onAnswerAdd: (val) => widget.onAnswerAdd(val),
          question: question,
          initialText: answer!,
          answer: answer,
        );
      case 3:
        return ServiceEntityMultipleOptionWidget(
          onAnswerAdd: (val) => widget.onAnswerAdd(val),
          question: question,
          options: widget.items,
        );
      case 4:
        return ServiceEntityDropDownWidget(
          onAnswerAdd: (val) => widget.onAnswerAdd(val),
          question: question,
          options: widget.items,
          answer: widget.answer ?? '',
        );
      case 5:
        return ServiceEntityRadioButtonWidget(
          onAnswerAdd: (val) => widget.onAnswerAdd(val),
          question: question,
          options: widget.items,
        );
      case 6:
        return ServiceEntityToggleWidget(
          onAnswerAdd: (val) => widget.onAnswerAdd(val),
          question: question,
        );
      case 7:
        return ServiceEntityMobileNumberWidget(
          onAnswerAdd: (val) => widget.onAnswerAdd(val),
          question: question,
          initialText: answer!,
          answer: answer,
        );
      case 8:
        return ServiceEntityEmailIDWidget(
          onAnswerAdd: (val) => widget.onAnswerAdd(val),
          question: question,
        );
      case 9:
        return ServiceEntityDateWidget(
          onAnswerAdd: (val) => widget.onAnswerAdd(val),
          question: question,
        );
      case 10:
        return ServiceEntityNumberWidget(
          onAnswerAdd: (val) => widget.onAnswerAdd(val),
          question: question,
          initialText: answer!,
          answer: answer,
        );
      default:
        return const SizedBox();
    }
  }
}
