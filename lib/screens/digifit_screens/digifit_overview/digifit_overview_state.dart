import 'package:domain/model/response_model/digifit/digifit_overview_response_model.dart';

class DigifitOverviewState {
  bool isLoading;
  final String errorMessage;
  final DigifitOverviewDataModel? digifitOverviewDataModel;


  DigifitOverviewState(
      {required this.isLoading,
      required this.errorMessage,
      this.digifitOverviewDataModel,
     });

  factory DigifitOverviewState.empty() {
    return DigifitOverviewState(
        isLoading: false,
        errorMessage: '',
        digifitOverviewDataModel: null);
  }

  DigifitOverviewState copyWith(
      {bool? isLoading,
      String? errorMessage,
      DigifitOverviewDataModel? digifitOverviewDataModel}) {
    return DigifitOverviewState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        digifitOverviewDataModel:
            digifitOverviewDataModel ?? this.digifitOverviewDataModel);
  }
}
