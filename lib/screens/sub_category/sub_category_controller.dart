import 'package:domain/model/request_model/sub_category/sub_category_request_model.dart';
import 'package:domain/model/response_model/sub_catgory/sub_category_response_model.dart';
import 'package:domain/usecase/sub_category/sub_category_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/sub_category/sub_catgory_state.dart';

final subCategoryProvider =
    StateNotifierProvider<SubCategoryController, SubCategoryState>((ref) =>
        SubCategoryController(
            subCategoryUseCase: ref.read(subCategoryUseCaseProvider)));

class SubCategoryController extends StateNotifier<SubCategoryState> {
  SubCategoryUseCase subCategoryUseCase;

  SubCategoryController({required this.subCategoryUseCase})
      : super(SubCategoryState.empty());

  getAllSubCategory({required int categoryId}) async {
    try {
      state = state.copyWith(isLoading: true);
      SubCategoryRequestModel requestModel =
          SubCategoryRequestModel(id: categoryId);
      SubCategoryResponseModel responseModel = SubCategoryResponseModel();

      final response =
          await subCategoryUseCase.call(requestModel, responseModel);

      response.fold((l) {
        state = state.copyWith(isLoading: false);
      }, (r) {
        final data = r as SubCategoryResponseModel;

        state =
            state.copyWith(isLoading: false, subCategoryDataList: data.data);

        debugPrint("length == ${data.data?.length??0}");
      });
    } catch (error) {
      state = state.copyWith(isLoading: false);
      debugPrint('sub category exception : $error');
    }
  }
}
