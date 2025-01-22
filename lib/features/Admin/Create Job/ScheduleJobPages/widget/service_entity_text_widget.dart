import 'package:bizfns/features/Admin/Create%20Job/model/service_entity_question_model.dart';
import 'package:flutter/material.dart';

class ServiceEntityTextWidget extends StatefulWidget {
  final String question;
  final Function(String) onAnswerAdd;
  final String initialText;
  final String answer;

  const ServiceEntityTextWidget({
    super.key,
    required this.question,
    required this.onAnswerAdd,
    required this.initialText,
    required this.answer,
  });

  @override
  State<ServiceEntityTextWidget> createState() =>
      _ServiceEntityTextWidgetState();
}

class _ServiceEntityTextWidgetState extends State<ServiceEntityTextWidget> {
  var textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.answer;
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: widget.question,
        counterText: "",
      ),
      maxLength: widget.question.toLowerCase().contains('weight') ? 3 : null,
      keyboardType: widget.question.toLowerCase().contains('weight')?TextInputType.number:TextInputType.text,
      onChanged: (val) {
        print(val);
        widget.onAnswerAdd(val);
        setState(() {});
      },
    );
  }
}
