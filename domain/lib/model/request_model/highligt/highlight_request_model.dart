import 'dart:convert';
import 'package:core/base_model.dart';

class HighlightRequestModel extends BaseModel<HighlightRequestModel> {
  final String categoryId;

  HighlightRequestModel({
    required this.categoryId,
  });

  @override
  HighlightRequestModel fromJson(Map<String, dynamic> json) {
    return HighlightRequestModel(categoryId: json['categoryId'] ?? '');
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
