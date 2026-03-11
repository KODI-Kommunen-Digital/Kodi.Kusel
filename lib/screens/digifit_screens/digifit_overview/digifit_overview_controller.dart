import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_overview_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_cache_data_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_overview_response_model.dart';
import 'package:domain/usecase/digifit/digifit_overview_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/database/digifit_cache_data/digifit_cache_data_controller.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';

import '../../../common_widgets/get_slug.dart';
import '../../../locale/localization_manager.dart';
import '../../../providers/digifit_equipment_fav_provider.dart';
import '../../../providers/refresh_token_provider.dart';
import 'digifit_overview_state.dart';

final digifitOverviewScreenControllerProvider = StateNotifierProvider
    .autoDispose<DigifitOverviewController, DigifitOverviewState>((ref) =>
    DigifitOverviewController(
        digifitOverviewUseCase: ref.read(digifitOverviewUseCaseProvider),
        tokenStatus: ref.read(tokenStatusProvider),
        refreshTokenProvider: ref.read(refreshTokenProvider),
        localeManagerController: ref.read(localeManagerProvider.notifier),
        digifitEquipmentFav: ref.read(digifitEquipmentFavProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier),
        networkStatusProvider: ref.read(networkStatusProvider.notifier),
        digifitCacheDataController:
        ref.read(digifitCacheDataProvider.notifier)));

class DigifitOverviewController extends StateNotifier<DigifitOverviewState> {
  final DigifitOverviewUseCase digifitOverviewUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final LocaleManagerController localeManagerController;
  final DigifitEquipmentFav digifitEquipmentFav;
  final SignInStatusController signInStatusController;
  final NetworkStatusProvider networkStatusProvider;
  final DigifitCacheDataController digifitCacheDataController;

  DigifitOverviewController({required this.digifitOverviewUseCase,
    required this.tokenStatus,
    required this.refreshTokenProvider,
    required this.localeManagerController,
    required this.digifitEquipmentFav,
    required this.signInStatusController,
    required this.networkStatusProvider,
    required this.digifitCacheDataController})
      : super(DigifitOverviewState.empty());

  Future<void> fetchDigifitOverview(int locationId) async {
    state = state.copyWith(isLoading: true);

    final status = networkStatusProvider.state.isNetworkAvailable;

    if (status) {
      try {
        final isTokenExpired = tokenStatus.isAccessTokenExpired();
        final status = await signInStatusController.isUserLoggedIn();

        if (isTokenExpired && status) {
          await refreshTokenProvider.getNewToken(
              onError: () {},
              onSuccess: () {
                _fetchDigifitOverview(locationId);
              });
        } else {
          // If the token is not expired, we can proceed with the request
          _fetchDigifitOverview(locationId);
        }
      } catch (e) {
        debugPrint('[DigifitOverviewController] Fetch Exception');
      }
    } else {
      manageDataLocally(locationId);
    }
  }

  Future<void> manageDataLocally(int locationId) async {
    bool isCacheDataAvailable =
    await digifitCacheDataController.isAllDigifitCacheDataAvailable();
    if (!isCacheDataAvailable) {
      state = state.copyWith(isLoading: false);
      return;
    }
    DigifitCacheDataResponseModel? digifitCacheDataResponseModel =
    await digifitCacheDataController.getAllDigifitCacheData();

    if (digifitCacheDataResponseModel == null ||
        digifitCacheDataResponseModel.data == null) {
      state = state.copyWith(isLoading: false);
      return;
    }
    state = state.copyWith(
      isLoading: false,
      digifitOverviewDataModel: extractDataFromDigifitCache(
          locationId, digifitCacheDataResponseModel),
    );
    debugPrint('[DigifitOverviewController] Data is coming from cache');
  }

  DigifitOverviewDataModel? extractDataFromDigifitCache(int locationId,
      DigifitCacheDataResponseModel digifitCacheDataResponseModel) {
    // Extract parcoursModel by locationId
    final parcoursList = digifitCacheDataResponseModel.data.parcours;
    DigifitInformationParcoursModel? parcoursModel;

    if (parcoursList != null) {
      try {
        parcoursModel = parcoursList.firstWhere(
                (item) => item != null && item.locationId == locationId);
      } catch (e) {
        parcoursModel = null;
      }
    }

    // Convert stations
    List<DigifitOverviewStationModel>? availableStation =
    parcoursModel?.stations
        ?.map((station) =>
        DigifitOverviewStationModel(
          id: station.id,
          name: station.name,
          muscleGroups: station.muscleGroups,
          machineImageUrl: station.machineImageUrl,
          isFavorite: station.isFavorite,
          isCompleted: station.isCompleted,
        ))
        .toList();

    // Filter completed stations
    List<DigifitOverviewStationModel>? completedStation = availableStation
        ?.where((station) => station.isCompleted == true)
        .toList();

    // User stats model
    DigifitOverviewUserStatsModel userStatsModel =
    DigifitOverviewUserStatsModel(
      points: parcoursModel?.points,
      trophies: parcoursModel?.trophies,
    );

    // Parcours model
    DigifitOverviewParcoursModel parcours = DigifitOverviewParcoursModel(
      name: parcoursModel?.name,
      locationId: parcoursModel?.locationId,
      availableStation: availableStation,
      completedStation: completedStation,
    );

    // Final overview data model
    DigifitOverviewDataModel digifitOverviewDataModel =
    DigifitOverviewDataModel(
      sourceId: digifitCacheDataResponseModel.data.sourceId,
      userStats: userStatsModel,
      parcours: parcours,
    );

    return digifitOverviewDataModel;
  }

  _fetchDigifitOverview(int locationId) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      DigifitOverviewRequestModel digifitOverviewRequestModel =
      DigifitOverviewRequestModel(
          locationId: locationId,
          translate:
          "${currentLocale.languageCode}-${currentLocale.countryCode}");

      DigifitOverviewResponseModel digifitOverviewResponseModel =
      DigifitOverviewResponseModel();

      final result = await digifitOverviewUseCase.call(
          digifitOverviewRequestModel, digifitOverviewResponseModel);

      result.fold(
            (l) {
          state = state.copyWith(isLoading: false, errorMessage: l.toString());
          debugPrint(
              '[DigifitOverviewController] Fetch fold Error: ${l.toString()}');
        },
            (r) {
          var response = (r as DigifitOverviewResponseModel).data;
          state = state.copyWith(
              isLoading: false, digifitOverviewDataModel: response);
        },
      );
    } catch (error) {
      debugPrint('[DigifitOverviewController] Fetch fold Exception: $error');
    }
  }

  availableStationOnFavTap({
    required DigifitEquipmentFavParams digifitEquipmentFavParams,
  }) async {
    try {
      await digifitEquipmentFav.changeEquipmentFavStatus(
          onFavStatusChange: _availableStationOnFavStatusChange,
          params: digifitEquipmentFavParams);
    } catch (error) {
      debugPrint('exception availableStationOnFavTap : $error');
    }
  }

  Future<void> _availableStationOnFavStatusChange(bool value,
      DigifitEquipmentFavParams params,) async {
    try {
      List<DigifitOverviewStationModel> stationList =
          state.digifitOverviewDataModel?.parcours?.availableStation ?? [];

      for (DigifitOverviewStationModel digifitOverviewStationModel
      in stationList) {
        if (digifitOverviewStationModel.id != null &&
            digifitOverviewStationModel.id == params.equipmentId) {
          digifitOverviewStationModel.isFavorite = value;
          break;
        }
      }

      state.digifitOverviewDataModel!.parcours!.availableStation = stationList;
      state = state.copyWith(
          digifitOverviewDataModel: state.digifitOverviewDataModel);
    } catch (error) {
      rethrow;
    }
  }

  completedStationOnFavTap({
    required DigifitEquipmentFavParams digifitEquipmentFavParams,
  }) async {
    try {
      await digifitEquipmentFav.changeEquipmentFavStatus(
          onFavStatusChange: _completedStationOnFavStatusChange,
          params: digifitEquipmentFavParams);
    } catch (error) {
      debugPrint('exception availableStationOnFavTap : $error');
    }
  }

  Future<void> _completedStationOnFavStatusChange(bool value,
      DigifitEquipmentFavParams params,) async {
    try {
      List<DigifitOverviewStationModel> stationList =
          state.digifitOverviewDataModel?.parcours?.completedStation ?? [];

      for (DigifitOverviewStationModel digifitOverviewStationModel
      in stationList) {
        if (digifitOverviewStationModel.id != null &&
            digifitOverviewStationModel.id == params.equipmentId) {
          digifitOverviewStationModel.isFavorite = value;
          break;
        }
      }

      state.digifitOverviewDataModel!.parcours!.completedStation = stationList;
      state = state.copyWith(
          digifitOverviewDataModel: state.digifitOverviewDataModel);
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

}
