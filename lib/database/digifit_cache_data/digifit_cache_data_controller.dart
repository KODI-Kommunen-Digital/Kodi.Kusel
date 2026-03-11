import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_information_request_model.dart';
import 'package:domain/model/request_model/digifit/digifit_update_exercise_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_cache_data_response_model.dart';
import 'package:domain/usecase/digifit/local/local_digifit_bulk_tracking_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:kusel/database/boxes.dart';
import 'package:kusel/database/digifit_cache_data/digifit_cache_data_state.dart';
import 'package:kusel/database/digifit_cache_data/hive_data_keys.dart';
import 'package:kusel/database/hive_box.dart';
import 'package:domain/usecase/digifit/digifit_cache_data_usecase.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/providers/refresh_token_provider.dart';
import 'package:domain/model/response_model/digifit/local/digifit_update_exercise_response_model.dart';

final digifitCacheDataProvider =
    StateNotifierProvider<DigifitCacheDataController, DigifitCacheDataState>(
        (ref) => DigifitCacheDataController(
            hiveBoxFunctionHelper: ref.read(hiveBoxFunctionProvider),
            digifitCacheDataUseCase: ref.read(digifitCacheDataUseCaseProvider),
            refreshTokenProvider: ref.read(refreshTokenProvider),
            tokenStatus: ref.read(tokenStatusProvider),
            localeManagerController: ref.read(localeManagerProvider.notifier),
            localDigifitBulkTrackingUseCase:
                ref.read(localDigifitBulkTrackingUseCaseProvider),
            signInStatusController: ref.read(signInStatusProvider.notifier)));

class DigifitCacheDataController extends StateNotifier<DigifitCacheDataState> {
  final HiveBoxFunction hiveBoxFunctionHelper;
  final DigifitCacheDataUseCase digifitCacheDataUseCase;
  final RefreshTokenProvider refreshTokenProvider;
  final TokenStatus tokenStatus;
  final LocaleManagerController localeManagerController;
  final LocalDigifitBulkTrackingUseCase localDigifitBulkTrackingUseCase;
  final SignInStatusController signInStatusController;

  DigifitCacheDataController(
      {required this.hiveBoxFunctionHelper,
      required this.digifitCacheDataUseCase,
      required this.refreshTokenProvider,
      required this.tokenStatus,
      required this.localeManagerController,
      required this.localDigifitBulkTrackingUseCase,
      required this.signInStatusController})
      : super(DigifitCacheDataState.empty());

  Future<void> fetchAllDigifitDataFromNetwork() async {
    try {
      state = state.copyWith(isLoading: true);

      final isTokenExpired = tokenStatus.isAccessTokenExpired();

      final status = await signInStatusController.isUserLoggedIn();

      if (isTokenExpired && status) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async {
              await _fetchAllDigifitDataFromNetwork();
            });
      } else {
        // If the token is not expired, we can proceed with the request
        await _fetchAllDigifitDataFromNetwork();
      }

    } catch (e) {
      debugPrint('[DigifitCacheDataController] Fetch Exception: $e');
    }
  }

  Future<void> _fetchAllDigifitDataFromNetwork() async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      DigifitInformationRequestModel digifitInformationRequestModel =
          DigifitInformationRequestModel(
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      DigifitCacheDataResponseModel digifitCacheDataResponseModel =
          DigifitCacheDataResponseModel();

      final result = await digifitCacheDataUseCase.call(
          digifitInformationRequestModel, digifitCacheDataResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: l.toString(),
          );
          debugPrint(
              '[DigifitCacheDataController] Fetch Error: ${l.toString()}');
        },
        (r) async {
          var response = (r as DigifitCacheDataResponseModel);
          state = state.copyWith(
              isLoading: false, digifitCacheDataResponseModel: response);
          await saveAllDigifitCacheData(state.digifitCacheDataResponseModel);
        },
      );
    } catch (error) {
      debugPrint('[DigifitCacheDataController] Fetch fold Exception: $error');
    }
  }

  Future<bool> isAllDigifitCacheDataAvailable() async {
    bool isDigifitCacheDataAvailable = false;
    if (!hiveBoxFunctionHelper.isBoxOpen(BoxesName.digifitCacheData.name)) {
      await hiveBoxFunctionHelper.openBox(BoxesName.digifitCacheData.name);
    }
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitCacheData.name);
    if (box != null) {
      isDigifitCacheDataAvailable =
          await hiveBoxFunctionHelper.containsKey(box, digifitCacheDataKey);
    }
    state = state.copyWith(isCacheDataAvailable: isDigifitCacheDataAvailable);
    return isDigifitCacheDataAvailable;
  }

  Future<bool> isExerciseCacheDataAvailable() async {
    bool isExerciseCacheDataAvailable = false;
    if (!hiveBoxFunctionHelper
        .isBoxOpen(BoxesName.digifitExerciseCacheData.name)) {
      await hiveBoxFunctionHelper
          .openBox(BoxesName.digifitExerciseCacheData.name);
    }
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitExerciseCacheData.name);
    if (box != null) {
      isExerciseCacheDataAvailable = await hiveBoxFunctionHelper.containsKey(
          box, digifitExerciseCacheDataKey);
    }
    state = state.copyWith(isCacheDataAvailable: isExerciseCacheDataAvailable);
    return isExerciseCacheDataAvailable;
  }

  Future<void> saveAllDigifitCacheData(
      DigifitCacheDataResponseModel? digifitCacheDataResponseModel) async {
    bool isBoxOpen =
        hiveBoxFunctionHelper.isBoxOpen(BoxesName.digifitCacheData.name);
    if (!isBoxOpen) {
      await hiveBoxFunctionHelper.openBox(BoxesName.digifitCacheData.name);
    }
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitCacheData.name);
    if (box != null) {
      await hiveBoxFunctionHelper.putValue(
          box, digifitCacheDataKey, digifitCacheDataResponseModel);
      state = state.copyWith(isCacheDataAvailable: true);
    }
  }

  Future<DigifitCacheDataResponseModel?> getAllDigifitCacheData() async {
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitCacheData.name);
    DigifitCacheDataResponseModel digifitCacheDataResponseModel =
        box?.get(digifitCacheDataKey);
    return digifitCacheDataResponseModel;
  }

  Future<void> removeAllDigifitCacheData() async {
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitCacheData.name);
    if (box != null) {
      await hiveBoxFunctionHelper.clearBox(box);
    }
  }

  Future<void> postDigifitExerciseDataToNetwork() async {
    bool isExerciseCacheAvailable = await isExerciseCacheDataAvailable();
    if (isExerciseCacheAvailable) {
      debugPrint("DigifitCacheDataFlow - Posting data at API");

      DigifitUpdateExerciseRequestModel digifitUpdateExerciseRequestModel =
          await getDigifitExerciseCacheData();

      try {
        state = state.copyWith(isLoading: true);

        final isTokenExpired = tokenStatus.isAccessTokenExpired();
        final status = await signInStatusController.isUserLoggedIn();

        if (isTokenExpired && status) {
          await refreshTokenProvider.getNewToken(
              onError: () {},
              onSuccess: () {
                _postDigifitExerciseDataToNetwork(
                    digifitUpdateExerciseRequestModel);
              });
        } else {
          // If the token is not expired, we can proceed with the request
          _postDigifitExerciseDataToNetwork(digifitUpdateExerciseRequestModel);
        }
        // _postDigifitExerciseDataToNetwork(digifitUpdateExerciseRequestModel);
      } catch (e) {
        debugPrint('[DigifitCacheDataController] Fetch Exception: $e');
      }
    }
  }

  Future<void> _postDigifitExerciseDataToNetwork(
      DigifitUpdateExerciseRequestModel
          digifitUpdateExerciseRequestModel) async {
    try {
      DigifitUpdateExerciseResponseModel digifitUpdateExerciseResponseModel =
          DigifitUpdateExerciseResponseModel();

      final result = await localDigifitBulkTrackingUseCase.call(
          digifitUpdateExerciseRequestModel,
          digifitUpdateExerciseResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: l.toString(),
          );
          debugPrint(
              '[DigifitCacheDataController] Post exercise Exception: ${l.toString()}');
        },
        (r) async {
          var response = (r as DigifitUpdateExerciseResponseModel);
          debugPrint("DigifitCacheDataFlow - Posted data at API success");
          state = state.copyWith(isLoading: false);
        },
      );
    } catch (error) {
      debugPrint(
          '[DigifitCacheDataController] Post exercise fold Exception: $error');
    } finally {
      removeDigifitExerciseCacheData();
    }
  }

  Future<void> saveDigifitExerciseCacheData(
      DigifitUpdateExerciseRequestModel
          digifitUpdateExerciseRequestModel) async {
    if (!hiveBoxFunctionHelper
        .isBoxOpen(BoxesName.digifitExerciseCacheData.name)) {
      await hiveBoxFunctionHelper
          .openBox(BoxesName.digifitExerciseCacheData.name);
    }
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitExerciseCacheData.name);
    if (box != null) {
      await hiveBoxFunctionHelper.putValue(
          box, digifitExerciseCacheDataKey, digifitUpdateExerciseRequestModel);
      state = state.copyWith(
          isExerciseCacheDataAvailable: true,
          digifitUpdateExerciseRequestModel: digifitUpdateExerciseRequestModel);
    }
    debugPrint("DigifitCacheDataFlow - Saving Data at API");
  }

  Future<DigifitUpdateExerciseRequestModel>
      getDigifitExerciseCacheData() async {
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitExerciseCacheData.name);
    DigifitUpdateExerciseRequestModel digifitUpdateExerciseRequestModel =
        box?.get(digifitExerciseCacheDataKey);
    return digifitUpdateExerciseRequestModel;
  }

  Future<void> removeDigifitExerciseCacheData() async {
    Box? box = await hiveBoxFunctionHelper
        .getBoxReference(BoxesName.digifitExerciseCacheData.name);
    if (box != null) {
      await hiveBoxFunctionHelper.clearBox(box);
    }
  }

  void updateDigifitUpdateExerciseRequestModel(
      DigifitUpdateExerciseRequestModel digifitUpdateExerciseRequestModel) {
    state = state.copyWith(
        digifitUpdateExerciseRequestModel: digifitUpdateExerciseRequestModel);
  }
}
