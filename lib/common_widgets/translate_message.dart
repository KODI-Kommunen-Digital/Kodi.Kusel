import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/locale_constant.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:translator/translator.dart';

final translateErrorMessageProvider = Provider((ref) => TranslateErrorMessage(
    googleTranslator: GoogleTranslator(),
    localeManagerController: ref.read(localeManagerProvider.notifier)));

class TranslateErrorMessage {
  GoogleTranslator googleTranslator;
  LocaleManagerController localeManagerController;

  TranslateErrorMessage(
      {required this.googleTranslator, required this.localeManagerController});

  Future<String> translateErrorMessage(String text) async {
    String message = text;

    if (localeManagerController.getSelectedLocale().languageCode ==
        LocaleConstant.german.languageCode) {
      final res = await googleTranslator.translate(text,
          to: LocaleConstant.german.languageCode);

      message = res.text;
    }

    return message;
  }
}
