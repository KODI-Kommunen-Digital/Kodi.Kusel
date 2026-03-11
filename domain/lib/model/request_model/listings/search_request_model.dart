import 'dart:convert';
import 'package:core/base_model.dart';

class SearchRequestModel extends BaseModel<SearchRequestModel> {

  final String searchQuery;
  String? translate;


  SearchRequestModel({
    required this.searchQuery,
    required this.translate
  });

  @override
  SearchRequestModel fromJson(Map<String, dynamic> json) {
    return SearchRequestModel(
      searchQuery: json['searchQuery'] ?? "",
      translate: json['translate'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'searchQuery': searchQuery,
      'translate': translate,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
