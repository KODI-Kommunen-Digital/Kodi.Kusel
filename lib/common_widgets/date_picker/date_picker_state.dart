import 'dart:core';

class DatePickerState {
  DateTime? startDate;
  DateTime? endDate;
  bool error;
  DatePickerState(this.startDate, this.endDate, this.error);

  factory DatePickerState.empty() {
    return DatePickerState(null, null, false);
  }

  DatePickerState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    bool? error
}) {
    return DatePickerState(
      startDate ?? this.startDate,
      endDate ?? this.endDate,
      error ?? this.error
    );
  }
}
