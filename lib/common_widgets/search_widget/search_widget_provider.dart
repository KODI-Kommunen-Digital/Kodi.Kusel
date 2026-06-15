import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider =
    StateNotifierProvider<SearchProvider, TextEditingController>(
  (ref) => SearchProvider(),
);

class SearchProvider extends StateNotifier<TextEditingController> {
  SearchProvider() : super(TextEditingController());

  void clearSearch() {
    state.clear();
  }

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}
