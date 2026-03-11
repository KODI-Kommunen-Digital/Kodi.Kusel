import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../locale/localization_manager.dart';

import 'text_to_speech_controller.dart';

enum TtsButtonSize { small, medium, large }

class TextToSpeechButton extends ConsumerWidget {
  final String ttsWidgetId;
  final List<String> texts;
  final TtsButtonSize size;
  final bool isDarkTheme;

  const TextToSpeechButton({
    super.key,
    required this.ttsWidgetId,
    required this.texts,
    this.size = TtsButtonSize.medium,
    this.isDarkTheme = false,
  });

  double getButtonSize() {
    switch (size) {
      case TtsButtonSize.small:
        return 22.h.w;
      case TtsButtonSize.medium:
        return 29.h.w;
      case TtsButtonSize.large:
        return 42.h.w;
    }
  }

  double getIconSize() {
    switch (size) {
      case TtsButtonSize.small:
        return 11.h.w;
      case TtsButtonSize.medium:
        return 16.h.w;
      case TtsButtonSize.large:
        return 23.h.w;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsState = ref.watch(textToSpeechControllerProvider);
    final controller = ref.read(textToSpeechControllerProvider.notifier);

    final locale =
    ref.read(localeManagerProvider).currentLocale.toLanguageTag();

    final primaryColor = isDarkTheme
        ? Theme.of(context).canvasColor
        : Theme.of(context).colorScheme.primary;

    final isCurrentWidgetPlaying =
        ttsState.isPlaying && ttsState.ttsWidgetId == ttsWidgetId;

    final buttonSize = getButtonSize();
    final iconSize = getIconSize();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// PLAY / STOP BUTTON
        GestureDetector(
          onTap: () async {
            if (isCurrentWidgetPlaying) {
              await controller.stop();
            } else {
              await controller.play(
                language: locale,
                texts: texts,
                ttsWidgetId: ttsWidgetId,
              );
            }
          },
          child: Container(
            height: buttonSize,
            width: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor.withOpacity(0.1),
            ),
            child: Icon(
              isCurrentWidgetPlaying ? Icons.stop : Icons.volume_up,
              color: primaryColor,
              size: iconSize,
            ),
          ),
        ),

        /// PAUSE / RESUME
        if (isCurrentWidgetPlaying) ...[
          SizedBox(width: 6.h),
          GestureDetector(
            onTap: () {
              if (ttsState.isPaused) {
                controller.resume(texts);
              } else {
                controller.pause();
              }
            },
            child: Container(
              height: buttonSize,
              width: buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.1),
              ),
              child: Icon(
                ttsState.isPaused ? Icons.play_arrow : Icons.pause,
                color: primaryColor,
                size: iconSize,
              ),
            ),
          ),
        ],
      ],
    );
  }
}