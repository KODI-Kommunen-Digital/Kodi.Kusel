class NetworkStatusState {
  bool isNetworkAvailable;

  NetworkStatusState(this.isNetworkAvailable);

  factory NetworkStatusState.empty() {
    return NetworkStatusState(true);
  }

  NetworkStatusState copyWith({bool? isNetworkAvailable}) {
    return NetworkStatusState(isNetworkAvailable ?? this.isNetworkAvailable);
  }
}
