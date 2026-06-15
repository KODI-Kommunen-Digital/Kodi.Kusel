import 'package:flutter/cupertino.dart';

String imageLoaderUtility({required String image, required int sourceId}) {
  if (sourceId == 1) {
    return "https://kusel1heidi.obs.eu-de.otc.t-systems.com/$image";

  } else {
    final url = stripBase64ImageHeader(image);
    return url;
  }
}

String stripBase64ImageHeader(String input) {
  // Matches: data:image/<subtype>;base64,
  final headerPattern = RegExp(r'^data:image\/[A-Za-z0-9.+-]+;base64,');

  if (headerPattern.hasMatch(input)) {
    return "https://www.vg-lw.de/kalender/2025-02-06-musikschule/plakat-zauberland-lauterecken-zauberer-januar-2025.pub.jpg?cid=1bay.79mp&resize=810x230c";
  }

  return input;
}
