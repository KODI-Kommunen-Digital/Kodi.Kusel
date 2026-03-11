import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';

class DigifitExerciseDetailsParams {
  final DigifitInformationStationModel station;
  void Function()? onFavCallBack;
  int? locationId;
  String? slug;

  DigifitExerciseDetailsParams(
      {required this.station, this.onFavCallBack, this.locationId, this.slug});
}
