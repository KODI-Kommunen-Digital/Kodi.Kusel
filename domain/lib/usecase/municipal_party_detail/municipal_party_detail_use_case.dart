import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:data/repo_impl/municipal_party_detail/municipal_party_detail_repo_impl.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final municipalPartyDetailUseCaseProvider = Provider((ref) =>
    MunicipalPartyDetailUseCase(
        municipalPartyDetailRepository:
            ref.read(municipalPartyDetailRepoProvider)));

class MunicipalPartyDetailUseCase
    implements UseCase<BaseModel, GetAllListingsResponseModel> {
  MunicipalPartyDetailRepo municipalPartyDetailRepository;

  MunicipalPartyDetailUseCase({required this.municipalPartyDetailRepository});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await municipalPartyDetailRepository.call(requestModel, responseModel);
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
