import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/details_request_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/details_response_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../locale/localization_manager.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/details_usecase.dart';

import '../../../../providers/refresh_token_provider.dart';
import 'details_state.dart';

final brainTeaserGameDetailsControllerProvider = StateNotifierProvider
    .autoDispose
    .family<BrainTeaserDetailsController, BrainTeaserGameDetailsState, int>(
        (ref, gameId) => BrainTeaserDetailsController(
            brainTeaserGameDetailsUseCase:
                ref.read(brainTeaserGameDetailsUseCaseProvider),
            tokenStatus: ref.read(tokenStatusProvider),
            refreshTokenProvider: ref.read(refreshTokenProvider),
            localeManagerController: ref.read(
              localeManagerProvider.notifier,
            ),
            gameId: gameId));

class BrainTeaserDetailsController
    extends StateNotifier<BrainTeaserGameDetailsState> {
  final BrainTeaseGameDetailsUseCase brainTeaserGameDetailsUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final LocaleManagerController localeManagerController;
  int gameId;

  BrainTeaserDetailsController(
      {required this.brainTeaserGameDetailsUseCase,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.localeManagerController,
      required this.gameId})
      : super(BrainTeaserGameDetailsState.empty());

  Future<void> fetchBrainTeaserGameDetails({required int gameId}) async {
    state = state.copyWith(isLoading: true);

    try {
      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(onError: () {
          state = state.copyWith(isLoading: false);
        }, onSuccess: () {
          _fetchBrainTeaserGameDetails(gameId);
        });
      } else {
        _fetchBrainTeaserGameDetails(gameId);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('[BrainTeaserDetailsController] Exception: $e');
    }
  }

  _fetchBrainTeaserGameDetails(int id) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();
      GameDetailsRequestModel gameDetailsRequestModel = GameDetailsRequestModel(
        id: id,
        translate: "${currentLocale.languageCode}-${currentLocale.countryCode}",
      );

      GameDetailsResponseModel gameDetailsResponseModel =
          GameDetailsResponseModel();

      final result = await brainTeaserGameDetailsUseCase.call(
          gameDetailsRequestModel, gameDetailsResponseModel);

      result.fold((l) {
        state = state.copyWith(isLoading: false, errorMessage: l.toString());
        debugPrint(
            '[BrainTeaserDetailsController] Fetch fold Error: ${l.toString()}');
      }, (r) {
        var response = (r as GameDetailsResponseModel).data;
        state =
            state.copyWith(isLoading: false, gameDetailsDataModel: response);
      });
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('[BrainTeaserDetailsController]  Fetch fold Exception: $e');
    }
  }
}
