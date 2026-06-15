import 'package:domain/model/response_model/digifit/digifit_user_trophies_response_model.dart';

class DigifitUserTrophiesState {
  bool isLoading;
  final DigifitUserTrophyDataModel? digifitUserTrophyDataModel;
  final bool isAllTrophiesExpanded;
  final bool isReceivedTrophiesExpanded;
  final String errorMessage;

  DigifitUserTrophiesState(
      {required this.isLoading,
      required this.digifitUserTrophyDataModel,
      required this.isReceivedTrophiesExpanded,
      required this.isAllTrophiesExpanded,
      this.errorMessage = ''});

  factory DigifitUserTrophiesState.empty() {
    return DigifitUserTrophiesState(
        isLoading: false,
        digifitUserTrophyDataModel: null,
        isReceivedTrophiesExpanded: false,
        isAllTrophiesExpanded: false,
        errorMessage: '');
  }

  DigifitUserTrophiesState copyWith(
      {bool? isLoading,
      DigifitUserTrophyDataModel? digifitUserTrophyDataModel,
      bool? isAllTrophiesExpanded,
      bool? isReceivedTrophiesExpanded,
      String? errorMessage}) {
    return DigifitUserTrophiesState(
      isLoading: isLoading ?? this.isLoading,
      isAllTrophiesExpanded:
          isAllTrophiesExpanded ?? this.isAllTrophiesExpanded,
      isReceivedTrophiesExpanded:
          isReceivedTrophiesExpanded ?? this.isReceivedTrophiesExpanded,
      digifitUserTrophyDataModel:
          digifitUserTrophyDataModel ?? this.digifitUserTrophyDataModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
