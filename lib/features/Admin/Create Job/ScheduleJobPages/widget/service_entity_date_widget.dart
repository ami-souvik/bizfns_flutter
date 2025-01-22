import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceEntityDateWidget extends StatefulWidget {
  final String question;
  final Function(String) onAnswerAdd;

  const ServiceEntityDateWidget({
    super.key,
    required this.question,
    required this.onAnswerAdd,
  });

  @override
  State<ServiceEntityDateWidget> createState() =>
      _ServiceEntityDateWidgetState();
}

class _ServiceEntityDateWidgetState extends State<ServiceEntityDateWidget> {

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true,
      readOnly: true,
      autofocus: true,
      controller: _controller,
      decoration: InputDecoration(
        enabled: true,
        hintText: widget.question,
        enabledBorder: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(),
        border: const OutlineInputBorder(),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(
            right: 10,
          ),
          child: SizedBox(
            height: 20,
            child: InkWell(
              onTap: () async {
                var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 365),
                  ),
                );

                _controller.text = DateFormat('yMMMMd').format(date!);

                widget.onAnswerAdd(_controller.text);
                setState(() {});
              },
              child: const Icon(
                Icons.date_range,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
