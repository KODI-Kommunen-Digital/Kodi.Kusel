import 'package:core/base_model.dart';

class EmptyRequest implements BaseModel<EmptyRequest> {

  EmptyRequest();

  @override
  EmptyRequest fromJson(Map<String, dynamic> json) {
    return EmptyRequest(

    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {

    };
  }
}
