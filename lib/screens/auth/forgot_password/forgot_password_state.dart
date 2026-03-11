class ForgotPasswordState {
  bool isLoading;

  ForgotPasswordState(this.isLoading);

  factory ForgotPasswordState.empty() {
    return ForgotPasswordState(false);
  }

  ForgotPasswordState copyWith({bool? isLoading}) {
    return ForgotPasswordState(isLoading ?? this.isLoading);
  }
}
