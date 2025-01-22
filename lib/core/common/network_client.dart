
import 'package:flutter/foundation.dart';


abstract class NetworkClient{
  String getHttpErrorMessage({@required int statusCode});
}