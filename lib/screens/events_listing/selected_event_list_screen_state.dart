import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class SelectedEventListScreenState {
  String address;
  String error;
  bool loading;
  List<Listing> eventsList;
  bool isUserLoggedIn;
  String heading;
  int currentPageNo;
  bool isMoreListLoading;
  bool isLoadMoreButtonEnabled;

  SelectedEventListScreenState(
      this.address,
      this.error,
      this.loading,
      this.eventsList,
      this.isUserLoggedIn,
      this.heading,
      this.currentPageNo,
      this.isMoreListLoading,
      this.isLoadMoreButtonEnabled);

  factory SelectedEventListScreenState.empty() {
    return SelectedEventListScreenState(
        '', '', false, [], false, '', 1, false, true);
  }

  SelectedEventListScreenState copyWith(
      {String? address,
      String? error,
      bool? loading,
      List<Listing>? list,
      bool? isUserLoggedIn,
      String? heading,
      int? currentPageNo,
      bool? isMoreListLoading,
      bool? isLoadMoreButtonEnabled}) {
    return SelectedEventListScreenState(
        address ?? this.address,
        error ?? this.error,
        loading ?? this.loading,
        list ?? eventsList,
        isUserLoggedIn ?? this.isUserLoggedIn,
        heading ?? this.heading,
        currentPageNo ?? this.currentPageNo,
        isMoreListLoading ?? this.isMoreListLoading,
        isLoadMoreButtonEnabled ?? this.isLoadMoreButtonEnabled);
  }
}
