import 'package:core/base_model.dart';

import 'digifit_information_response_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'digifit_cache_data_response_model.g.dart';

@HiveType(typeId: 1)
class DigifitCacheDataResponseModel
    extends BaseModel<DigifitCacheDataResponseModel> {
  @HiveField(0)
  final String status;
  @HiveField(1)
  final DigifitInformationDataModel data;

  DigifitCacheDataResponseModel({
    this.status = '',
    DigifitInformationDataModel? data,
  }) : data = data ?? DigifitInformationDataModel();

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }

  @override
  DigifitCacheDataResponseModel fromJson(Map<String, dynamic> json) {
    return DigifitCacheDataResponseModel(
      status: json['status'] ?? '',
      data: DigifitInformationDataModel().fromJson(json['data'] ?? {}),
    );
  }
}