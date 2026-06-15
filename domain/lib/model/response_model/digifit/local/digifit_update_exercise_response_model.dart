import 'package:core/base_model.dart';

class DigifitUpdateExerciseResponseModel
    extends BaseModel<DigifitUpdateExerciseResponseModel> {
  final String status;
  final String message;

  DigifitUpdateExerciseResponseModel({
    this.status = '',
    this.message = '',
  });

  @override
  DigifitUpdateExerciseResponseModel fromJson(Map<String, dynamic> json) {
    return DigifitUpdateExerciseResponseModel(
      status: json['status']?.toString() ?? '',
      message: json['data']?['message']?.toString() ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': {
        'message': message,
      },
    };
  }
}
