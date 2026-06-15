import 'package:core/base_model.dart';

class RecommendationsRequestModel
    implements BaseModel<RecommendationsRequestModel> {
  final String? categoryId;
  String? translate;

  RecommendationsRequestModel({required this.translate, this.categoryId});

  @override
  RecommendationsRequestModel fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {"translate": translate, "categoryId": categoryId};
  }
}
