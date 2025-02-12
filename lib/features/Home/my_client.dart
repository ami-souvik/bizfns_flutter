import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MyClient extends http.BaseClient {
  final Map<String, String> defaultHeaders;
  http.Client _httpClient = new http.Client();

  MyClient({this.defaultHeaders = const {}});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }

  @override
  Future<Response> GET(url, {required Map<String, String> headers}) {
    headers.addAll(defaultHeaders);
    return _httpClient.get(url, headers: headers);
  }

  @override
  Future<Response> POST(url,
      {required Map<String, String> headers, body, required Encoding encoding}) {
    headers.addAll(defaultHeaders);
    return _httpClient.post(url, headers: headers, encoding: encoding);
  }

  @override
  Future<Response> PATCH(url,
      {required Map<String, String> headers, body, required Encoding encoding}) {
    headers.addAll(defaultHeaders);
    return _httpClient.patch(url, headers: headers, encoding: encoding);
  }

  @override
  Future<Response> PUT(url,
      {required Map<String, String> headers, body, required Encoding encoding}) {
    headers.addAll(defaultHeaders);
    return _httpClient.put(url,
        headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<Response> HEAD(url, {required Map<String, String> headers}) {
    headers.addAll(defaultHeaders);
    return _httpClient.head(url, headers: headers);
  }

  @override
  Future<Response> DELETE(url, {required Map<String, String> headers}) {
    headers.addAll(defaultHeaders);
    return _httpClient.delete(url, headers: headers);
  }
}