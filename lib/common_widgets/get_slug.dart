String getSlugFromUrl(String url) {
  Uri uri = Uri.parse(url);
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  return segments.isNotEmpty ? segments.last : "";
}