import 'package:core/base_model.dart';

class GetLegalPolicyRequestModel implements BaseModel<GetLegalPolicyRequestModel>{

  String translate;
  String policyType;

  GetLegalPolicyRequestModel({required this.translate,required this.policyType});

  @override
  GetLegalPolicyRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'translate':translate,
      'policyType':policyType
    };
  }

}