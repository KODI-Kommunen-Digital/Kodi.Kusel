import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:core/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customLoggerProvider =
    Provider((ref) => CustomLogger(logger: ref.read(loggerProvider)));

class CustomLogger {
  Logger logger;

  CustomLogger({required this.logger});

  // Log API requests
  void logRequest(RequestOptions options) {
    logger.d("--------- API Request ---------");
    logger.d("URL: ${options.baseUrl}${options.path}");
    logger.d("Method: ${options.method}");
    logger.d("Headers: ${jsonEncode(options.headers)}");
    if (options.data != null) {
      logger.d("Body: ${_prettyPrintJson(options.data)}");
    }
    logger.d("-------------------------------");
  }

  // Log API responses
  void logResponse(Response response) {
    logger.d("--------- API Response ---------");
    logger.d(
        "URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}");
    logger.d("Status Code: ${response.statusCode}");
    logger.d("Response: ${_prettyPrintJson(response.data)}");
    logger.d("-------------------------------");
  }

  // Log API exceptions
  void logError(DioException error) {
    logger.e("--------- API Error ---------");
    logger
        .e("URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}");

    logger
        .e("response body: ${error.response?.data}");
    logger.e("Error Type: ${error.type}");
    logger.e("Message: ${error.message}");
    logger.e("Status Code: ${error.response?.statusCode}");
    logger.e("Error Data: ${_prettyPrintJson(error.response?.data)}");
    logger.e("-----------------------------");
  }

  // Helper function to pretty-print JSON
  String _prettyPrintJson(dynamic json) {
    dynamic jsonObj;
    try {
      jsonObj = jsonDecode(json);
    } catch (e) {
      return json.toString();
    }
    var encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(jsonObj);
  }
}
