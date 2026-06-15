import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';

class CustomFlutterMapState {
  double currentRotation;
  ValueNotifier<double> rotationNotifier;

  CustomFlutterMapState(
      this.currentRotation, this.rotationNotifier);

  factory CustomFlutterMapState.empty() {
    return CustomFlutterMapState(0, ValueNotifier<double>(0.0));
  }

  CustomFlutterMapState copyWith(
      {double? currentRotation,
      ValueNotifier<double>? rotationNotifier
      }) {
    return CustomFlutterMapState(currentRotation ?? this.currentRotation,
         this.rotationNotifier ?? this.rotationNotifier);
  }
}
