import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class HighlightScreenState {
  bool loading;
  String error;
  final List<Listing> listings;

  HighlightScreenState(this.loading, this.error, this.listings);

  factory HighlightScreenState.empty() {
    return HighlightScreenState(false, '', []);
  }

  HighlightScreenState copyWith(
      {bool? loading, String? error, List<Listing>? listings}) {
    return HighlightScreenState(loading ?? this.loading, error ?? this.error,
        listings ?? this.listings);
  }
}
