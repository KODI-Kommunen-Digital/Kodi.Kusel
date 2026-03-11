import 'package:core/base_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/municipal_party_detail/municipal_party_detail_service.dart';

final municipalPartyDetailRepoProvider = Provider((ref) =>
    MunicipalPartyDetailRepoImpl(
        municipalPartyDetailService:
            ref.read(municipalPartyDetailServiceProvider)));

abstract class MunicipalPartyDetailRepo {
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel);
}

class MunicipalPartyDetailRepoImpl implements MunicipalPartyDetailRepo {
  MunicipalPartyDetailService municipalPartyDetailService;

  MunicipalPartyDetailRepoImpl({required this.municipalPartyDetailService});

  @override
  Future<Either<Exception, BaseModel>> call(
      BaseModel requestModel, BaseModel responseModel) async {
    final result =
        await municipalPartyDetailService.call(requestModel, responseModel);

    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
