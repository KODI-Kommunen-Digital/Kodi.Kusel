import 'package:flutter/cupertino.dart';

import '../../l10n/app_localizations.dart';

class FilterCategory {
  final int categoryId;
  final String categoryName;
  final String imagePath;

  FilterCategory({
    required this.categoryId,
    required this.categoryName,
    required this.imagePath,
  });
}

List<FilterCategory> staticFilterCategoryList(BuildContext context) {
  final localization = AppLocalizations.of(context);

  return [
    FilterCategory(
      categoryId: 13,
      categoryName: localization.location_map_eat_drink,
      imagePath: "gastro_category_icon",
    ),
    FilterCategory(
      categoryId: 3,
      categoryName: localization.location_map_events,
      imagePath: "event_category_icon",
    ),
    FilterCategory(
      categoryId: 17,
      categoryName: localization.location_map_free_time,
      imagePath: "tourism_service_map_image",
    ),
    FilterCategory(
      categoryId: 41,
      categoryName: localization.highlights,
      imagePath: "highlights_map",
    ),
    FilterCategory(
      categoryId: 1,
      categoryName: localization.news,
      imagePath: "event_category_icon",
    ),
 // TODO: Mark the categoryId as 100 (there is no such categoryId). This is just to simplify the logic.
    FilterCategory(
      categoryId: 100,
      categoryName: localization.map_fav,
      imagePath: "fav_category_icon",
    ),
  ];
}
