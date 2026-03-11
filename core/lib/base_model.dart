import 'package:hive_flutter/hive_flutter.dart';
@HiveType(typeId: 0)
abstract class BaseModel<T> {
  Map<String, dynamic> toJson();

  T fromJson(Map<String, dynamic> json);
}

typedef CreateModel<T> = T Function();
