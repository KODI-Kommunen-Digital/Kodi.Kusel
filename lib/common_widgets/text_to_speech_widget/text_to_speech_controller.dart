import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'text_to_speech_state.dart';

final textToSpeechControllerProvider = StateNotifierProvider<
    TextToSpeechController, TextToSpeechState>(
      (ref) => TextToSpeechController(),
);

class TextToSpeechController extends StateNotifier<TextToSpeechState> {
  final FlutterTts _flutterTts = FlutterTts();

  TextToSpeechController() : super(TextToSpeechState.empty()) {
    _initTts();
  }

  void _initTts() {
    _flutterTts.setCompletionHandler(() => _resetState());
    _flutterTts.setCancelHandler(() => _resetState());
    _flutterTts.setErrorHandler((_) => _resetState());

    _flutterTts.setSpeechRate(0.5);
  }

  void _resetState() {
    if (mounted) {
      state = state.copyWith(
        isPlaying: false,
        isPaused: false,
        ttsWidgetId: ""
      );
    }
  }

  Future<void> play({
    required String language,
    required List<String> texts,
    required String ttsWidgetId
  }) async {
    final combinedText = texts.where((e) => e.trim().isNotEmpty).join(". ");

    if (combinedText.isEmpty) return;

    await _flutterTts.setLanguage(language);

    state = state.copyWith(
      isPlaying: true,
      isPaused: false,
      ttsWidgetId: ttsWidgetId
    );

    await _flutterTts.speak(combinedText);
  }

  Future<void> pause() async {
    await _flutterTts.pause();
    if (mounted) {
      state = state.copyWith(
        isPaused: true,
      );
    }
  }

  Future<void> resume(List<String> texts) async {
    final combinedText = texts.where((e) => e.trim().isNotEmpty).join(". ");

    await _flutterTts.speak(combinedText);

    if (mounted) {
      state = state.copyWith(
        isPaused: false,
        isPlaying: true,
      );
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _resetState();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
}