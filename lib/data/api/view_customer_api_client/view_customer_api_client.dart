

import '../../../features/Admin/Create Job/ScheduleJobPages/View Customer/model/customer_list_model.dart';

abstract class ViewCustomerApiClient{
  Future<List<CustomerListModel>?> fetchCustomerList();
}