import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ServiceEntityMobileNumberWidget extends StatefulWidget {
  final String question;
  final Function(String) onAnswerAdd;
  final String initialText;
  final String answer;

  const ServiceEntityMobileNumberWidget({
    super.key,
    required this.question,
    required this.onAnswerAdd,
    required this.initialText,
    required this.answer,
  });

  @override
  State<ServiceEntityMobileNumberWidget> createState() =>
      _ServiceEntityMobileNumberWidgetState();
}

class _ServiceEntityMobileNumberWidgetState
    extends State<ServiceEntityMobileNumberWidget> {
  //var formatter = MaskTextInputFormatter(mask: "+1 (###) ###-##-##");
  var textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.answer;
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: 14,
      controller: textEditingController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        MaskTextInputFormatter(
            mask: '(###) ###-####',
            filter: {"#": RegExp(r'[0-9]')},
            type: MaskAutoCompletionType.lazy),
      ],
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: widget.question,
        counterText: ''
      ),
      onChanged: (val) {
        widget.onAnswerAdd(val);
        //setState(() {});
      },
    );
  }
}
