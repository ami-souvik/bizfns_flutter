import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../model/service_entity_question_model.dart';

class ServiceEntityDropDownWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final Function(String) onAnswerAdd;
  final String answer;

  const ServiceEntityDropDownWidget({
    super.key,
    required this.question,
    required this.onAnswerAdd,
    required this.options,
    required this.answer,
  });

  @override
  State<ServiceEntityDropDownWidget> createState() =>
      _ServiceEntityDropDownWidgetState();
}

class _ServiceEntityDropDownWidgetState
    extends State<ServiceEntityDropDownWidget> {
  @override
  Widget build(BuildContext context) {

    print('Answer: ${widget.answer}');

    return DropdownButtonFormField2(
      value: widget.answer.isNotEmpty ? widget.answer : widget.options[1],
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(),
      ),
      isExpanded: true,
      hint: Text(
        widget.question!,
      ),
      items: widget.options == null
          ? []
          : widget.options
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,
                        style: const TextStyle(
                          fontSize: 14,
                        )),
                  ))
              .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select ${widget.question}';
        }
        return null;
      },
      onChanged: (value) {
        widget.onAnswerAdd(value.toString());
        setState(() {});
      },
      onSaved: (value) {
        widget.onAnswerAdd(value.toString());
        setState(() {});
      },
      buttonStyleData: const ButtonStyleData(
        height: 60,
        padding: EdgeInsets.only(right: 10),
      ),
      iconStyleData: IconStyleData(
        icon: Transform.rotate(
          angle: 4.7,
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black45,
          ),
        ),
        iconSize: 20,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
