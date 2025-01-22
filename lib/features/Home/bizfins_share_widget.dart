import 'package:bizfns/core/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/colour_constants.dart';

class BizfinsShareWidget extends StatefulWidget {
  const BizfinsShareWidget({super.key});

  @override
  State<BizfinsShareWidget> createState() => _BizfinsShareWidgetState();
}

class _BizfinsShareWidgetState extends State<BizfinsShareWidget> {
  shareBizfins() async {

    final result = await Share.shareWithResult(
        "Let's manage your business with Bizfins, it's fast and an useful tool to group your day to day schedule in one place and easier to manage, let's go with bizfins...\niOS: https://www.apple.com/in/app-store/\nAndroid: https://play.google.com/store/games?hl=en&gl=US");

    if (result.status == ShareResultStatus.success) {
      Utils().ShowSuccessSnackBar(context, 'Success',
          'Thank you for telling your friends about Bizfins');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await shareBizfins();
      },
      child: Container(
        color: Colors.transparent,
        child: const Column(
          children: [
            Text(
              'Tell your friend about Bizfins!',
              style: TextStyle(
                fontSize: 17,
                color: AppColor.APP_BAR_COLOUR,
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
