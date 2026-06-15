class ExtractDeviceIdState {
  final String deviceId;

  const ExtractDeviceIdState({required this.deviceId});

  factory ExtractDeviceIdState.empty() {
    return const ExtractDeviceIdState(deviceId: '');
  }

  ExtractDeviceIdState copyWith({String? deviceId}) {
    return ExtractDeviceIdState(
      deviceId: deviceId ?? this.deviceId,
    );
  }
}
