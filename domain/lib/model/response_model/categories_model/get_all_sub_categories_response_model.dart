import 'package:core/base_model.dart';

class GetAllSubCategoriesResponseModel extends BaseModel<GetAllSubCategoriesResponseModel> {
  String? status;
  List<SubCategory>? data;

  GetAllSubCategoriesResponseModel({this.status, this.data});

  @override
  GetAllSubCategoriesResponseModel fromJson(Map<String, dynamic> json) {
    return GetAllSubCategoriesResponseModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)?.map((item) => SubCategory.fromJson(item)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class SubCategory {
  int? id;
  String? name;
  int? categoryId;

  SubCategory({this.id, this.name, this.categoryId});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'] as int?,
      name: json['name'] as String?,
      categoryId: json['categoryId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
    };
  }
}
