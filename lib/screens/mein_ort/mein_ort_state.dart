import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';

class MeinOrtState {
  final bool isLoading;
  final int highlightCount;
  final List<Municipality> municipalityList;
  final String description;
  bool isUserLoggedIn;

  MeinOrtState(this.isLoading, this.highlightCount, this.description,
      this.municipalityList, this.isUserLoggedIn);

  factory MeinOrtState.empty() {
    return MeinOrtState(false, 0, "", [], false);
  }

  MeinOrtState copyWith(
      {bool? isLoading,
      int? highlightCount,
      String? description,
      List<Municipality>? municipalityList,
      bool? isUserLoggedIn}) {
    return MeinOrtState(
        isLoading ?? this.isLoading,
        highlightCount ?? this.highlightCount,
        description ?? this.description,
        municipalityList ?? this.municipalityList,
        isUserLoggedIn ?? this.isUserLoggedIn);
  }
}
