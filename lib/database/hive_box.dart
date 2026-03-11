import 'package:domain/model/request_model/digifit/digifit_update_exercise_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_cache_data_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiveBoxFunctionProvider = Provider((ref) => HiveBoxFunction());

class HiveBoxFunction {

  Future<void> openBox(String name) async {
    await Hive.openBox(name);
  }

  bool isBoxOpen(String name) {
    return Hive.isBoxOpen(name);
  }

  Future<Box<T>?> getBoxReference<T>(String name) async {
    if (isBoxOpen(name)) {
      return Hive.box<T>(name);
    }
    return null;
  }

  Future<void> closeBox(Box box) async {
    await box.close();
  }

  Future<void> clearBox(Box box) async {
    await box.clear();
  }

  Future<T?> getValue<T>(Box box, dynamic key) async {
    return await box.get(key);
  }

  Future<void> putValue<T>(Box box, dynamic key, T value) async {

    await box.put(key, value);
  }

  Future<void> deleteValue<T>(Box box, dynamic key) async {
    if(await containsKey(box, key)) {
      await box.delete(key);
    }
  }

  Future<void> registerAdapters() async {
    Hive.registerAdapter(DigifitCacheDataResponseModelAdapter());
    Hive.registerAdapter(DigifitInformationResponseModelAdapter());
    Hive.registerAdapter(DigifitInformationDataModelAdapter());
    Hive.registerAdapter(DigifitInformationUserStatsModelAdapter());
    Hive.registerAdapter(DigifitInformationParcoursModelAdapter());
    Hive.registerAdapter(DigifitInformationStationModelAdapter());
    Hive.registerAdapter(DigifitInformationActionsModelAdapter());
    Hive.registerAdapter(DigifitUpdateExerciseRequestModelAdapter());
    Hive.registerAdapter(DigifitExerciseRecordModelAdapter());
  }

  Future<bool> containsKey<T>(Box box, dynamic key) async {
    return box.containsKey(key) ;
  }

  Future<List<dynamic>> getAllKeys<T>(Box box) async {
    return box.keys.toList();
  }

  Future<List<T>> getAllValues<T>(Box box) async {
    return box.values.cast<T>().toList() ;
  }

  Future<Map<dynamic,dynamic>> getAllBoxData(Box box)
  async{
    return  box.toMap();
  }

  Future<void> registerHiveAdapters() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DigifitInformationDataModelAdapter());
    }
  }

}
