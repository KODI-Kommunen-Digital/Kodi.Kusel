import 'package:flutter/material.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebViewPage extends ConsumerStatefulWidget {
  final WebViewParams webViewParams;

  const WebViewPage({super.key, required this.webViewParams});

  @override
  ConsumerState<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends ConsumerState<WebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.webViewParams.url));
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: widget.webViewParams.url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Link copied to clipboard")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.webViewParams.url),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => ref.read(navigationProvider).removeTopPage(context: context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: _copyLink,
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class WebViewParams {
  String url;
  WebViewParams({required this.url});
}
