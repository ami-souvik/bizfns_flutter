import 'package:flutter/material.dart';


class ServiceEntityEmailIDWidget extends StatefulWidget {

  final String question;
  final Function(String) onAnswerAdd;

  const ServiceEntityEmailIDWidget({super.key, required this.question, required this.onAnswerAdd});

  @override
  State<ServiceEntityEmailIDWidget> createState() => _ServiceEntityEmailIDWidgetState();
}

class _ServiceEntityEmailIDWidgetState extends State<ServiceEntityEmailIDWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.phone,
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
