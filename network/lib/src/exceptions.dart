import 'package:dio/dio.dart';

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

class CancelException extends DioException {
  CancelException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Request cancelled';
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

class OrganisationNotFoundException extends DioException {
  OrganisationNotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Organisation not found try switching the organisation or tr re-login';
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}

class UnknownException extends DioException {
  UnknownException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Something went wrong.';
  }
}

class ApiError implements Exception {
  ApiError({
    required this.error,
  });

  String error;

  @override
  String toString() {
    return error;
  }
}
