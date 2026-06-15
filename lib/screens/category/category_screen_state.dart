import 'package:domain/model/response_model/categories_model/get_all_categories_response_model.dart';

class CategoryScreenState {
  bool loading;
  String error;
  String status;
  final List<Category> exploreCategories;

  CategoryScreenState(
      this.exploreCategories, this.status, this.error, this.loading);

  factory CategoryScreenState.empty() {
    return CategoryScreenState([], "", "", false);
  }

  CategoryScreenState copyWith(
      {String? status,
      List<Category>? exploreCategories,
      bool? loading,
      String? error}) {
    return CategoryScreenState(exploreCategories ?? this.exploreCategories,
        status ?? this.status, error ?? this.error, loading ?? this.loading);
  }
}
