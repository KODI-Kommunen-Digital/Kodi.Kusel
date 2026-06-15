import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../custom_logger.dart';

final weatherInterceptorProvider = Provider((ref) => WeatherInterceptor(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class WeatherInterceptor extends Interceptor {
  Ref<Object?> ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  WeatherInterceptor({required this.ref, required this.sharedPreferenceHelper});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    ref.read(customLoggerProvider).logResponse(response);

    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ref.read(customLoggerProvider).logRequest(options);
    options.validateStatus = (status) {
      return status != null && status < 500;
    };
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    ref.read(customLoggerProvider).logError(error);
    super.onError(error, handler);
  }
}
