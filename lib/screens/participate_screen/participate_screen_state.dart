import 'package:domain/model/response_model/participate/participate_response_model.dart';

class ParticipateScreenState {
  bool isLoading;
  ParticipateData? participateData;

  ParticipateScreenState(this.isLoading, this.participateData);

  factory ParticipateScreenState.empty() {
    return ParticipateScreenState(false, null);
  }

  ParticipateScreenState copyWith(
      {bool? isLoading, ParticipateData? participateData}) {
    return ParticipateScreenState(
        isLoading ?? this.isLoading, participateData ?? this.participateData);
  }
}
