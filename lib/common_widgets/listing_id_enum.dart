enum ListingCategoryId {
  event(3),
  news(1),
  highlights(41);

  final int eventId;

  const ListingCategoryId(this.eventId);
}

enum SearchRadius {
  radius(20);

  final int value;

  const SearchRadius(this.value);
}
