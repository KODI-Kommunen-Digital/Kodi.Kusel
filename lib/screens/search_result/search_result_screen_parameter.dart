class SearchResultScreenParameter {
  SearchType searchType;

  SearchResultScreenParameter({
    required this.searchType,
  });
}

enum SearchType {
    recommendations,
    nearBy
}
