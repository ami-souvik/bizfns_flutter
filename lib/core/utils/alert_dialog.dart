import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/core/utils/fonts.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizing/sizing.dart';

import 'Utils.dart';

ShowDialog({required BuildContext context,required String title,required String msg,String?okButtonName,Function?okTap,bool? dismissable ,bool? isFullScreen,Color? headerColor}){
  showDialog(
    context: context,
    useSafeArea:isFullScreen?? false,

    barrierDismissible: dismissable??false,
    builder: (ctx) => AlertDialog(
      elevation: 20,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0.ss))),
      // contentPadding: EdgeInsets.only(top: 10.0),
      contentPadding: EdgeInsets.zero,
      content: Wrap(
        children: [
          Container(
            decoration: BoxDecoration(
              color: headerColor??AppColor.GERY,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0.ss),topRight: Radius.circular(10.0.ss)),
            ),
            height: 60.ss,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.ss),
                      child: CommonText(text: title,textStyle: CustomTextStyle(color: Colors.white,fontWeight: FontWeight.w700),maxLine: 3,)),
                ),

                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.clear),color: Colors.white,)
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20.ss,vertical: 10.ss),
              // height: MediaQuery.of(context).size.height-200,
              width: MediaQuery.of(context).size.width-50,
              child: CommonText(text: msg,textStyle: CustomTextStyle( fontSize: 12),maxLine: 100,)),
        ],
      ),
      actions: <Widget>[
        okTap!= null ?   TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            okTap!();
          },
          child: Center(
            child: Container(
              color: AppColor.BUTTON_COLOR,
              padding:  EdgeInsets.all(14),
              child:  CommonText(text: okButtonName??"okay",textStyle: CustomTextStyle(color: Colors.white)),
            ),
          ),
        )
        :SizedBox(),
      ],
    ),
  );
}

ShowInformationDialog({required BuildContext context, String? title, String? msg,Function? onOkTap,Function? onCancelTap, bool? dismissOnTouchOutside} ){

  AwesomeDialog(
    context: context,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dismissOnTouchOutside: dismissOnTouchOutside??false,
    dialogType: DialogType.question,
    // showCloseIcon: true,
    title: title??'Warning',
    desc: msg??"",

    // desc: 'Dialog description here..................................................',
    btnOkOnPress: () {
      // Utils().printMessage('OnClick');

    },
    btnCancelOnPress:(){

    } ,
    btnOkIcon: Icons.check_circle,
    onDismissCallback: (type) {
      Utils().printMessage('Dialog Dismiss from callback $type');

    },
  ).show();
}


ShowSuccessDialog({required BuildContext context, String? title, required String msg,required Function()? onOkTap, bool? dismissOnTouchOutside}){

  AwesomeDialog(
    context: context,
    dismissOnTouchOutside: dismissOnTouchOutside??false,
    animType: AnimType.leftSlide,
    headerAnimationLoop: true,
    dialogType: DialogType.success,
    // showCloseIcon: true,
    title: title??'Success',
    desc: msg,
    // desc: 'Dialog description here..................................................',
    btnOkOnPress: onOkTap,
    btnOkIcon: Icons.check_circle,
  ).show();
}
