import 'dart:async';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_exercise_details_request_model.dart';
import 'package:domain/model/request_model/digifit/digifit_exercise_details_tracking_request_model.dart';
import 'package:domain/model/request_model/digifit/digifit_update_exercise_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_cache_data_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_exercise_details_tracking_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:domain/usecase/digifit/digifit_exercise_details_tracking_usecase.dart';
import 'package:domain/usecase/digifit/digifit_exercise_details_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/database/digifit_cache_data/digifit_cache_data_controller.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/providers/digifit_equipment_fav_provider.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';

import '../../../common_widgets/get_slug.dart';
import '../../../locale/localization_manager.dart';
import '../../../providers/refresh_token_provider.dart';
import 'digifit_exercise_details_state.dart';
import 'enum/digifit_exercise_session_status_enum.dart';
import 'enum/digifit_exercise_timer_state.dart';

final digifitExerciseDetailsControllerProvider = StateNotifierProvider
    .autoDispose
    .family<DigifitExerciseDetailsController, DigifitExerciseDetailsState, int>(
  (ref, equipmentId) => DigifitExerciseDetailsController(
    digifitExerciseDetailsUseCase:
        ref.read(digifitExerciseDetailsUseCaseProvider),
    digifitExerciseDetailsTrackingUseCase:
        ref.read(digifitExerciseDetailsTrackingUseCaseProvider),
    tokenStatus: ref.read(tokenStatusProvider),
    refreshTokenProvider: ref.read(refreshTokenProvider),
    localeManagerController: ref.read(localeManagerProvider.notifier),
    digifitEquipmentFav: ref.read(digifitEquipmentFavProvider),
    signInStatusController: ref.read(signInStatusProvider.notifier),
    networkStatusProvider: ref.read(networkStatusProvider.notifier),
    digifitCacheDataController: ref.read(digifitCacheDataProvider.notifier),
    equipmentId: equipmentId,
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
  ),
);

class DigifitExerciseDetailsController
    extends StateNotifier<DigifitExerciseDetailsState> {
  int equipmentId;
  final DigifitExerciseDetailsUseCase digifitExerciseDetailsUseCase;
  final DigifitExerciseDetailsTrackingUseCase
      digifitExerciseDetailsTrackingUseCase;
  final TokenStatus tokenStatus;
  final RefreshTokenProvider refreshTokenProvider;
  final LocaleManagerController localeManagerController;
  final DigifitEquipmentFav digifitEquipmentFav;
  final SignInStatusController signInStatusController;
  final NetworkStatusProvider networkStatusProvider;
  final DigifitCacheDataController digifitCacheDataController;
  final SharedPreferenceHelper sharedPreferenceHelper;

  DigifitExerciseDetailsController(
      {required this.digifitExerciseDetailsUseCase,
      required this.digifitExerciseDetailsTrackingUseCase,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.localeManagerController,
      required this.digifitEquipmentFav,
      required this.signInStatusController,
      required this.networkStatusProvider,
      required this.digifitCacheDataController,
      required this.equipmentId,
      required this.sharedPreferenceHelper
      })
      : super(DigifitExerciseDetailsState.empty());

  Future<void> fetchDigifitExerciseDetails(
      int? equipmentId, int? locationId, String? slug) async {
    state = state.copyWith(isLoading: true);
    bool isNetwork = await isNetworkAvailable();
      try {
        if (isNetwork){
        final isTokenExpired = tokenStatus.isAccessTokenExpired();
        final status = await signInStatusController.isUserLoggedIn();

        if (isTokenExpired && status) {
          await refreshTokenProvider.getNewToken(
              onError: () {},
              onSuccess: () {
                _fetchDigifitExerciseDetails(equipmentId, locationId, slug);
              });
        } else {
          // If the token is not expired, we can proceed with the request
          _fetchDigifitExerciseDetails(equipmentId, locationId, slug);
        }

      } else {
      manageDataLocally(locationId, equipmentId, slug);
    }
      } catch (e) {
        debugPrint('[DigifitExerciseDetailsController] Fetch Exception: $e');
      }
  }

  _fetchDigifitExerciseDetails(
      int? equipmentId, int? locationId, String? slug) async {
      try {
        Locale currentLocale = localeManagerController.getSelectedLocale();
        DigifitExerciseDetailsRequestModel digifitExerciseDetailsRequestModel =
        DigifitExerciseDetailsRequestModel(
            equipmentId: equipmentId,
            locationId: locationId,
            equipmentSlug: slug,
            translate:
            "${currentLocale.languageCode}-${currentLocale.countryCode}");

        DigifitExerciseDetailsResponseModel digifitExerciseDetailsResponseModel =
        DigifitExerciseDetailsResponseModel();

        final result = await digifitExerciseDetailsUseCase.call(
            digifitExerciseDetailsRequestModel,
            digifitExerciseDetailsResponseModel);

        result.fold((l) {
          state = state.copyWith(isLoading: false, errorMessage: l.toString());
          debugPrint(
              '[DigifitExerciseDetailsController] Fetch fold Error: ${l.toString()}');
        }, (r) {
          var response = (r as DigifitExerciseDetailsResponseModel).data;
          state = state.copyWith(
              isLoading: false,
              digifitExerciseRelatedEquipmentsModel: response.relatedStations,
              digifitExerciseEquipmentModel: response.equipment,
              totalSetNumber: response.equipment.userProgress.totalSets,
              currentSetNumber: response.equipment.userProgress.currentSet,
              locationId: locationId);
        });
      } catch (error) {
        debugPrint(
            '[DigifitExerciseDetailsController] Fetch fold Exception: $error');
      }
  }

  Future<void> manageDataLocally(int? locationId, int? equipmentId, String? slug) async {
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
    extractDataFromDigifitCache(
              locationId, equipmentId, digifitCacheDataResponseModel, slug);
    debugPrint('[DigifitExerciseDetailsController] Data is coming from cache');
  }


  void extractDataFromDigifitCache(
      int? locationId,
      int? equipmentId,
      DigifitCacheDataResponseModel digifitCacheDataResponseModel,
      String? slug,
      ) {
    final parcoursList = digifitCacheDataResponseModel.data.parcours;
    DigifitInformationParcoursModel? parcoursModel;
    List<DigifitInformationStationModel>? digifitStationModelList;
    DigifitInformationStationModel? digifitStationModel;

    if (locationId != null) {
      if (parcoursList != null) {
        try {
          parcoursModel = parcoursList.firstWhere(
                (item) => item.locationId == locationId,
            orElse: () => DigifitInformationParcoursModel(),
          );
        } catch (e) {
          parcoursModel = null;
        }
      }
      digifitStationModelList = parcoursModel?.stations;
      digifitStationModel = digifitStationModelList?.firstWhere(
            (item) => item.id == equipmentId,
        orElse: () => DigifitInformationStationModel(),
      );
    } else {
      if (parcoursList != null && slug != null) {
        for (final parcours in parcoursList) {
          for (final station in parcours.stations ?? []) {
            if (station.qrCodeIdentifier == slug) {
              digifitStationModel = station;
              break;
            }
          }
          if (digifitStationModel != null) break;
        }
      }
    }

    DigifitExerciseRecommendationModel recommendation =
    DigifitExerciseRecommendationModel(
      sets: digifitStationModel?.sets ?? '',
      repetitions: digifitStationModel?.repetitions ?? '',
    );

    DigifitExerciseUserProgressModel userProgress = DigifitExerciseUserProgressModel(
      isCompleted: digifitStationModel?.isCompleted ?? false,
      repetitionsPerSet: digifitStationModel?.recommendedReps ?? 0,
    );
    DigifitExerciseEquipmentModel digifitExerciseEquipmentModel =
    DigifitExerciseEquipmentModel(
      id: digifitStationModel?.id ?? 0,
      name: digifitStationModel?.name ?? '',
      machineVideoUrl: digifitStationModel?.machineImageUrl ?? '',
      qrCodeIdentifier: digifitStationModel?.qrCodeIdentifier ?? '',
      description: digifitStationModel?.description ?? '',
      recommendation: recommendation,
      userProgress: userProgress,
      isFavorite: digifitStationModel?.isFavorite ?? false,
    );
    state = state.copyWith(
      isLoading: false,
      digifitExerciseEquipmentModel: digifitExerciseEquipmentModel,
      totalSetNumber: digifitStationModel?.recommendedSets,
      locationId: locationId,
    );
  }

  onFavTap(
      {required DigifitEquipmentFavParams digifitEquipmentFavParams,
      required Future Function(bool, DigifitEquipmentFavParams)
          onFavStatusChange}) async {
    try {
      await digifitEquipmentFav.changeEquipmentFavStatus(
          onFavStatusChange: onFavStatusChange,
          params: digifitEquipmentFavParams);
    } catch (error) {
      debugPrint('exception on fav tap : $error');
    }
  }

  Future<void> detailPageOnFavStatusChange(
      bool res, DigifitEquipmentFavParams params) async {
    try {
      DigifitExerciseEquipmentModel? model =
          state.digifitExerciseEquipmentModel;

      if (model != null) {
        model.isFavorite = res;
        state = state.copyWith(digifitExerciseEquipmentModel: model);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> recommendOnFavStatusChange(
      bool res, DigifitEquipmentFavParams params) async {
    try {
      List<DigifitExerciseRelatedStationsModel> list =
          state.digifitExerciseRelatedEquipmentsModel;

      for (DigifitExerciseRelatedStationsModel item in list) {
        if (params.equipmentId == item.id) {
          item.isFavorite = res;
          break;
        }
      }

      state = state.copyWith(digifitExerciseRelatedEquipmentsModel: list);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> validateQrScanner(
      String shortHandUrl, String equipmentSlug) async {
    try {
      state = state.copyWith(isLoading: true);
      final slug = getSlugFromUrl(shortHandUrl);
      state = state.copyWith(isLoading: false);
      return slug == equipmentSlug;
    } catch (error) {
      debugPrint("[Validate Url Expansion] URL expansion failed: $error");
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<void> trackExerciseDetails(
      int equipmentId,
      int locationId,
      int sets,
      int reps,
      ExerciseStageConstant stageConstant,
      VoidCallback onSuccess) async {
    bool isNetwork = await isNetworkAvailable();

    if(isNetwork) {
      try {
        final isTokenExpired = tokenStatus.isAccessTokenExpired();
        final status = await signInStatusController.isUserLoggedIn();

        if (isTokenExpired && status) {
          await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async {
              await _trackExerciseDetails(
                  equipmentId, locationId, sets, reps, stageConstant, onSuccess);
            },
          );
        } else {
          await _trackExerciseDetails(
              equipmentId, locationId, sets, reps, stageConstant, onSuccess);
        }
      } catch (e) {
        debugPrint('[CardExerciseDetailsController] Track Exception: $e');
      }
    } else {

      bool isCompleted = false;
      if (stageConstant == ExerciseStageConstant.start) {
        createdAt();
      } else if (stageConstant == ExerciseStageConstant.progress) {
        updatedAt();
        updateSetComplete();
      } else if (stageConstant == ExerciseStageConstant.complete) {
        updateSetComplete();
        updatedAt();
        isCompleted = true;
        saveExerciseCacheData(exerciseId: equipmentId.toString(), locationId: locationId);
        MatomoService.trackDigifitExerciseCompleted(
            userId: sharedPreferenceHelper.getInt(userIdKey).toString());
      } else if (stageConstant == ExerciseStageConstant.abort) {
        saveExerciseCacheData(
            exerciseId: equipmentId.toString(), locationId: locationId);
      }
      updateSessionStage(stageConstant);
      onSuccess();
      DigifitExerciseEquipmentModel? digifitExerciseEquipmentModel =
          state.digifitExerciseEquipmentModel;
      if (digifitExerciseEquipmentModel?.userProgress.isCompleted != null) {
        digifitExerciseEquipmentModel?.userProgress.isCompleted = isCompleted;
      }
      state = state.copyWith(
          currentSetNumber: state.currentSetNumber,
          digifitExerciseEquipmentModel: digifitExerciseEquipmentModel);
    }
  }

  _trackExerciseDetails(int equipmentId, int locationId, int sets, int reps,
      ExerciseStageConstant stageConstant, VoidCallback onSuccess) async {
    try {
      state = state.copyWith(isLoading: true);

      DigifitExerciseDetailsTrackingRequestModel
          digifitExerciseDetailsTrackingRequestModel =
          DigifitExerciseDetailsTrackingRequestModel(
              equipmentId: equipmentId,
              locationId: locationId,
              setNumber: sets,
              reps: reps,
              activityStatus: stageConstant.name);

      DigifitExerciseDetailsTrackingResponseModel
          digifitExerciseDetailsTrackingResponseModel =
          DigifitExerciseDetailsTrackingResponseModel();

      final result = await digifitExerciseDetailsTrackingUseCase.call(
          digifitExerciseDetailsTrackingRequestModel,
          digifitExerciseDetailsTrackingResponseModel);

      result.fold((l) {
        state = state.copyWith(isLoading: false, errorMessage: l.toString());
        debugPrint(
            '[CardExerciseDetailsController] Fetch fold Error: ${l.toString()}');
      }, (r) {
        var response = (r as DigifitExerciseDetailsTrackingResponseModel).data;

        DigifitExerciseEquipmentModel? digifitExerciseEquipmentModel =
            state.digifitExerciseEquipmentModel;
        final isComplete = response.isCompleted;

        if (digifitExerciseEquipmentModel?.userProgress.isCompleted != null) {
          digifitExerciseEquipmentModel?.userProgress.isCompleted = isComplete;
        }

        state = state.copyWith(
            isLoading: false,
            currentSetNumber: response.completedSets,
            digifitExerciseEquipmentModel: digifitExerciseEquipmentModel);
        updateSessionStage(stageConstant);
        onSuccess();
      });
    } catch (error) {
      debugPrint('[CardExerciseDetailsController] Fetch  Exception: $error');
    }
  }

  void updateIsReadyToSubmitSetVisibility(bool value) {
    state = state.copyWith(isReadyToSubmitSet: value);
  }

  void updateScannerButtonVisibility(bool value) {
    state = state.copyWith(isScannerVisible: value);
  }

  void updateRemainingSeconds(int seconds) {
    state = state.copyWith(remainingPauseSecond: seconds);
  }

  void updateTimerStatus(TimerState value) {
    state = state.copyWith(timerState: value);
  }

  Future<bool> isNetworkAvailable() async {
    bool networkAvailable = await networkStatusProvider.checkNetworkStatus();
    state = state.copyWith(isNetworkAvailable : networkAvailable);
    return networkAvailable;
  }

  void saveExerciseCacheData({
    required String exerciseId,
    required int locationId,
  }) async {
    debugPrint("DigifitCacheDataFlow - Saving Data at Hive");

    final digifitExerciseRecordModel = DigifitExerciseRecordModel(
      locationId: locationId,
      createdAt: state.createdAt,
      updatedAt: state.updatedAt,
      setComplete: state.currentSetNumber,
      setTimeList: state.setTimeList,
    );

    bool isExerciseCacheAvailable =
    await digifitCacheDataController.isExerciseCacheDataAvailable();

    DigifitUpdateExerciseRequestModel digifitUpdateExerciseRequestModel;

    if (isExerciseCacheAvailable) {
      digifitUpdateExerciseRequestModel =
      await digifitCacheDataController.getDigifitExerciseCacheData();

      // Trying to find existing equipment entry
      final existingMapIndex = digifitUpdateExerciseRequestModel.data.indexWhere(
            (map) => map.containsKey(equipmentId),
      );

      if (existingMapIndex != -1) {
        // Append to existing list
        digifitUpdateExerciseRequestModel.data[existingMapIndex][equipmentId]!
            .add(digifitExerciseRecordModel);
      } else {
        // Add new equipment entry
        digifitUpdateExerciseRequestModel.data.add({
          equipmentId.toString(): [digifitExerciseRecordModel]
        });
      }
    } else {
      // Create new cache data
      digifitUpdateExerciseRequestModel = DigifitUpdateExerciseRequestModel();
      digifitUpdateExerciseRequestModel.data.add({
        equipmentId.toString(): [digifitExerciseRecordModel]
      });
    }

    await digifitCacheDataController
        .saveDigifitExerciseCacheData(digifitUpdateExerciseRequestModel);
  }

  void createdAt() {
    String createdAt = getCurrentUTCTime();
    state = state.copyWith(createdAt: createdAt);
  }

  void updatedAt() {
    String updatedAt = getCurrentUTCTime();
    state = state.copyWith(updatedAt: updatedAt);
    updateSetTimeList(updatedAt);
  }

  void updateSetComplete() {
    int currentSetNumber = state.currentSetNumber;
    currentSetNumber++;
    state = state.copyWith(currentSetNumber: currentSetNumber);
  }

  void updateSetTimeList(String updatedAt) {
    final List<String> updatedList = [...(state.setTimeList ?? [])];
    updatedList.add(updatedAt);
    state = state.copyWith(
      setTimeList: updatedList,
    );
  }

  String getCurrentUTCTime() {
    final now = DateTime.now().toUtc();
    return now.toIso8601String();
  }

  void updateSessionStage(ExerciseStageConstant value) {
    state = state.copyWith(sessionStage: value);
  }
}
