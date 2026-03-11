import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_user_trophies_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_user_trophies_response_model.dart';
import 'package:domain/usecase/digifit/digifit_user_trophies_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/digifit_screens/digifit_trophies/digifit_user_trophies_state.dart';

import '../../../common_widgets/get_slug.dart';
import '../../../providers/refresh_token_provider.dart';

final digifitUserTrophiesControllerProvider = StateNotifierProvider.autoDispose<
    DigifitUserTrophiesController, DigifitUserTrophiesState>(
  (ref) => DigifitUserTrophiesController(
      digifitUserTrophiesUseCase: ref.read(digifitUserTrophiesUseCaseProvider),
      tokenStatus: ref.read(tokenStatusProvider),
      refreshTokenProvider: ref.read(refreshTokenProvider),
      localeManagerController: ref.read(localeManagerProvider.notifier),
      signInStatusController: ref.read(signInStatusProvider.notifier),
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)
  ),
);

class DigifitUserTrophiesController
    extends StateNotifier<DigifitUserTrophiesState> {
  final DigifitUserTrophiesUseCase digifitUserTrophiesUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final LocaleManagerController localeManagerController;
  final SignInStatusController signInStatusController;
  final SharedPreferenceHelper sharedPreferenceHelper;

  DigifitUserTrophiesController(
      {required this.digifitUserTrophiesUseCase,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.localeManagerController,
      required this.signInStatusController,
      required this.sharedPreferenceHelper
      })
      : super(DigifitUserTrophiesState.empty());

  Future<void> fetchDigifitUserTrophies() async {
    try {
      state = state.copyWith(isLoading: true);

      final isTokenExpired = tokenStatus.isAccessTokenExpired();
      final status = await signInStatusController.isUserLoggedIn();

      if (isTokenExpired && status) {
        await refreshTokenProvider.getNewToken(
            onError: () {
              state = state.copyWith(isLoading: false);
            },
            onSuccess: () {
              _fetchDigifitUserTrophies();
            });
      } else {
        // If the token is not expired, we can proceed with the request
        _fetchDigifitUserTrophies();
      }
    } catch (e) {
      debugPrint('[DigifitUserTrophiesController] Fetch Exception: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  _fetchDigifitUserTrophies() async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      DigifitUserTrophiesRequestModel digifitUserTrophiesRequestModel =
          DigifitUserTrophiesRequestModel(
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      DigifitUserTrophiesResponseModel digifitUserTrophiesResponseModel =
          DigifitUserTrophiesResponseModel();

      final result = await digifitUserTrophiesUseCase.call(
          digifitUserTrophiesRequestModel, digifitUserTrophiesResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: l.toString(),
          );
          debugPrint(
              '[DigifitUserTrophiesController] Fetch fold Error: ${l.toString()}');
        },
        (r) {
          var response = (r as DigifitUserTrophiesResponseModel).data;
          state = state.copyWith(
              isLoading: false, digifitUserTrophyDataModel: response);
          if(response!=null) {
            bool trophyEarned = (response.userStats != null &&
                response.userStats!.trophies != null &&
                response.userStats!.trophies! > 0);
            if(trophyEarned) {
              MatomoService.trackTrophyEarned(
                  userId: sharedPreferenceHelper.getInt(userIdKey).toString());
            }
          }
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getSlug(String shortUrl, Function(String) onSuccess,
      VoidCallback onError) async {
    try {
      state = state.copyWith(isLoading: true);
      final slug = getSlugFromUrl(shortUrl);
      state = state.copyWith(isLoading: false);
      onSuccess(slug);
    } catch (error) {
      onError();
      debugPrint("get slug exception: $error");
      state = state.copyWith(isLoading: false);
    }
  }

  void toggleAllTrophiesExpanded() {
    state = state.copyWith(isAllTrophiesExpanded: !state.isAllTrophiesExpanded);
  }

  void toggleReceivedTrophiesExpanded() {
    state = state.copyWith(isReceivedTrophiesExpanded: !state.isReceivedTrophiesExpanded);
  }
}