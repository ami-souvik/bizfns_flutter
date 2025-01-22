import 'package:bizfns/data/api/view_customer_api_client/view_customer_api_client_impl.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/utils/Utils.dart';
import '../model/customer_list_model.dart';
import '../repo/view_customer_repo_impl.dart';

class ViewCustomerProvider extends ChangeNotifier{
  bool isLoading = false;

  var viewCustomerRepository = ViewCustomerRepoImpl(apiClient: ViewCustomerApiClientImpl());

  var _customerList = <CustomerListModel>[];

  fetchCustomer() async{
    viewCustomerRepository!.fetchCustomer().then((value) async{
      if(_customerList != null){
        Utils().printMessage("STATUS SUCCESS==>${value![0].data![0]}");
        _customerList = value;
        Utils().printMessage("STATUS SUCCESS LIST==>$_customerList");
      }else{
        Utils().printMessage("STATUS FAILED");
      }
      Utils().printMessage("STATUS SUCCESS==>${value!.length}");//[0].data![0].cUSTOMERFIRSTNAME
      /*if(value.status == STATUS.SUCCESS){
        // customerList.assign(value.data);
        Utils().printMessage("STATUS SUCCESS==>$value");
      }else{
        Utils().printMessage("STATUS FAILED");
      }*/
    },onError: (err){
      Utils().printMessage("STATUS ERROR : $err");
    } );
  }

  List<CustomerListModel> get items{
    return [..._customerList];
  }
}