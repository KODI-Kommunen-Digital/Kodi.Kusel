import 'package:core/environment/environment_type.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:data/interceptor/custom_interceptor.dart';
import 'package:data/interceptor/weather_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/src/api_helper.dart';
import 'package:network/src/dio_factory.dart';

import 'end_points.dart';

final apiHelperProvider = Provider.autoDispose<ApiHelper>((ref) {
  final environment =
      ref.read(sharedPreferenceHelperProvider).getString(environmentKey);

  final dioHelper = DioHelper(
    baseUrl:  (environment==null || environment == EnvironmentType.production.name)
        ? baseUrlProd
        : baseUrlStage,
    dioInterceptors: [ref.read(customInterceptorProvider)],
  );

  return ApiHelper(dioHelper: dioHelper);
});


final apiHelperForWeatherProvider = Provider.autoDispose<ApiHelper>((ref) {

  final dioHelper = DioHelper(
    baseUrl:  weatherEndPoint,
    dioInterceptors: [ref.read(weatherInterceptorProvider)]
  );

  return ApiHelper(dioHelper: dioHelper);
});
