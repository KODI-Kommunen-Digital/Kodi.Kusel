import 'package:core/base_model.dart';

class GetLegalPolicyResponseModel implements BaseModel<GetLegalPolicyResponseModel> {
  String? status;
  LegalPolicyData? data;

  GetLegalPolicyResponseModel({this.status, this.data});

  @override
  GetLegalPolicyResponseModel fromJson(Map<String, dynamic> json) {
    return GetLegalPolicyResponseModel(
      status: json['status'],
      data: json['data'] != null ? LegalPolicyData().fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class LegalPolicyData implements BaseModel<LegalPolicyData> {
  String? type;
  String? content;

  LegalPolicyData({this.type, this.content});

  @override
  LegalPolicyData fromJson(Map<String, dynamic> json) {
    return LegalPolicyData(
      type: json['type'],
      content: json['content'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['type'] = type;
    map['content'] = content;
    return map;
  }
}
