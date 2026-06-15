import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/brain_teaser_game/list_request_model.dart';
import 'package:domain/model/response_model/digifit/brain_teaser_game/list_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/usecase/digifit/brain_teaser_game/list_usecase.dart';
import '../../../../locale/localization_manager.dart';
import '../../../../providers/refresh_token_provider.dart';
import 'list_state.dart';

final brainTeaserGameListControllerProvider = StateNotifierProvider.autoDispose<
        BrainTeaserGameListController, BrainTeaserGameListState>(
    (ref) => BrainTeaserGameListController(
        brainTeaserGameListUseCase:
            ref.read(brainTeaserGameListUseCaseProvider),
        tokenStatus: ref.read(tokenStatusProvider),
        refreshTokenProvider: ref.read(refreshTokenProvider),
        localeManagerController: ref.read(localeManagerProvider.notifier)));

class BrainTeaserGameListController
    extends StateNotifier<BrainTeaserGameListState> {
  final BrainTeaserGameListUseCase brainTeaserGameListUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final LocaleManagerController localeManagerController;

  BrainTeaserGameListController({
    required this.brainTeaserGameListUseCase,
    required this.tokenStatus,
    required this.refreshTokenProvider,
    required this.localeManagerController,
  }) : super(BrainTeaserGameListState.empty());

  Future<void> fetchBrainTeaserGameList() async {
    state = state.copyWith(isLoading: true);

    try {
      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      if (isTokenExpired) {
        await refreshTokenProvider.getNewToken(onError: () {
          state = state.copyWith(isLoading: false);
        }, onSuccess: () {
          _fetchBrainTeaserGameList();
        });
      } else {
        _fetchBrainTeaserGameList();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('[BrainTeaserGameListController] Exception: $e');
    }
  }

  _fetchBrainTeaserGameList() async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();
      BrainTeaserGameListRequestModel brainTeaserGameListRequestModel =
          BrainTeaserGameListRequestModel(
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");
      BrainTeaserGameListResponseModel brainTeaserGameListResponseModel =
          BrainTeaserGameListResponseModel();

      final result = await brainTeaserGameListUseCase.call(
          brainTeaserGameListRequestModel, brainTeaserGameListResponseModel);

      result.fold((l) {
        state = state.copyWith(isLoading: false, errorMessage: l.toString());
        debugPrint(
            '[BrainTeaserGameListController] Fetch fold Error: ${l.toString()}');
      }, (r) {
        var response = (r as BrainTeaserGameListResponseModel).data;
        state = state.copyWith(
          isLoading: false,
          brainTeaserGameListDataModel: response,
        );
      });
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('[BrainTeaserGameListController]  Fetch fold Exception: $e');
    }
  }
}
