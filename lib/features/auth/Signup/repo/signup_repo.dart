

import '../../../../core/common/Resource.dart';
import '../../data/api/auth_api_client/auth_api_client.dart';

abstract class SignupRepo{
  final AuthApiClient apiClient;
  SignupRepo({required this.apiClient});


  Future<Resource> preSignup({required String username, required String password});
  Future<Resource> signup({required String username, required String password});
}