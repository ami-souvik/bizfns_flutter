import 'package:bizfns/data/api/view_customer_api_client/view_customer_api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';

import '../../../core/utils/Utils.dart';
import '../../../core/utils/api_constants.dart';
import '../../../features/Admin/Create Job/ScheduleJobPages/View Customer/model/customer_list_model.dart';


class ViewCustomerApiClientImpl extends GetConnect
    implements ViewCustomerApiClient {

  @override
  Future<List<CustomerListModel>?> fetchCustomerList() async {

    List<CustomerListModel> custModelList = [];

    var response = await get(Urls.FETCH_CUSTOMERS);
    Utils().printMessage("FETCH_CUSTOMER_RESPONSE===>${response.body}");
    try {
      if (response.body['success'] == "1") {
        Map<String,dynamic> mapResponse = response.body;
        CustomerListModel custModel = CustomerListModel.fromJson(mapResponse);
        custModelList.add(custModel);
      }
    } catch (e) {
      Utils().printMessage("Fetch Customer Catch = >${e.toString()}");
    }
    return custModelList;
  }
}
