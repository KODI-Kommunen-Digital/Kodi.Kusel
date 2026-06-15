import 'dart:io';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/edit_user_detail/edit_user_detail_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/request_model/user_detail/user_detail_request_model.dart';
import 'package:domain/model/response_model/edit_user_detail/edit_user_detail_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/model/response_model/user_detail/user_detail_response_model.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:domain/usecase/user_detail/user_detail_usecase.dart';
import 'package:domain/usecase/edit_user_detail/edit_user_detail_usecase.dart';
import 'package:domain/model/response_model/edit_user_detail/edit_user_image_response_model.dart';
import 'package:domain/model/request_model/edit_user_detail/edit_user_image_request_model.dart';
import 'package:domain/usecase/edit_user_detail/edit_user_image_usecase.dart';
import 'package:data/end_points.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/profile/profile_screen_state.dart';

final profileScreenProvider =
    StateNotifierProvider<ProfileScreenController, ProfileScreenState>((ref) =>
        ProfileScreenController(
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
            userDetailUseCase: ref.read(userDetailUseCaseProvider),
            editUserDetailUseCase: ref.read(editUserDetailUseCaseProvider),
            editUserImageUseCase: ref.read(editUserImageUseCaseProvider),
          tokenStatus: ref.read(tokenStatusProvider),
          refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider)
        ));

class ProfileScreenController extends StateNotifier<ProfileScreenState> {
  SharedPreferenceHelper sharedPreferenceHelper;
  UserDetailUseCase userDetailUseCase;
  EditUserDetailUseCase editUserDetailUseCase;
  EditUserImageUseCase editUserImageUseCase;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;

  ProfileScreenController(
      {required this.sharedPreferenceHelper,
      required this.userDetailUseCase,
      required this.editUserDetailUseCase,
      required this.editUserImageUseCase,
      required this.tokenStatus,
      required this.refreshTokenUseCase
      })
      : super(ProfileScreenState.empty());
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  TextEditingController websiteEditingController = TextEditingController();

  Future<void> initializeTextEditController() async {
    nameEditingController.text =
        "${state.userData?.firstname ?? ''} ${state.userData?.lastname ?? ''}" ??
            '_';
    userNameEditingController.text = state.userData?.username ?? '_';
    emailEditingController.text = state.userData?.email ?? '_';
    phoneNumberEditingController.text = state.userData?.phoneNumber ?? '';
    descriptionEditingController.text = state.userData?.description ?? '';
    websiteEditingController.text = state.userData?.website ?? '';
  }


  Future<void> getUserDetails() async {
    try {
      state = state.copyWith(loading: true);
      final response = tokenStatus.isAccessTokenExpired();

      if (response) {
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();
        RefreshTokenRequestModel requestModel =
            RefreshTokenRequestModel();
        final result =
            await refreshTokenUseCase.call(requestModel, responseModel);

        result.fold((l) {
          state = state.copyWith(loading: false);
        }, (r) async {
          final res = r as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");

          UserDetailRequestModel requestModel = UserDetailRequestModel();
          UserDetailResponseModel responseModel = UserDetailResponseModel();

          debugPrint('value for this is the ${requestModel}');

          final result =
              await userDetailUseCase.call(requestModel, responseModel);
          result.fold((l) {
            debugPrint('get user details fold exception : $l');
          }, (r) async {
            final response = r as UserDetailResponseModel;
            await sharedPreferenceHelper.setString(
                userNameKey, response.data?.username ?? "");
            await sharedPreferenceHelper.setString(
                userFirstNameKey, response.data?.firstname ?? "");
            state = state.copyWith(
                loading: false, userData: response.data, editingEnabled: false);
            initializeTextEditController();
          });
        });
      } else {
        UserDetailRequestModel requestModel = UserDetailRequestModel();
        UserDetailResponseModel responseModel = UserDetailResponseModel();
        final result =
            await userDetailUseCase.call(requestModel, responseModel);

        result.fold((l) {
          debugPrint('get user details fold exception : $l');
        }, (r) async {
          final response = r as UserDetailResponseModel;
          await sharedPreferenceHelper.setString(
              userNameKey, response.data?.username ?? "");
          await sharedPreferenceHelper.setString(
              userFirstNameKey, response.data?.firstname ?? "");
          state = state.copyWith(
              loading: false, userData: response.data, editingEnabled: false);
          initializeTextEditController();
        });
      }
    } catch (error) {
      debugPrint('get user details exception : $error');
      state = state.copyWith(loading: false);
    }
  }

  void updateEditing(bool value) {
    state = state.copyWith(editingEnabled: value);
  }

  Future<void> editUserDetails(
      {required void Function() onSuccess,
      required void Function(String msg) onError}) async {
    state = state.copyWith(loading: true);

    final response = tokenStatus.isAccessTokenExpired();
    if (response) {
      RefreshTokenRequestModel requestModel =
      RefreshTokenRequestModel();
      RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

      final refreshResponse =
      await refreshTokenUseCase.call(requestModel, responseModel);

      bool refreshSuccess = await refreshResponse.fold(
            (left) {
          debugPrint('refresh token edit profile details fold exception : $left');
          return false;
        },
            (right) async {
          final res = right as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");
          return true;
        },
      );

      if (!refreshSuccess) {
        state = state.copyWith(loading: false);
        return;
      }
    }

    EditUserDetailRequestModel editUserDetailRequestModel =
        EditUserDetailRequestModel();
    // editUserDetailRequestModel.id = state.userData?.id ?? 0;

    final name = splitFullName(nameEditingController.text);

    if (name['firstName'] != state.userData?.firstname ||
        name['lastName'] != state.userData?.lastname) {
      editUserDetailRequestModel.firstname = name['firstName'];
      editUserDetailRequestModel.lastname = name['lastName'];
    }
    if (phoneNumberEditingController.text != state.userData?.phoneNumber) {
      editUserDetailRequestModel.phoneNumber =
          phoneNumberEditingController.text;
    }
    if (descriptionEditingController.text != state.userData?.description) {
      editUserDetailRequestModel.description =
          descriptionEditingController.text;
    }
    if (websiteEditingController.text != state.userData?.website) {
      editUserDetailRequestModel.website = websiteEditingController.text;
    }

    final imageFile = state.imageFile;
    if (imageFile != null) {
      await uploadUserImage(imageFile);
    }

    try {
      state = state.copyWith(loading: false);
      EditUserDetailsResponseModel editUserDetailsResponseModel =
          EditUserDetailsResponseModel();
      final result = await editUserDetailUseCase.call(
          editUserDetailRequestModel, editUserDetailsResponseModel);
      result.fold((l) {
        state = state.copyWith(loading: false, editingEnabled: true);
        debugPrint(l.toString());
        onError(l.toString());
      }, (r) async {
        var resData = (r as EditUserDetailsResponseModel).status;
        debugPrint("Edit Api Result : $resData");
        // await getUserDetails();
        state = state.copyWith(loading: false, editingEnabled: false);
        MatomoService.trackProfileUpdated(
            userId: state.userData?.id.toString() ?? "0");
        onSuccess();
        debugPrint("Edit API Success");
      });
    } catch (error) {
      state = state.copyWith(loading: false);
      debugPrint(error.toString());
      onError("API Error - ${error.toString()}");
    }
  }

  Map<String, String> splitFullName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));

    String firstName = parts.isNotEmpty ? parts.first : '';
    String lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  bool isAnyFieldEdited(EditUserDetailRequestModel model) {
    return model.firstname != null ||
        model.lastname != null ||
        model.phoneNumber != null ||
        model.description != null ||
        model.website != null;
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      state = state.copyWith(
          imageFile: File(pickedFile.path), editingEnabled: true);
    }
  }

  Future<void> uploadUserImage(File imageFile) async {
    try {
      EditUserImageRequestModel requestModel =
          EditUserImageRequestModel(imagePath: imageFile.path);
      EditUserImageResponseModel responseModel = EditUserImageResponseModel();
      final result =
          await editUserImageUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get user details fold exception : $l');
      }, (r) async {
        final response = r as EditUserImageResponseModel;
      });
    } catch (error) {
      debugPrint('Upload Image exception : $error');
    }
  }

  String? getUrlForImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    return "$imageDownloadingEndpoint$imagePath";
  }
}
