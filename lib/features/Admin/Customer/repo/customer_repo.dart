import 'package:bizfns/features/Admin/data/api/add_user_api_client/add_user_api_client_impl.dart';

import '../../../../../core/common/Resource.dart';

abstract class CustomerRepo {
  final AddUserApiClientImpl apiClient;

  CustomerRepo({required this.apiClient});

  Future<Resource> addCustomer(
      {required String firstName,
      required String lastName,
      required String email,
      required String phone,
      required String custAddress,
      required String custCompanyName,
      required serviceEntity});

  Future<Resource> getCustomerServiceEntity({required customerID});

  Future<Resource> deleteCustomer({required String customerId});

  Future<Resource> getCustomerDetails({required String customerId});

  Future<Resource> updateCustomer(
      {required String customerId,
      required String firstName,
      required String lastName,
      required String companyName,
      required String address,
      required String email,
      required String customerPhone});

  Future<Resource> activeInactiveCustomer({required String customerId, required String activeStatus});
}
