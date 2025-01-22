
import 'network_client.dart';

const String AUTH_ERROR = "Unauthorized";

class NetworkClientImpl extends NetworkClient {
  @override
  String getHttpErrorMessage({int? statusCode}) {
    String errorMessage = 'Something went wrong';
    switch (statusCode) {
      case 400:
        {
          errorMessage = "Bad Request";
          break;
        }
      case 401:
        {
          errorMessage = AUTH_ERROR;
          break;
        }
      case 404:
        {
          errorMessage = "Bad Request";
          break;
        }
      case 422:
        {
          errorMessage = "Unprocessable Entity";
          break;
        }
      case 500:
        {
          errorMessage = "Server Error";
          break;
        }
    }
    return errorMessage;
  }
}
