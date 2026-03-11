import 'dart:convert';
import 'package:core/base_model.dart';

class GetAllListingsRequestModel extends BaseModel<GetAllListingsRequestModel> {
  int? pageNo;
  final int? pageSize;
  final bool? sortByStartDate;
  final String? statusId;
  String? categoryId;
  final String? subcategoryId;
  String? cityId;
   String? translate;
  String? startAfterDate;
  String? endBeforeDate;
   double? centerLatitude;
   double? centerLongitude;
   int? radius;


  GetAllListingsRequestModel({
    this.pageNo,
    this.pageSize,
    this.sortByStartDate,
    this.statusId,
    this.categoryId,
    this.subcategoryId,
    this.cityId,
    this.translate,
    this.startAfterDate,
    this.endBeforeDate,
    this.centerLatitude,
    this.centerLongitude,
    this.radius,
  });

  @override
  GetAllListingsRequestModel fromJson(Map<String, dynamic> json) {
    return GetAllListingsRequestModel(
      pageNo: json['pageNo'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      sortByStartDate: json['sortByStartDate'] ?? false,
      statusId: json['statusId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      subcategoryId: json['subcategoryId'] ?? '',
      cityId: json['cityId'] ?? '',
      translate: json['translate'] ?? '',
      startAfterDate: json['startAfterDate'] ?? '',
      endBeforeDate: json['endBeforeDate'] ?? '',
      centerLatitude: (json['centerLatitude'] as num?)?.toDouble(),
      centerLongitude: (json['centerLongitude'] as num?)?.toDouble(),
      radius: json['radius'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = {
      'pageNo': pageNo,
      'pageSize': pageSize,
      'sortByStartDate': sortByStartDate,
      'statusId': statusId,
      'categoryId': categoryId,
      'subcategoryId': subcategoryId,
      'cityId': cityId,
      'translate': translate,
      'startAfterDate': startAfterDate,
      'endBeforeDate': endBeforeDate,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'radius': radius,
    };
    data.removeWhere(
        (key, value) => value == null || (value is String && value.isEmpty));
    return data;
  }

  @override
  String toString() => jsonEncode(toJson());
}
