import 'package:core/environment/environment_type.dart';

class SignInState {
  bool showPassword;
  bool showLoading;


  SignInState(this.showPassword,this.showLoading);

  factory SignInState.empty() {
    return SignInState(false,false);
  }

  SignInState copyWith({bool? showPassword, bool? showLoading}) {
    return SignInState(showPassword ?? this.showPassword,
    showLoading??this.showLoading
    );
  }
}
