
import '../../../../core/common/Resource.dart';
import '../../data/api/auth_api_client/auth_api_client.dart';

abstract class ForgotPasswordRepo{
  final AuthApiClient apiClient;
  ForgotPasswordRepo({required this.apiClient});


  Future<Resource> forgotPassword({required Map<String,dynamic>body});

}