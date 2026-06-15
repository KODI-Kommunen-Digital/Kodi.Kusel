import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:network/src/dio_factory.dart';

import 'exceptions.dart';

class ApiHelper<E extends BaseModel> {
  final Dio _dio;
  CreateModel<E>? errorModel;
  final String fallbackErrorMessage;

  ApiHelper._internal(
    this._dio, {
    this.errorModel,
    required this.fallbackErrorMessage,
  });

  factory ApiHelper({
    required DioHelper dioHelper,
    CreateModel<E>? errorModel,
    String? fallbackErrorMessage,
  }) {
    return ApiHelper._internal(
      dioHelper.createDio(),
      fallbackErrorMessage: fallbackErrorMessage ??
          "Unknown error occurred, please try again later.",
      errorModel: errorModel,
    );
  }

  String? _extractErrorMessage(dynamic data) {
    try {
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      } else if (data is String) {
        return data;
      }
    } catch (_) {}
    return null;
  }

  Future<Either<Exception, T>> postRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode != null && response.statusCode! >= 300) {
        final errorMessage = _extractErrorMessage(response.data);
        return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
      }

      return Right(create().fromJson(response.data));
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
    } catch (e) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
  }

  Future<Either<Exception, T>> postFormRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    FormData? body,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.post(
        path,
        data: body,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      if (response.statusCode != null && response.statusCode! >= 300) {
        final errorMessage = _extractErrorMessage(response.data);
        return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
      }

      return Right(create().fromJson(response.data));
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
    } catch (e) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
  }

  Future<Either<Exception, List<T>>> postListRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.post(
        path,
        data: body,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode != null && response.statusCode! >= 300) {
        final errorMessage = _extractErrorMessage(response.data);
        return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
      }

      return Right(create().fromJson(response.data));
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
    } catch (e) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
  }

  Future<Either<Exception, T>> getRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.get(
        path,
        queryParameters: params,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      if (response.statusCode != null && response.statusCode! >= 300) {
        final errorMessage = _extractErrorMessage(response.data);
        return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
      }

      return Right(create().fromJson(response.data));
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
    } catch (e) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
  }

  Future<Either<Exception, T>> delete<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    try{
    var response = await _dio
        .delete(path,
        queryParameters: params,
        options: Options(headers: headers),
        cancelToken: cancelToken);

    if (response.statusCode != null && response.statusCode! >= 300) {
      final errorMessage = _extractErrorMessage(response.data);
      return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
    }

    return Right(create().fromJson(response.data));

  }on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
    } catch (e) {
      return Left(ApiError(error: fallbackErrorMessage));
    }

  }

  Future<Either<Exception, List<T>>> getListRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio
        .get(
      path,
      queryParameters: params,
      options: Options(headers: headers),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    )
        .catchError((error) {
      return Response(
        requestOptions: RequestOptions(path: ''),
        statusMessage: error.toString(),
        statusCode: 999,
      );
    });
    try {
      if (response.data is List) {
        return Right((response.data as List)
            .map<T>((e) => create().fromJson(e))
            .toList());
      } else {
        return Left(ApiError(error: "Response is not list type"));
      }
    } on Exception catch (e) {
      return Left(e);
    } catch (error) {
      try {
        return Left(ApiError(
            error: errorModel != null
                ? errorModel!().fromJson(response.data).message
                : fallbackErrorMessage));
      } catch (error) {
        return Left(ApiError(error: fallbackErrorMessage));
      }
    }
  }

  Future<Either<Exception, List<int>>> getByteArray({
    required String path,
    CancelToken? cancelToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await Dio().post<List<int>>(
      path,
      data: body,
      options: Options(responseType: ResponseType.bytes),
    );
    try {
      if (response.data != null && response.data is List<int>) {
        return Right(response.data!);
      } else {
        return Left(ApiError(error: "Response is not list type"));
      }
    } on Exception catch (e) {
      return Left(e);
    } catch (error) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
  }

  Future<Either<Exception, T>> putRequest<T extends BaseModel>({
    required String path,
    required CreateModel<T> create,
    CancelToken? cancelToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.put(
        path,
        data: body,
        options: Options(headers: headers),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode != null && response.statusCode! >= 300) {
        final errorMessage = _extractErrorMessage(response.data);
        return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
      }

      return Right(create().fromJson(response.data));
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
    } catch (e) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
  }

  Future<Either<Exception, T>> patchRequest<T extends BaseModel>(
      {required String path,
      required CreateModel<T> create,
      Map<String, dynamic>? body,
      Map<String, dynamic>? headers}) async {
    try {
      var response = await _dio.patch(path,
          data: body, options: Options(headers: headers));

      if (response.statusCode != null && response.statusCode! >= 300) {
        final errorMessage = _extractErrorMessage(response.data);
        return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
      }

      return Right(create().fromJson(response.data));
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
    } catch (e) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
  }

  // 'GET REQUEST' TO get whole url from the shortHand Url.
  Future<Either<Exception, String>> getRequestUrlHelper({
    required String shortUrl,
    int maxRedirects = 5,
  }) async {
    try {
      var response = await _dio.get(
        shortUrl,
        options: Options(
            followRedirects: true,
            maxRedirects: maxRedirects,
            validateStatus: (status) => status != null && status < 500),
      );

      return Right(response.realUri.toString());
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e.response?.data);
      return Left(ApiError(error: errorMessage ?? fallbackErrorMessage));
    } catch (e) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
  }
}

extension DioFetchExtension<E extends BaseModel> on ApiHelper<E> {
  Future<Either<Exception, Response>> fetchRequest({
    required RequestOptions requestOptions,
  }) async {
    try {
      final response = await _dio.fetch(requestOptions);
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiError(error: e.message ?? fallbackErrorMessage));
    } catch (e) {
      return Left(ApiError(error: fallbackErrorMessage));
    }
  }
}
