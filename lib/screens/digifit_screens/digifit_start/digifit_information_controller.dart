import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_information_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_cache_data_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:domain/usecase/digifit/digifit_information_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/database/digifit_cache_data/digifit_cache_data_controller.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';

import '../../../common_widgets/get_slug.dart';
import '../../../providers/digifit_equipment_fav_provider.dart';
import '../../../providers/refresh_token_provider.dart';
import 'digifit_information_state.dart';

final digifitInformationControllerProvider = StateNotifierProvider.autoDispose<
        DigifitInformationController, DigifitState>(
    (ref) => DigifitInformationController(
        digifitInformationUsecase: ref.read(digifitInformationUseCaseProvider),
        tokenStatus: ref.read(tokenStatusProvider),
        refreshTokenProvider: ref.read(refreshTokenProvider),
        localeManagerController: ref.read(localeManagerProvider.notifier),
        digifitEquipmentFav: ref.read(digifitEquipmentFavProvider),
        digifitCacheDataController: ref.read(digifitCacheDataProvider.notifier),
        networkStatusProvider: ref.read(networkStatusProvider.notifier),
        signInStatusController: ref.read(signInStatusProvider.notifier)));

class DigifitInformationController extends StateNotifier<DigifitState> {
  final DigifitInformationUseCase digifitInformationUsecase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final LocaleManagerController localeManagerController;
  final DigifitEquipmentFav digifitEquipmentFav;
  final DigifitCacheDataController digifitCacheDataController;
  final NetworkStatusProvider networkStatusProvider;
  final SignInStatusController signInStatusController;

  DigifitInformationController(
      {required this.digifitInformationUsecase,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.localeManagerController,
      required this.digifitEquipmentFav,
      required this.digifitCacheDataController,
      required this.networkStatusProvider,
      required this.signInStatusController})
      : super(DigifitState.empty());

  Future<void> fetchDigifitInformation() async {
    state = state.copyWith(isLoading: true);
    bool isNetwork =networkStatusProvider.state.isNetworkAvailable;
      try {
      if (isNetwork) {
        debugPrint(
            '[DigifitInformationController] Data is coming from network');
        final isTokenExpired = tokenStatus.isAccessTokenExpired();
        final status = await signInStatusController.isUserLoggedIn();

        if (isTokenExpired && status) {
          await refreshTokenProvider.getNewToken(onError: () {
            state = state.copyWith(isLoading: false);
          }, onSuccess: () {
            _fetchDigifitInformation();
          });
        } else {
          // If the token is not expired, we can proceed with the request
          _fetchDigifitInformation();
        }
      } else {
        debugPrint('Master debugging session : Fetching info cache data');
        bool isCacheDataAvailable =
            await digifitCacheDataController.isAllDigifitCacheDataAvailable();
        if (isCacheDataAvailable) {
          DigifitCacheDataResponseModel? digifitCacheDataResponseModel =
              await digifitCacheDataController.getAllDigifitCacheData();
          debugPrint('Master debugging session : Cache Available ${digifitCacheDataResponseModel?.toJson()}');
          if (digifitCacheDataResponseModel != null) {
            state = state.copyWith(
                isLoading: false,
                digifitInformationDataModel:
                    digifitCacheDataResponseModel.data);
          }
          debugPrint(
              '[DigifitInformationController] Data is coming from cache');
        } else {
          debugPrint('Master debugging session : Cache Not Available');
          state = state.copyWith(isLoading: false);
        }
      }
    } catch (e) {
        debugPrint('[DigifitInformationController] Exception: $e');
      }
  }

  _fetchDigifitInformation() async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      DigifitInformationRequestModel digifitInformationRequestModel =
          DigifitInformationRequestModel(
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      DigifitInformationResponseModel digifitInformationResponseModel =
          DigifitInformationResponseModel();

      final result = await digifitInformationUsecase.call(
          digifitInformationRequestModel, digifitInformationResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: l.toString(),
          );
          debugPrint(
              '[DigifitInformationController] Fetch fold Error: ${l.toString()}');
        },
        (r) {
          var response = (r as DigifitInformationResponseModel).data;
          state = state.copyWith(
              isLoading: false, digifitInformationDataModel: response);
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  onFavTap(
      {required DigifitEquipmentFavParams digifitEquipmentFavParams}) async {
    try {
      await digifitEquipmentFav.changeEquipmentFavStatus(
          onFavStatusChange: _onFavStatusChange,
          params: digifitEquipmentFavParams);
    } catch (error) {
      debugPrint('exception on fav tap : $error');
    }
  }

  Future<void> _onFavStatusChange(
      bool res, DigifitEquipmentFavParams params) async {
    try {
      final digifitInformationModel = state.digifitInformationDataModel;
      final parcoursList = digifitInformationModel?.parcours;

      if (parcoursList != null) {
        List<DigifitInformationStationModel> stationList = [];

        // Extract station list from map
        for (DigifitInformationParcoursModel value in parcoursList) {
          if (value.locationId != null &&
              value.locationId == params.locationId) {
            if (value.stations != null) {
              stationList = value.stations!;
              break;
            }
          }
        }

        // update the fav tag in particular station
        for (DigifitInformationStationModel value in stationList) {
          final id = value.id;

          if (id != null && value.id == params.equipmentId) {
            value.isFavorite = res;

            break;
          }
        }

        for (DigifitInformationParcoursModel value in parcoursList) {
          if (value.locationId != null &&
              value.locationId == params.locationId &&
              value.stations != null) {
            value.stations = stationList;
            break;
          }
        }

        digifitInformationModel!.parcours = parcoursList;

        state = state.copyWith(
            digifitInformationDataModel: digifitInformationModel);
      }
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

  Future<bool> isNetworkAvailable() async {
    bool networkAvailable = await networkStatusProvider.checkNetworkStatus();
    state = state.copyWith(isNetworkAvailable : networkAvailable);
    return networkAvailable;
  }
}
