import 'package:flutter/material.dart';

import '../../model/service_entity_question_model.dart';

class ServiceEntityNumberWidget extends StatefulWidget {
  final String question;
  final Function(String) onAnswerAdd;
  final String initialText;
  final String answer;

  const ServiceEntityNumberWidget({
    super.key,
    required this.question,
    required this.onAnswerAdd,
    required this.initialText,
    required this.answer,
  });

  @override
  State<ServiceEntityNumberWidget> createState() =>
      _ServiceEntityNumberWidgetState();
}

class _ServiceEntityNumberWidgetState extends State<ServiceEntityNumberWidget> {
  var textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.answer;
    textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: widget.question,
      ),
      onChanged: (val) {
        widget.onAnswerAdd(val);
        setState(() {});
      },
    );
  }
}
