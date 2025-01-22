import 'package:bizfns/data/api/view_customer_api_client/view_customer_api_client.dart';

import '../model/customer_list_model.dart';

abstract class ViewCustomerRepo{
  final ViewCustomerApiClient apiClient;
  ViewCustomerRepo({required this.apiClient});
  Future<List<CustomerListModel>?> fetchCustomer();
}