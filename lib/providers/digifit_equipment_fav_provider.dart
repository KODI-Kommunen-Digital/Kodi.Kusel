import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/digifit/digifit_equipment_fav_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_equipment_fav_response_model.dart';
import 'package:domain/usecase/digifit/digifit_equipment_fav_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/providers/refresh_token_provider.dart';

final digifitEquipmentFavProvider = Provider((ref) => DigifitEquipmentFav(
    refreshTokenProvider: ref.read(refreshTokenProvider),
    tokenStatus: ref.read(tokenStatusProvider),
    digifitEquipmentFavUseCase: ref.read(digifitEquipmentFavUseCaseProvider),
    signInStatusController: ref.read(signInStatusProvider.notifier)));

class DigifitEquipmentFav {
  RefreshTokenProvider refreshTokenProvider;
  TokenStatus tokenStatus;
  DigifitEquipmentFavUseCase digifitEquipmentFavUseCase;
  SignInStatusController signInStatusController;

  DigifitEquipmentFav(
      {required this.refreshTokenProvider,
      required this.tokenStatus,
      required this.digifitEquipmentFavUseCase,
      required this.signInStatusController});

  Future<void> changeEquipmentFavStatus(
      {required Future<void> Function(bool, DigifitEquipmentFavParams)
          onFavStatusChange,
      required DigifitEquipmentFavParams params}) async {
    try {
      final status = tokenStatus.isAccessTokenExpired();
      final signInStatus = await signInStatusController.isUserLoggedIn();

      if (status && signInStatus) {
        refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async {
              await _changeFav(
                  params: params, onFavStatusChange: onFavStatusChange);
            });
      } else {
        await _changeFav(params: params, onFavStatusChange: onFavStatusChange);
      }
    } catch (error) {
      rethrow;
    }
  }

  _changeFav(
      {required DigifitEquipmentFavParams params,
      required Future<void> Function(bool, DigifitEquipmentFavParams)
          onFavStatusChange}) async {
    try {
      DigifitEquimentFavRequestModel requestModel =
          DigifitEquimentFavRequestModel(
              isFavorite: params.isFavorite,
              equipmentId: params.equipmentId,
              locationId: params.locationId);

      DigifitEquipmentFavResponseModel responseModel =
          DigifitEquipmentFavResponseModel();

      final response =
          await digifitEquipmentFavUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint('fold exception while marking fav = ${l.toString()}');
      }, (r) async {
        final res = r as DigifitEquipmentFavResponseModel;

        if (res.data?.isFavorite != null) {
          onFavStatusChange(res.data!.isFavorite!, params);
        }
      });
    } catch (error) {
      rethrow;
    }
  }



}

class DigifitEquipmentFavParams {
  bool isFavorite;
  int equipmentId;
  int locationId;

  DigifitEquipmentFavParams({
    required this.isFavorite,
    required this.equipmentId,
    required this.locationId,
  });
}
