import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digitfit_fav/digifit_fav_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_fav_response_model.dart';
import 'package:flutter/material.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/providers/refresh_token_provider.dart';
import 'package:kusel/screens/digifit_screens/digifit_fav_screen/digifit_fav_screen_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/usecase/digifit/digifit_fav_usecase.dart';

import '../../../providers/digifit_equipment_fav_provider.dart';

final digifitFavControllerProvider = StateNotifierProvider.autoDispose<
        DigifitFavController, DigifitFavScreenState>(
    (ref) => DigifitFavController(
        digifitFavUseCase: ref.read(digifitFavUseCaseProvider),
        localeManagerController: ref.read(localeManagerProvider.notifier),
        digifitEquipmentFav: ref.read(digifitEquipmentFavProvider),
        refreshTokenProvider: ref.read(refreshTokenProvider),
        tokenStatus: ref.read(tokenStatusProvider)));

class DigifitFavController extends StateNotifier<DigifitFavScreenState> {
  DigifitFavUseCase digifitFavUseCase;
  LocaleManagerController localeManagerController;
  RefreshTokenProvider refreshTokenProvider;
  TokenStatus tokenStatus;

  final DigifitEquipmentFav digifitEquipmentFav;

  DigifitFavController(
      {required this.digifitFavUseCase,
      required this.localeManagerController,
      required this.digifitEquipmentFav,
      required this.refreshTokenProvider,
      required this.tokenStatus})
      : super(DigifitFavScreenState.empty());

  getDigifitFavList(int pageNumber, {int pageSize = 19}) async {
    try {
      state = state.copyWith(isLoading: true);

      final status = tokenStatus.isAccessTokenExpired();

      if (status) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async {
              await _getDigifitFavList(pageNumber, pageSize);
            });
      } else {
        await _getDigifitFavList(pageNumber, pageSize);
      }
    } catch (error) {
      debugPrint('digifit fav exception: $error');
      state = state.copyWith(isLoading: false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  _getDigifitFavList(int pageNumber, int pageSize) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      final translate =
          "${currentLocale.languageCode}-${currentLocale.countryCode}";

      DigifitFavRequestModel requestModel = DigifitFavRequestModel(
          translate: translate, pageNo: pageNumber, pageSize: pageSize);

      DigifitFavResponseModel responseModel = DigifitFavResponseModel();

      final res = await digifitFavUseCase.call(requestModel, responseModel);

      res.fold((l) {
        debugPrint('digifit fav exception: $l');
      }, (r) {
        final res = r as DigifitFavResponseModel;

        if (res.data != null) {
          state = state.copyWith(equipmentList: res.data, isLoading: false);
          return;
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  changeFav(DigifitEquipmentFavParams params) async {
    try {
      await digifitEquipmentFav.changeEquipmentFavStatus(
          onFavStatusChange: (status, params) async {
            _removeFavFromList(status, params.equipmentId);
          },
          params: params);
    } catch (e) {
      debugPrint('change fav exception : $e');
    }
  }

  _removeFavFromList(bool status, int id) {
    final list = state.equipmentList;

    final updatedList = list.where((item) => item.equipmentId != id).toList();
    state = state.copyWith(equipmentList: updatedList);
  }

  getLoadMoreDigifitFavList(int pageNumber, {int pageSize = 9}) async {
    try {
      state = state.copyWith(isNextPageLoading: true);

      final status = tokenStatus.isAccessTokenExpired();

      if (status) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async {
              await _getLoadMoreDigifitFavList(pageNumber, pageSize);
            });
      } else {
        await _getLoadMoreDigifitFavList(pageNumber, pageSize);
      }
    } catch (error) {
      debugPrint('digifit load more fav exception: $error');
    } finally {
      state = state.copyWith(isNextPageLoading: false);
    }
  }

  _getLoadMoreDigifitFavList(int pageNumber, int pageSize) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      final translate =
          "${currentLocale.languageCode}-${currentLocale.countryCode}";
      DigifitFavRequestModel requestModel = DigifitFavRequestModel(
          translate: translate, pageNo: pageNumber, pageSize: pageSize);

      DigifitFavResponseModel responseModel = DigifitFavResponseModel();

      final res = await digifitFavUseCase.call(requestModel, responseModel);

      res.fold((l) {
        debugPrint('digifit fav exception: $l');
      }, (r) {
        final res = r as DigifitFavResponseModel;
        final list = state.equipmentList;

        if (res.data != null && res.data!.isNotEmpty) {
          list.addAll(res.data!);
          state = state.copyWith(equipmentList: list, pageNumber: pageNumber);
          return;
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
