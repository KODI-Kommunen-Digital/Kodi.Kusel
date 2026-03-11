import 'package:core/base_model.dart';

class GetFavoritesRequestModel implements BaseModel<GetFavoritesRequestModel> {



  //filter

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


  GetFavoritesRequestModel({this.translate,
    this.pageNo,
    this.pageSize,
    this.sortByStartDate,
    this.statusId,
    this.categoryId,
    this.subcategoryId,
    this.cityId,
    this.startAfterDate,
    this.endBeforeDate,
    this.centerLatitude,
    this.centerLongitude,
    this.radius,});

  @override
  GetFavoritesRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
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
}
