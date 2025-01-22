import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/utils/bizfns_layout_widget.dart';
import '../../core/utils/colour_constants.dart';
import '../../core/widgets/common_text.dart';

class AccountPage2 extends StatefulWidget {
  const AccountPage2({Key? key}) : super(key: key);

  @override
  State<AccountPage2> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage2> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        return true;
      },
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   leading: InkWell(
        //     onTap: (){
        //       GoRouter.of(context).pop();
        //     },
        //     child: Icon(Icons.arrow_back),
        //   ),
        //   title: CommonText(text: "Account"),
        //   backgroundColor: AppColor.BUTTON_COLOR,
        // ),
        body: Center(child: Text('Account-page Coming soon...')),
      ),
    );
  }
}
