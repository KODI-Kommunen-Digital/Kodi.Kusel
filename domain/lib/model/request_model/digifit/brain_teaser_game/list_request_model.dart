import 'package:core/base_model.dart';

class BrainTeaserGameListRequestModel
    implements BaseModel<BrainTeaserGameListRequestModel> {
  final String translate;

  BrainTeaserGameListRequestModel({required this.translate});

  @override
  Map<String, dynamic> toJson() => {'translate': translate};

  @override
  BrainTeaserGameListRequestModel fromJson(Map<String, dynamic> json) => this;
}
