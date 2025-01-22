
import '../../../../../../core/utils/Utils.dart';
import '../model/customer_list_model.dart';
import 'view_customer_repo.dart';

class ViewCustomerRepoImpl extends ViewCustomerRepo{
  ViewCustomerRepoImpl({required super.apiClient});

  @override
  Future<List<CustomerListModel>?> fetchCustomer() async{
    List<CustomerListModel>? custModelList = [];
    custModelList = await apiClient.fetchCustomerList();
    Utils().printMessage("custModelList==>$custModelList");
    /*if(custModelList ==  STATUS.SUCCESS){
      Utils().printMessage("Fetch Customer Successful");
    }else{
      Utils().printMessage("Fetch Customer Failed");
    }*/
    return custModelList;
  }


}