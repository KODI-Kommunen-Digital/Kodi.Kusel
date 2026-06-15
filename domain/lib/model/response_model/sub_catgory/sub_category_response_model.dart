import 'package:core/base_model.dart';

class SubCategoryResponseModel implements BaseModel<SubCategoryResponseModel>
{

  final String? status;
  final List<SubCategoryData>? data;
  SubCategoryResponseModel({this.status, this.data});
  @override
  SubCategoryResponseModel fromJson(Map<String, dynamic> json) {
    return SubCategoryResponseModel(
      status: json['status'] as String?,
      data: (json['data'] as List?)?.map((item) => SubCategoryData.fromJson(item)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}

class SubCategoryData {
  final int? id;
  final String? name;
  final int? categoryId;
  final String? image;

  SubCategoryData({this.id, this.name, this.categoryId, this.image});

  factory SubCategoryData.fromJson(Map<String, dynamic> json) {
    return SubCategoryData(
      id: json['id'] as int?,
      name: json['name'] as String?,
      categoryId: json['categoryId'] as int?,
      image: json['image']
    );
  }
}
