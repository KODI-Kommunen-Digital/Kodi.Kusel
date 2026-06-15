class DigifitQrScannerState {
  bool? isCorrectEquipment;

  DigifitQrScannerState({this.isCorrectEquipment});

  factory DigifitQrScannerState.initial() {
    return DigifitQrScannerState(isCorrectEquipment: null);
  }

  DigifitQrScannerState copyWith({bool? isCorrectEquipment}) {
    return DigifitQrScannerState(
      isCorrectEquipment: isCorrectEquipment ?? this.isCorrectEquipment,
    );
  }
}
