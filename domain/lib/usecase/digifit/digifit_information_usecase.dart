import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/repo_impl/digifit/digifit_information_repo_impl.dart';

import '../../model/request_model/digifit/digifit_information_request_model.dart';

final digifitInformationUseCaseProvider = Provider((ref) =>
    DigifitInformationUseCase(
        digifitInformationRepository:
            ref.read(digifitInformationRepositoryProvider)));

class DigifitInformationUseCase implements UseCase<BaseModel, DigifitInformationRequestModel> {
  final DigifitInformationRepo digifitInformationRepository;

  DigifitInformationUseCase({required this.digifitInformationRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      DigifitInformationRequestModel requestModel, BaseModel responseModel) async {
    final result =
        await digifitInformationRepository.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
