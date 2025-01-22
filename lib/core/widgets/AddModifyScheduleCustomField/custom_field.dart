import 'package:bizfns/features/Admin/Create%20Job/model/service_entity_question_answer_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/service_entity_question_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:sizing/sizing.dart';

class CustomField extends StatelessWidget {
  // final IconData icon;
  final String title;
  final bool isDone;
  final bool ifMandatory;
  final String svgPath;

  final bool? hasData;

  const CustomField(
      {Key? key,
      // required this.icon,
      required this.title,
      required this.isDone,
      this.ifMandatory = false,
      required this.svgPath, this.hasData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: hasData == false ? Border.all(color: Colors.red) : null,
            color: isDone ? const Color(0xFF00ACD8) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 0.5), //(x,y)
                blurRadius: 0.2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isDone ? Colors.white : const Color(0xFFeaeaea),
                      borderRadius: BorderRadius.circular(100)),
                  child: SvgPicture.asset(
                    svgPath,
                    width: 20.ss,
                    color: Colors.black,
                  ),
                ),
                const Gap(12),
                ifMandatory == false
                    ? Text(
                        title,
                        style: TextStyle(
                            color: isDone ? Colors.white : Colors.black,
                            fontSize: 14),
                      )
                    : Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                color: isDone ? Colors.white : Colors.black,
                                fontSize: 14),
                          ),
                          const Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
              ],
            ),
          )),
    );
  }
}

class CustomDetailsField extends StatelessWidget {
  final String data;

  const CustomDetailsField({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Gap(4.ss),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFeaeaea)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: Text(
                data,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
          Gap(0.ss),
        ],
      ),
    );
  }
}

class CustomServiceEntityField extends StatelessWidget {
  final List<ServiceEntityItemData>? data;

  const CustomServiceEntityField({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Gap(10.ss),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...data!
                      .map((e) => Container(
                            color: const Color(0xffcceef7),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${e.question} :',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    e.answer!,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
          Gap(10.ss),
        ],
      ),
    );
  }
}
