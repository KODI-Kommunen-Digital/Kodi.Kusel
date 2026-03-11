import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/feedback/feedback_request_model.dart';
import 'package:domain/model/response_model/feedback/feedback_response_model.dart';
import 'package:domain/usecase/feedback/feedback_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/feedback/feedback_screen_state.dart';

import '../../common_widgets/translate_message.dart';

final feedbackScreenProvider = StateNotifierProvider.autoDispose<
        FeedbackScreenProvider, FeedbackScreenState>(
    (ref) => FeedbackScreenProvider(
        feedBackUseCase: ref.read(feedBackUseCaseProvider),
        translateErrorMessage: ref.read(translateErrorMessageProvider),
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class FeedbackScreenProvider extends StateNotifier<FeedbackScreenState> {
  FeedBackUseCase feedBackUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  TranslateErrorMessage translateErrorMessage;

  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController descriptionEditingController =
      TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();

  FeedbackScreenProvider(
      {required this.feedBackUseCase,
      required this.sharedPreferenceHelper,
      required this.translateErrorMessage})
      : super(FeedbackScreenState.empty());

  Future<void> sendFeedback(
      {required void Function() success,
      required void Function(String msg) onError,
      required String email,
      required String title,
      required String description}) async {
    try {
      String? language = sharedPreferenceHelper.getString(languageKey);
      state = state.copyWith(loading: true);
      FeedBackRequestModel requestModel = FeedBackRequestModel(
          userEmail: email,
          title: title,
          description: description,
          language: language ?? 'en');
      FeedBackResponseModel responseModel = FeedBackResponseModel();
      final r = await feedBackUseCase.call(requestModel, responseModel);
      r.fold((l) async {
        debugPrint('Feedback fold exception : $l');
        final text =
            await translateErrorMessage.translateErrorMessage(l.toString());
        onError(text);
        state = state.copyWith(loading: false);
      }, (r) async {
        final result = r as FeedBackResponseModel;
        success();
        MatomoService.trackFeedbackSubmitted(
            userId: sharedPreferenceHelper.getInt(userIdKey).toString());
        state = state.copyWith(loading: false);
      });
    } catch (error) {
      onError(error.toString());
      debugPrint('Feedback exception : $error');
      state = state.copyWith(loading: false);
    }
  }

  void updateCheckBox(bool value) {
    bool onError = !value;
    state = state.copyWith(isChecked: value, onError: onError);
  }

  updateTitle(String title) {
    state = state.copyWith(title: title);
  }
}
