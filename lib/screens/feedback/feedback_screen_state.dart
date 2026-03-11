class FeedbackScreenState {
  String title;
  String description;
  bool isChecked;
  bool onError;
  bool loading;


  FeedbackScreenState(
      this.title, this.description, this.isChecked, this.onError, this.loading);

  factory FeedbackScreenState.empty() {
    return FeedbackScreenState('', '', false, false, false);
  }

  FeedbackScreenState copyWith(
      {String? title,
      String? description,
      bool? isChecked,
      bool? onError,
      bool? loading}) {
    return FeedbackScreenState(
        title ?? this.title,
        description ?? this.description,
        isChecked ?? this.isChecked,
        onError ?? this.onError,
        loading ?? this.loading);
  }
}
