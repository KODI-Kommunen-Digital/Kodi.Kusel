import 'dart:convert';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/listings/search_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/listings_model/search_listings_response_model.dart';
import 'package:domain/usecase/search/search_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/search/search_screen_state.dart';

final searchScreenProvider =
    StateNotifierProvider.autoDispose<SearchScreenProvider, SearchScreenState>(
        (ref) => SearchScreenProvider(
            searchUseCase: ref.read(searchUseCaseProvider),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
            localeManagerController: ref.read(localeManagerProvider.notifier)));

class SearchScreenProvider extends StateNotifier<SearchScreenState> {
  SearchScreenProvider(
      {required this.searchUseCase, required this.sharedPreferenceHelper, required this.localeManagerController})
      : super(SearchScreenState.empty());

  SearchUseCase searchUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  LocaleManagerController localeManagerController;

  Future<List<Listing>> searchList({
    required String searchText,
    required void Function() success,
    required void Function(String message) error,
  }) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();
      SearchRequestModel searchRequestModel = SearchRequestModel(
          searchQuery: searchText,
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");
      SearchListingsResponseModel searchListingsResponseModel =
          SearchListingsResponseModel();

      final result = await searchUseCase.call(
          searchRequestModel, searchListingsResponseModel);
      return result.fold(
        (l) {
          error(l.toString());
          return <Listing>[];
        },
        (r) {
          final listings = (r as SearchListingsResponseModel).data;
          success();
          return listings ?? <Listing>[];
        },
      );
    } catch (e) {
      error(e.toString());
      return <Listing>[];
    }
  }

  loadSavedListings() {
    final jsonString = sharedPreferenceHelper.getString(searchListKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    final savedList = jsonDecode(jsonString);
    state = state.copyWith(
        searchedList: (savedList as List).map((e) => Listing.fromJson(e)).toList());
    print(state.searchedList.length);

  }

  List<Listing> sortSuggestionList(String search, List<Listing> list) {
    search = search.toLowerCase();
    list.sort((a, b) {
      final aTitle = a.title?.toLowerCase() ?? '';
      final bTitle = b.title?.toLowerCase() ?? '';

      final aScore = aTitle.startsWith(search) ? 0 : (aTitle.contains(search) ? 1 : 2);
      final bScore = bTitle.startsWith(search) ? 0 : (bTitle.contains(search) ? 1 : 2);

      if (aScore != bScore) return aScore.compareTo(bScore);
      return aTitle.compareTo(bTitle);
    });

    return list;
  }
}
