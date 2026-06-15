import 'package:core/base_model.dart';

class MunicipalPartyDetailRequestModel
    implements BaseModel<MunicipalPartyDetailRequestModel> {
  String municipalId;
  String translate;

  MunicipalPartyDetailRequestModel({required this.municipalId, required this.translate});

  @override
  MunicipalPartyDetailRequestModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"municipalId": municipalId, "translate": translate};
  }
}
