class ResetPasswordState {
  bool isLoading;
  bool showCurrentPassword;
  bool showNewPassword;
  bool showConfirmNewPassword;

  bool isAtLeast8CharacterComplete;
  bool isLowerCaseUpperCaseComplete;
  bool isSpecialCharacterComplete;
  bool isHaveNumberLetterComplete;

  bool showButton;

  ResetPasswordState(
      this.isLoading,
      this.showCurrentPassword,
      this.showNewPassword,
      this.showConfirmNewPassword,
      this.isAtLeast8CharacterComplete,
      this.isHaveNumberLetterComplete,
      this.isLowerCaseUpperCaseComplete,
      this.isSpecialCharacterComplete,
      this.showButton);

  factory ResetPasswordState.empty() {
    return ResetPasswordState(
        false, false, false, false, false, false, false, false, false);
  }

  ResetPasswordState copyWith(
      {bool? isLoading,
      bool? showCurrentPassword,
      bool? showNewPassword,
      bool? showConfirmNewPassword,
      bool? isAtLeast8CharacterComplete,
      bool? isLowerCaseUpperCaseComplete,
      bool? isSpecialCharacterComplete,
      bool? isHaveNumberComplete,
      bool? showButton}) {
    return ResetPasswordState(
        isLoading ?? this.isLoading,
        showCurrentPassword ?? this.showCurrentPassword,
        showNewPassword ?? this.showNewPassword,
        showConfirmNewPassword ?? this.showConfirmNewPassword,
        isAtLeast8CharacterComplete ?? this.isAtLeast8CharacterComplete,
        isHaveNumberComplete ?? this.isHaveNumberLetterComplete,
        isLowerCaseUpperCaseComplete ?? this.isLowerCaseUpperCaseComplete,
        isSpecialCharacterComplete ?? this.isSpecialCharacterComplete,
        showButton ?? this.showButton);
  }
}
