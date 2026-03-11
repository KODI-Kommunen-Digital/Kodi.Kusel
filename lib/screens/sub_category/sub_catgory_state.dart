import 'package:domain/model/response_model/sub_catgory/sub_category_response_model.dart';

class SubCategoryState {
  bool isLoading;
  List<SubCategoryData> subCategoryDataList;

  SubCategoryState(this.isLoading, this.subCategoryDataList);

  factory SubCategoryState.empty() {
    return SubCategoryState(false, []);
  }

  SubCategoryState copyWith(
      {bool? isLoading, List<SubCategoryData>? subCategoryDataList}) {
    return SubCategoryState(isLoading ?? this.isLoading,
        subCategoryDataList ?? this.subCategoryDataList);
  }
}
