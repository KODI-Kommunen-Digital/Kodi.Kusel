class SignUpState {
  bool showPassword;
  bool isLoading;

  SignUpState(this.showPassword, this.isLoading);

  factory SignUpState.empty() {
    return SignUpState(false, false);
  }

  SignUpState copyWith({bool? showPassword, bool? isLoading}) {
    return SignUpState(
        showPassword ?? this.showPassword, isLoading ?? this.isLoading);
  }
}
