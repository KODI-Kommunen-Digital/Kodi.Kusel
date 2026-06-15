import 'package:domain/model/response_model/filter/get_filter_response_model.dart';

class NewFilterScreenParams {
  List<String> selectedCategoryName;
  List<int> selectedCategoryId;
  int selectedCityId;
  String selectedCityName;
  double radius;
  DateTime startDate;
  DateTime endDate;

  NewFilterScreenParams(
      {required this.selectedCategoryName,
      required this.selectedCategoryId,
      required this.selectedCityId,
      required this.selectedCityName,
      required this.radius,
      required this.startDate,
      required this.endDate});
}
