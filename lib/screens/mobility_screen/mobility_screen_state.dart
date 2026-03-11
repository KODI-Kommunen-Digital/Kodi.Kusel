import 'package:domain/model/response_model/mobility/mobility_response_model.dart';

class MobilityScreenState {
  bool isLoading;
  MobilityData? mobilityData;

  MobilityScreenState(this.isLoading, this.mobilityData);

  factory MobilityScreenState.empty() {
    return MobilityScreenState(false, null);
  }

  MobilityScreenState copyWith({bool? isLoading, MobilityData? mobilityData}) {
    return MobilityScreenState(
        isLoading ?? this.isLoading,
        mobilityData ?? this.mobilityData);
  }
}
