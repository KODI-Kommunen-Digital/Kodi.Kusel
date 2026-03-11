import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../custom_logger.dart';

final customInterceptorProvider = Provider((ref) => CustomInterceptor(
    ref: ref,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class CustomInterceptor extends Interceptor {
  Ref<Object?> ref;
  SharedPreferenceHelper sharedPreferenceHelper;

  CustomInterceptor({required this.ref, required this.sharedPreferenceHelper});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    ref.read(customLoggerProvider).logResponse(response);

    // if ((response.requestOptions.path != sigInEndPoint &&
    //     response.requestOptions.path != signUpEndPoint) &&
    //     (response.statusCode == 401)) {
    //   ApiHelper apiHelper = ref.read(apiHelperProvider);
    //
    //   final userId = sharedPreferenceHelper.getInt(userIdKey);
    //   if (userId != null &&
    //       response.requestOptions.path != "/users/$userId/refresh") {
    //     try {
    //       final path = "/users/$userId/refresh";
    //       final refreshToken = sharedPreferenceHelper.getString(refreshTokenKey);
    //
    //       RefreshTokenRequestModel requestModel =
    //       RefreshTokenRequestModel(refreshToken: refreshToken ?? "");
    //
    //       final result = await apiHelper.postRequest(
    //         path: path,
    //         body: requestModel.toJson(),
    //         create: () => RefreshTokenResponseModel(),
    //       );
    //
    //       await result.fold(
    //             (left) async {
    //           debugPrint("refresh token fold exception: $left");
    //           handler.resolve(response); // fallback to original response
    //         },
    //             (right) async {
    //           if (right.data != null) {
    //             final accessToken = right.data!.accessToken;
    //             final newRefreshToken = right.data!.refreshToken;
    //
    //             await sharedPreferenceHelper.setString(
    //                 refreshTokenKey, newRefreshToken ?? "");
    //             await sharedPreferenceHelper.setString(tokenKey, accessToken ?? "");
    //
    //             final updatedRequestOptions = response.requestOptions;
    //             updatedRequestOptions.headers = {
    //               'Authorization': 'Bearer $accessToken'
    //             };
    //
    //             final retryResult = await apiHelper.fetchRequest(
    //                 requestOptions: updatedRequestOptions);
    //
    //             retryResult.fold(
    //                   (err) {
    //                 debugPrint("Retry request failed: $err");
    //                 handler.resolve(response); // fallback to original response
    //               },
    //                   (retriedResponse) {
    //                 handler.resolve(retriedResponse); // successful retry
    //               },
    //             );
    //           } else {
    //             debugPrint("Failed to get new token: ${right.message}");
    //             handler.resolve(response); // fallback
    //           }
    //         },
    //       );
    //     } catch (e, stacktrace) {
    //       debugPrint("Exception during token refresh: $e\n$stacktrace");
    //       handler.resolve(response); // fallback to original
    //     }
    //     return;
    //   }
    // }
    // handler.next(response);

    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ref.read(customLoggerProvider).logRequest(options);
    options.validateStatus = (status) {
      return true;
    };
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    ref.read(customLoggerProvider).logError(error);
    handler.next(error);
  }
}
