import 'package:domain/model/response_model/digifit/brain_teaser_game/list_response_model.dart';

class BrainTeaserGameListState {
  bool isLoading;
  final BrainTeaserGameListDataModel? brainTeaserGameListDataModel;
  final String errorMessage;

  BrainTeaserGameListState({
    required this.isLoading,
    required this.brainTeaserGameListDataModel,
    this.errorMessage = '',
  });

  factory BrainTeaserGameListState.empty() {
    return BrainTeaserGameListState(
      isLoading: false,
      brainTeaserGameListDataModel: null,
      errorMessage: '',
    );
  }

  BrainTeaserGameListState copyWith({
    bool? isLoading,
    BrainTeaserGameListDataModel? brainTeaserGameListDataModel,
    String? errorMessage,
  }) {
    return BrainTeaserGameListState(
      isLoading: isLoading ?? this.isLoading,
      brainTeaserGameListDataModel:
          brainTeaserGameListDataModel ?? this.brainTeaserGameListDataModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
