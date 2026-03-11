import 'package:dio/dio.dart';

import 'exceptions.dart';

class ExceptionInterceptor extends Interceptor {
  ExceptionInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
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
      case DioExceptionType.connectionError:
        throw NoInternetConnectionException(err.requestOptions);
      case DioExceptionType.unknown:
        throw UnknownException(err.requestOptions);
      case DioExceptionType.badCertificate:
        throw BadRequestException(err.requestOptions);
      case DioExceptionType.cancel:
        throw CancelException(err.requestOptions);
    }

    return handler.next(err);
  }
}
