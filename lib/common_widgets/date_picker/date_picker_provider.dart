import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kusel/common_widgets/date_picker/date_picker_state.dart';

final datePickerProvider =
    StateNotifierProvider<DatePickerProvider, DatePickerState>(
        (ref) => DatePickerProvider());

class DatePickerProvider extends StateNotifier<DatePickerState> {
  DatePickerProvider() : super(DatePickerState.empty());

  Future<void> pickDate(BuildContext context, bool isStartDate) async {
    DateTime? selectedDate = isStartDate ? state.startDate : state.endDate;

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: state.startDate ?? DateTime.now(),
      firstDate: state.startDate ?? DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      DateTime selectedDate = date;
      if (isStartDate) {
        state = state.copyWith(
            startDate: selectedDate,
        );
      }
      else {
        state = state.copyWith(
            endDate: selectedDate,
        );
      }
    }
  }

  void onValidation() {
    state = state.copyWith(error: true);
  }
  void resetDates() {
    if(mounted){
      state = DatePickerState.empty();
    }
  }
}
