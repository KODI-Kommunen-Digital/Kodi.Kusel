import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtil {
  /// Launches a web URL in the browser.
  static Future<void> launchWebUrl({required String url}) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
        uri,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
      ),    )) {
      throw 'Could not launch URL: $url';
    }
  }

  /// Launches the phone dialer with a given number.
  static Future<void> launchDialer({required String phoneNumber}) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(uri)) {
      throw 'Could not launch dialer for: $phoneNumber';
    }
  }

  /// Launches the email client with a given email address.
  static Future<void> launchEmail({required String emailAddress}) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    if (!await launchUrl(uri)) {
      throw 'Could not launch email client for: $emailAddress';
    }
  }

  /// Opens the location in the maps app or browser fallback.
  static Future<void> launchMap(
      {required double latitude, required double longitude}) async {
    final Uri geoUri = Uri.parse('geo:$latitude,$longitude');
    final Uri webUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch any map app or browser.';
    }
  }
}
