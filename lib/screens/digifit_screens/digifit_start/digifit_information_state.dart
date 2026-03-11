import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';

class DigifitState {
  bool isLoading;
  final DigifitInformationDataModel? digifitInformationDataModel;
  final String errorMessage;

  DigifitState(
      {required this.isLoading,
      required this.digifitInformationDataModel,
      this.errorMessage = '',
      });

  factory DigifitState.empty() {
    return DigifitState(
        isLoading: false,
        digifitInformationDataModel: null,
        errorMessage: '',
        );
  }

  DigifitState copyWith(
      {bool? isLoading,
      DigifitInformationDataModel? digifitInformationDataModel,
      String? errorMessage,
      bool? isNetworkAvailable}) {
    return DigifitState(
        isLoading: isLoading ?? this.isLoading,
        digifitInformationDataModel:
            digifitInformationDataModel ?? this.digifitInformationDataModel,
        errorMessage: errorMessage ?? this.errorMessage,
        );
  }
}
