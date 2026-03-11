enum LocaleConstant {
  english("English", "en", "GB"),
  // German
  german("Deutsch", "de", "DE");

  final String displayName;
  final String languageCode;
  final String region;

  const LocaleConstant(this.displayName, this.languageCode, this.region);
}
