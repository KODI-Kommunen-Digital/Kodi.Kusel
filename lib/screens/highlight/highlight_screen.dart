import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/highlight/highlight_screen_controller.dart';

class HighlightScreen extends ConsumerStatefulWidget {
  const HighlightScreen({super.key});

  @override
  ConsumerState<HighlightScreen> createState() => _HighlightScreenState();
}

class _HighlightScreenState extends ConsumerState<HighlightScreen> {

  @override
  void initState() {
    Future.microtask((){
      ref.read(highlightScreenProvider.notifier).getHighlight();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Highlight Screen"),
      ).loaderDialog(context, ref.watch(highlightScreenProvider).loading),
    );
  }
}
