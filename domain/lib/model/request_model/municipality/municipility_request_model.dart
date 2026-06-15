import 'package:core/base_model.dart';

class MunicipalityRequestModel  extends BaseModel<MunicipalityRequestModel>{
  final int municipalityId;

  MunicipalityRequestModel({required this.municipalityId});

  @override
  Map<String, dynamic> toJson() {
    return {
      'municipalityId': municipalityId
    };
  }

  @override
  MunicipalityRequestModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
