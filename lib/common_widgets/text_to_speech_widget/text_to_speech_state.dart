class TextToSpeechState {
  final bool isPlaying;
  final bool isPaused;
  final String ttsWidgetId;

  const TextToSpeechState({
    required this.isPlaying,
    required this.isPaused,
    required this.ttsWidgetId
  });

  factory TextToSpeechState.empty() {
    return const TextToSpeechState(
      isPlaying: false,
      isPaused: false,
      ttsWidgetId: ""
    );
  }

  TextToSpeechState copyWith({
    bool? isPlaying,
    bool? isPaused,
    String? ttsWidgetId
  }) {
    return TextToSpeechState(
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      ttsWidgetId: ttsWidgetId ?? this.ttsWidgetId
    );
  }
}