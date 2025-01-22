import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/auth/ForgotBusinessId/provider/forgot_business_id_provider.dart';
import 'package:bizfns/features/auth/ForgotPassword/provider/forgot_password_provider.dart';
import 'package:bizfns/features/auth/Login/provider/login_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizing/sizing.dart';
import 'package:provider/provider.dart';

import '../../../core/route/RouteConstants.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/route_function.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/common_text_form_field.dart';


class ForgotBusinessIdPage extends StatefulWidget {
  const ForgotBusinessIdPage({Key? key}) : super(key: key);

  @override
  State<ForgotBusinessIdPage> createState() => _ForgotBusinessIdPageState();
}

class _ForgotBusinessIdPageState extends State<ForgotBusinessIdPage> {

@override
  void initState() {
  Provider.of<ForgotBusinessIdProvider>(context,listen: false).userIdController.text="";
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var controller = Provider.of<ForgotBusinessIdProvider>(context,listen: false);

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFf4feff),
        body: context.watch<ForgotBusinessIdProvider>().loading?
            const Center(
              child: CircularProgressIndicator(color: AppColor.APP_BAR_COLOUR,),
            )
            :
            SingleChildScrollView(

              physics: ScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kIsWeb? MediaQuery.of(context).size.width/4 :20.ss),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: Provider.of<ForgotBusinessIdProvider>(context,listen: false).formKey,
                      child: ListView(
                        shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(size.height/20.ss),
                      Padding(
                        padding:  EdgeInsets.all(8.0.ss),
                        child: SizedBox(
                          height: 20.ss,
                          child: Center(
                            child: Image.asset("assets/images/logo.png"),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           CommonText(
                            text: "Simple Services",
                            textStyle: CustomTextStyle(
                                fontSize: 18.fss, color: Colors.black),
                          ),
                        ],
                      ),
                       Gap(10.ss),
            Gap(size.height/20.ss),
            CommonText(text: "Forgot Business Id",textStyle: CustomTextStyle(fontSize: 24.fss,fontWeight: FontWeight.w700)),

            CommonText(text: "Hello There! Welcome Back",textStyle: CustomTextStyle(fontSize: 14.fss,fontWeight: FontWeight.w500)),
            Gap(30.ss),

            Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10.0.ss),
                        child: CommonText(text: "User Id",textStyle: CustomTextStyle(fontSize: 14.fss,fontWeight: FontWeight.w700)),
                      ),
            SizedBox(height: 5.ss,),
            CommonTextFormField(
                          textInputAction: TextInputAction.done,
                          controller: Provider.of<ForgotBusinessIdProvider>(context,listen: false).userIdController,
                          onValidator: (value){
                            if(value!= null && value.isEmpty){
                              return "Please enter user id";
                            } else return null;
                          },
                          fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                          decoration: InputDecoration(
                            hintText: "Registered email / mobile no",
                            border: OutlineInputBorder(gapPadding: 1),
                            isDense: true,
                            enabledBorder: OutlineInputBorder(gapPadding: 1),
                            focusedBorder:OutlineInputBorder(gapPadding: 1),)),
            Gap(30.ss),
            InkWell(
                          onTap: () {
                            // Fluttertoast.showToast(msg: "Clicked");
                            //showMyDialog(context);
                            //  context.go(Routes.VERIFY_OTP, arguments: {'phno': "9064818788"});
                            controller.validition(context);
                            // context.go(Routes.VERIFY_OTP);
                          },
                          child: const CustomButton(title: "Submit"))

          ],
        ),
                    ),
                  ),
                  


                ],
              ),
            ),
//)
      ),
    );
  }

}
