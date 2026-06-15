import 'package:dio/dio.dart';
import 'package:network/src/exception_interceptor.dart';

import 'omega_logger.dart';

class DioHelper {
  final String url;
  final Duration timeoutDuration;
  final List<Interceptor>? dioInterceptors;
  final bool showLogs;

  DioHelper._internal({
    required this.url,
    this.dioInterceptors,
    required this.timeoutDuration,
    required this.showLogs,
  });

  factory DioHelper({
    required String baseUrl,
    Duration timeoutDuration = const Duration(seconds: 30),
    List<Interceptor>? dioInterceptors,
    bool showLogs = false,
  }) {
    return DioHelper._internal(
      url: baseUrl,
      timeoutDuration: timeoutDuration,
      dioInterceptors: dioInterceptors,
      showLogs: showLogs,
    );
  }

  Dio createDio() {
    var dio = Dio(
      BaseOptions(
        baseUrl: url,
        receiveTimeout: timeoutDuration,
        connectTimeout: timeoutDuration,
        sendTimeout: timeoutDuration,
      ),
    );
    dio.interceptors.add(ExceptionInterceptor());
    if (dioInterceptors != null) {
      dio.interceptors.addAll(
        dioInterceptors!,
      );
    }
    if (showLogs) {
      dio.interceptors.add(
        const OmegaDioLogger(
          convertFormData: true,
          showError: true,
          showRequest: true,
          showRequestBody: true,
          showRequestHeaders: true,
          showRequestQueryParameters: true,
          showResponse: true,
          showResponseBody: true,
          showResponseHeaders: true,
          showCurl: true,
          showLog: true,
        ),
      );
    }
    return dio;
  }
}
