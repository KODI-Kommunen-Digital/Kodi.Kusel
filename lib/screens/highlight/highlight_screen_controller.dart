import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/highlight/highlight_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/highlight/highlight_screen_state.dart';
import 'package:domain/model/request_model/highligt/highlight_request_model.dart';

final highlightScreenProvider =
    StateNotifierProvider<HighlightScreenController, HighlightScreenState>(
        (ref) => HighlightScreenController(
            highlightUseCase: ref.read(highlightUseCaseProvider)));

class HighlightScreenController extends StateNotifier<HighlightScreenState> {
  HighlightUseCase highlightUseCase;

  HighlightScreenController({required this.highlightUseCase})
      : super(HighlightScreenState.empty());

  Future<void> getHighlight() async {
    try {
      state = state.copyWith(loading: true, error: "");

      HighlightRequestModel highlightRequestModel = HighlightRequestModel(
        categoryId: "41",
      );

      GetAllListingsResponseModel getAllListingsResponseModel =
          GetAllListingsResponseModel();
      final result = await highlightUseCase.call(
          highlightRequestModel, getAllListingsResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(loading: false, error: l.toString());
        },
        (r) {
          var highlights = (r as GetAllListingsResponseModel).data;
          state = state.copyWith(listings: highlights, loading: false);
          debugPrint("Highlight Status - ${r.status.toString()}");
          debugPrint("Highlight data - ${highlights.toString()}");
        },
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }
}
