import 'dart:convert';

import 'package:bizfns/core/common/Resource.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:dio/dio.dart';

import '../utils/api_constants.dart';

enum RequestType { GET, POST, PUT, PATCH, DELETE }

class ApiHelper {
  // late dio.Dio dao;

  // ApiHelper(){
  //    dao = dio.Dio();
  // }

  static int timeoutSec = 30;

  final dao = createDio();

  ApiHelper._internal();

  static final _singleton = ApiHelper._internal();

  factory ApiHelper() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      // baseUrl: Urls.BASE_URL,
      receiveTimeout: Duration(seconds: timeoutSec), // 20 seconds
      connectTimeout: Duration(seconds: timeoutSec),
      sendTimeout: Duration(seconds: timeoutSec),
    ));

    dio.interceptors.addAll({
      AuthInterceptor(dio),
    });
    dio.interceptors.addAll({
      Logging(dio),
    });

    return dio;
  }

  static Future<dio.Response> requestPost(
      {String? path,
      Map<String, dynamic>? body,
      Map<String, dynamic>? header}) async {
    //  var headers = await getHeaders();
    print(path!);
    print(body!);
    if (header != null) {
      header["Access-Control-Allow-Origin"] = "*";
    }
    var response = await Dio().post(path,
        queryParameters: body ?? {},
        options:
            Options(headers: header ?? {"Access-Control-Allow-Origin": "*"}));
    print(response.data);
    return response;
  }

  static Future<dio.Response> requestPostWithAuth(
      {String? path, String? userName, String? password}) async {
    var response = await Dio().post(path!);
    return response;
  }

  static Future<dio.Response> requestPostWithFormData(
      {String? path, FormData? formData}) async {
    print(path!);

    print(formData!.fields);

    var response = await dio.Dio().post(
      path,
      data: formData,
    );
    print(response.requestOptions.data);

    return response;
  }

  Future<Resource> apiCall(
      {required String url,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? body,
      required RequestType requestType,
      Map<String, dynamic>? header}) async {
    late Response result;
    try {
      if (header != null) {
        header["Access-Control-Allow-Origin"] = "*";
      }
      switch (requestType) {
        case RequestType.GET:
          {
            Options options = Options(
                headers: header ?? {"Access-Control-Allow-Origin": "*"});
            result = await dao.get(url,
                queryParameters: queryParameters, options: options);
            break;
          }
        case RequestType.POST:
          {
            Options options = Options(
                headers: header ?? {"Access-Control-Allow-Origin": "*"});
            result = await dao.post(url, data: body, options: options);
            break;
          }
      }
      if (result != null) {
        return Resource.success(data: result.data);
      } else {
        print(result);
        return Resource.error(message: "Data is null");
      }
    } on DioException catch (error) {
      print(error.response);

      return Resource.error(
          message: error.message, data: error.response!.statusCode.toString());
    } catch (error) {
      print(error);
      return Resource.error(message: error.toString());
    }
  }

  Future<Resource> apiCallForImage(
      {required String url,
      FormData? body,
      Map<String, dynamic>? header}) async {
    late Response result;
    try {
      if (header != null) {
        header["Access-Control-Allow-Origin"] = "*";
      }

      Options options =
          Options(headers: header ?? {"Access-Control-Allow-Origin": "*"});
      result = await dao.post(url, data: body, options: options);
      if (result != null) {
        return Resource.success(data: result.data);
      } else {
        return Resource.error(message: "Data is null");
      }
    } on DioException catch (error) {
      return Resource.error(
          message: error.message, data: error.response!.statusCode.toString());
    } catch (error) {
      return Resource.error(message: error.toString());
    }
  }

  Future<Resource> deleteImage(
      {required String url,
      Map<String, dynamic>? body,
      Map<String, dynamic>? header}) async {
    late Response result;
    try {
      if (header != null) {
        header["Access-Control-Allow-Origin"] = "*";
      }

      Options options =
          Options(headers: header ?? {"Access-Control-Allow-Origin": "*"});
      result = await dao.post(url, data: body, options: options);
      if (result != null) {
        return Resource.success(data: result.data);
      } else {
        return Resource.error(message: "Data is null");
      }
    } on DioException catch (error) {
      return Resource.error(
          message: error.message, data: error.response!.statusCode.toString());
    } catch (error) {
      return Resource.error(message: error.toString());
    }
  }
}

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // var accessToken = await TokenRepository().getAccessToken();
    //
    // if (accessToken != null) {
    //   var expiration = await TokenRepository().getAccessTokenRemainingTime();
    //
    //   if (expiration.inSeconds < 60) {
    //     dio.interceptors.requestLock.lock();
    //
    //     // Call the refresh endpoint to get a new token
    //     await UserService()
    //         .refresh()
    //         .then((response) async {
    //       await TokenRepository().persistAccessToken(response.accessToken);
    //       accessToken = response.accessToken;
    //     }).catchError((error, stackTrace) {
    //       handler.reject(error, true);
    //     }).whenComplete(() => dio.interceptors.requestLock.unlock());
    //   }
    //
    //   options.headers['Authorization'] = 'Bearer $accessToken';
    // }
    return handler.next(options);
  }
}

class ErrorInterceptors extends Interceptor {
  final Dio dio;

  ErrorInterceptors(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeOutException(err.requestOptions);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions);
          case 401:
            throw UnauthorizedException(err.requestOptions);
          case 404:
            throw NotFoundException(err.requestOptions);
          case 409:
            throw ConflictException(err.requestOptions);
          case 500:
            throw InternalServerErrorException(err.requestOptions);
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
  }
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioException {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class TimeOutException extends DioException {
  TimeOutException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}

class Logging extends Interceptor {
  final Dio dio;
  Logging(this.dio);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    return super.onError(err, handler);
  }
}
