import 'package:flutter/cupertino.dart';

String videoPlayerUtility(String videoUrl, int sourceId) {
  if (sourceId == 1) {
    return "https://kusel1heidi.obs.eu-de.otc.t-systems.com/$videoUrl";
  } else {
    return stripInvalidVideoFormat(videoUrl);
  }
}

String stripInvalidVideoFormat(String input) {
  final headerPattern = RegExp(r'^data:video\/[A-Za-z0-9.+-]+;base64,');

  if (headerPattern.hasMatch(input)) {
    return "https://samplelib.com/lib/preview/mp4/sample-5s.mp4";
  }
  return input;
}