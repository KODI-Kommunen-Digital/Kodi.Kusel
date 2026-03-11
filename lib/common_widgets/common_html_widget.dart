import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher.dart';

class CommonHtmlWidget extends ConsumerStatefulWidget {
  final String data;
  final double? fontSize;
  final int? maxLines;

  const CommonHtmlWidget(
      {super.key, required this.data, this.fontSize, this.maxLines});

  @override
  ConsumerState<CommonHtmlWidget> createState() => _CommonHtmlWidgetState();
}

class _CommonHtmlWidgetState extends ConsumerState<CommonHtmlWidget> {
  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty) return;

    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: widget.data,
      style: {
        "body": Style(
          fontSize: FontSize(widget.fontSize ?? 12.sp),
          color: Theme.of(context).textTheme.bodyLarge?.color,
          textAlign: TextAlign.left,
          backgroundColor: Colors.transparent,
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        "a": Style(
          color: Theme.of(context).primaryColor,
          textDecoration: TextDecoration.underline,
        ),
      },
      onLinkTap: (url, attributes, element) {
        _launchUrl(url);
      },
    );
  }
}

String stripHtmlTags(String htmlString) {
  final document = html_parser.parse(htmlString);
  return document.body?.text ?? "";
}
