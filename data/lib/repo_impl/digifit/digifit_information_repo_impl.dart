import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/digifit_services/digifit_information_services.dart';

final digifitInformationRepositoryProvider = Provider(
    (ref) => DigifitInformationRepoImpl(digifitInformationService: ref.read(digifitInformationServiceProvider)));

abstract class DigifitInformationRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class DigifitInformationRepoImpl implements DigifitInformationRepo {
  DigifitInformationService digifitInformationService;

  DigifitInformationRepoImpl({required this.digifitInformationService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result = await digifitInformationService.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}