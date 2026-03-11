import 'package:core/environment/environment_type.dart';

class EnvironmentState {
  EnvironmentType environmentType;

  EnvironmentState(this.environmentType);

  factory EnvironmentState.empty() {
    return EnvironmentState(EnvironmentType.production);
  }

  EnvironmentState copyWith({EnvironmentType? environmentType}) {
    return EnvironmentState(environmentType ?? this.environmentType);
  }
}
