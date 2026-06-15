import 'package:domain/model/response_model/digifit/brain_teaser_game/details_response_model.dart';

class BrainTeaserGameDetailsState {
  bool isLoading;
  final GameDetailsDataModel? gameDetailsDataModel;
  final String errorMessage;

  BrainTeaserGameDetailsState({
    required this.isLoading,
    required this.gameDetailsDataModel,
    this.errorMessage = '',
  });

  factory BrainTeaserGameDetailsState.empty() {
    return BrainTeaserGameDetailsState(
      isLoading: false,
      gameDetailsDataModel: null,
      errorMessage: '',
    );
  }

  BrainTeaserGameDetailsState copyWith({
    bool? isLoading,
    GameDetailsDataModel? gameDetailsDataModel,
    String? errorMessage,
  }) {
    return BrainTeaserGameDetailsState(
      isLoading: isLoading ?? this.isLoading,
      gameDetailsDataModel: gameDetailsDataModel ?? this.gameDetailsDataModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
