import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'Utils.dart';

class Navigate{


  Navigate(BuildContext context,String route,{Map<String, String>? params}){
    Utils().printMessage("Params ==============>>>> $params");

    try{
      context.push(route,extra: params);
    }catch(e){
      print('Can not push');
    }
        // GoRouter.of(context).goNamed(route,params: params??{})
  }

  static NavigateAndReplace(BuildContext context,String route,{Map<String, String>?params}){
    context.pushReplacement(route,extra: params??{});
    // GoRouter.of(context).goNamed(route,params: params??{})
  }

    static NavigatePushUntil(BuildContext context,String route,{Map<String, String>?params}){
    // context.pushReplacement(route,extra: params);
    // Navigator.of(context).popUntil(ModalRoute.withName(route));
    // Navigator.of(context).pushAndRemoveUntil(YourRoute, (Route<dynamic> route) => false);
      while (context.canPop()) {
        context.pop();
      }
      context.pushReplacement(route, extra: params);
    // GoRouter.of(context).goNamed(route,params: params??{})
  }
}