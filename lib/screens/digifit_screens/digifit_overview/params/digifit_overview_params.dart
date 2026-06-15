import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';

class DigifitOverviewScreenParams {
  final DigifitInformationParcoursModel parcoursModel;
  void Function()? onFavChange;

  DigifitOverviewScreenParams({required this.parcoursModel,
  this.onFavChange
  });
}
