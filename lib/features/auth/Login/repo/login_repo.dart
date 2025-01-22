
import '../../../../core/common/Resource.dart';
import '../../data/api/auth_api_client/auth_api_client.dart';

abstract class LoginRepo{
  final AuthApiClient apiClient;
  LoginRepo({required this.apiClient});


  Future<Resource> login({required String username, required String password});
  Future<Resource> verifyOtp({required String userId, required String otp});
}