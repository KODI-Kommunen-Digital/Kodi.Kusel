import 'dart:io';

import 'package:domain/model/response_model/user_detail/user_detail_response_model.dart';

class ProfileScreenState {
  UserData? userData;
  bool editingEnabled;
  bool loading;
  bool error;
  File? imageFile;

  ProfileScreenState(this.userData, this.editingEnabled, this.loading,
      this.error, this.imageFile);

  factory ProfileScreenState.empty() {
    return ProfileScreenState(null, false, false, false, null);
  }

  ProfileScreenState copyWith(
      {UserData? userData,
      bool? editingEnabled,
      bool? loading,
      bool? error,
      File? imageFile}) {
    return ProfileScreenState(
        userData ?? this.userData,
        editingEnabled ?? this.editingEnabled,
        loading ?? this.loading,
        error ?? this.error,
        imageFile ?? this.imageFile);
  }
}
