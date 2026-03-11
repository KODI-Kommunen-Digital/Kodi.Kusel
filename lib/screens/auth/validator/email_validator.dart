import 'package:flutter/widgets.dart'; // Or 'package:flutter/material.dart' if using Material
import 'package:kusel/l10n/app_localizations.dart';

String? validateEmail(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context).email_required;
  }
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailRegex.hasMatch(value)) {
    return AppLocalizations.of(context).email_required;
  }
  return null;
}
