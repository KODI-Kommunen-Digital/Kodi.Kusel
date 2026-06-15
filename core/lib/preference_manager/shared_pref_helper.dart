import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // This will be overridden in main
});

// SharedPreferenceHelper provider
final sharedPreferenceHelperProvider = Provider<SharedPreferenceHelper>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPreferenceHelper(prefs: prefs);
});

class SharedPreferenceHelper {
  final SharedPreferences prefs;

  SharedPreferenceHelper({required this.prefs});

  String? getString(String key) {
    final res = prefs.getString(key);

    return (res == null)
        ? null
        : (res.isEmpty)
            ? null
            : res;
  }

  Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  int? getInt(String key) => prefs.getInt(key);

  bool? getBool(String key) {
    final res = prefs.getBool(key);

    return (res == null)
        ? null
        : res;
  }

  Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  Future<void> saveObject(String key, dynamic object) async {
    String objectJson = jsonEncode(object.toJson());
    await prefs.setString(key, objectJson);
  }

  Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  Future<void> clear() async {
    await prefs.clear();
  }
}
