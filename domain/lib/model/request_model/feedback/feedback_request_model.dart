import 'package:core/base_model.dart';

class FeedBackRequestModel implements BaseModel<FeedBackRequestModel> {
  final String? userEmail;
  final String? title;
  final String? description;
  final String? language;

  FeedBackRequestModel(
      {this.userEmail, this.title, this.description, this.language});

  @override
  FeedBackRequestModel fromJson(Map<String, dynamic> json) {
    return FeedBackRequestModel(
      userEmail: json['userEmail'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      language: json['language'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'title': title,
      'description': description,
      'language': language
    };
  }
}
