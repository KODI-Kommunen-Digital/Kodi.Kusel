import 'package:domain/model/request_model/digifit/digifit_update_exercise_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_cache_data_response_model.dart';

class DigifitCacheDataState {
  bool isCacheDataAvailable;
  bool isExerciseCacheDataAvailable;
  bool isLoading;
  DigifitCacheDataResponseModel? digifitCacheDataResponseModel;
  DigifitUpdateExerciseRequestModel? digifitUpdateExerciseRequestModel;
  String errorMessage;

  DigifitCacheDataState(this.isCacheDataAvailable,
      this.isExerciseCacheDataAvailable, this.isLoading,
      this.digifitCacheDataResponseModel, this.digifitUpdateExerciseRequestModel, this.errorMessage);

  factory DigifitCacheDataState.empty() {
    return DigifitCacheDataState(false, false, false, null, null, '');
  }

  DigifitCacheDataState copyWith({bool? isCacheDataAvailable,
    bool? isExerciseCacheDataAvailable,
    bool? isLoading,
    DigifitCacheDataResponseModel? digifitCacheDataResponseModel,
    DigifitUpdateExerciseRequestModel? digifitUpdateExerciseRequestModel,
    String? errorMessage}) {
    return DigifitCacheDataState(
        isCacheDataAvailable ?? this.isCacheDataAvailable,
        isExerciseCacheDataAvailable ?? this.isExerciseCacheDataAvailable,
        isLoading ?? this.isLoading,
        digifitCacheDataResponseModel ?? this.digifitCacheDataResponseModel,
        digifitUpdateExerciseRequestModel ?? this.digifitUpdateExerciseRequestModel,
        errorMessage ?? this.errorMessage);
  }
}
