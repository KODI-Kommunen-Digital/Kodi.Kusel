class DashboardScreenState {
  int selectedIndex;
  bool canPop;

  DashboardScreenState(this.selectedIndex, this.canPop);

  factory DashboardScreenState.empty() {
    return DashboardScreenState(0, true);
  }

  DashboardScreenState copyWith({int? selectedIndex, bool? canPop}) {
    return DashboardScreenState(
        selectedIndex ?? this.selectedIndex, canPop ?? this.canPop);
  }
}
