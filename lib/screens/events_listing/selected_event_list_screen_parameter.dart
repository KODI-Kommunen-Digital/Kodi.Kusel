class SelectedEventListScreenParameter {
  int? categoryId;
  int? subCategoryId;
  String? listHeading;
  double? centerLatitude;
  double? centerLongitude;
  int? radius;
  int? cityId;
  void Function() onFavChange;

  SelectedEventListScreenParameter(
      {this.categoryId,
      this.subCategoryId,
      required this.listHeading,
      this.centerLatitude,
      this.centerLongitude,
      this.radius,
      this.cityId,
      required this.onFavChange});
}
