import 'package:domain/model/response_model/digifit/digifit_fav_response_model.dart';

class DigifitFavScreenState {
  bool isLoading;
  List<DigifitFavData> equipmentList;
  bool isNextPageLoading;
  int pageNumber;

  DigifitFavScreenState(this.isLoading, this.equipmentList,
      this.isNextPageLoading, this.pageNumber);

  factory DigifitFavScreenState.empty() {
    return DigifitFavScreenState(true, [], false, 1);
  }

  DigifitFavScreenState copyWith(
      {bool? isLoading,
      List<DigifitFavData>? equipmentList,
      bool? isNextPageLoading,
      int? pageNumber}) {
    return DigifitFavScreenState(
        isLoading ?? this.isLoading,
        equipmentList ?? this.equipmentList,
        isNextPageLoading ?? this.isNextPageLoading,
        pageNumber ?? this.pageNumber);
  }
}
