
import 'package:bizfns/core/shared_pref/shared_pref.dart';
import 'package:bizfns/features/auth/ForgotPassword/repo/forgot_password_repo.dart';
import 'package:bizfns/features/auth/ForgotPassword/repo/forgot_password_repo_impl.dart';
import 'package:bizfns/features/auth/Login/model/login_otp_verification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/common/Status.dart';
import '../../../../core/route/RouteConstants.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/route_function.dart';

class HomeProvider extends ChangeNotifier {
  bool loading = false;
  TextEditingController tanentIdController = new TextEditingController();
  TextEditingController userIdController = new TextEditingController();

  TextEditingController pinController = new TextEditingController();

  TextEditingController newPassswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  String companyName ="";
  String companyLogo ="";

  /// get Business info from shared preferences
  getCompanyDetails()async{
    OtpVerificationData? data = await GlobalHandler.getLoginData();
    if(data!= null) {
      Utils().printMessage(data.businessLogo??"");
      companyName = data.bUSINESSNAME??"";
      companyLogo = data.logoAddress??"";
      notifyListeners();
    }
  }
}
