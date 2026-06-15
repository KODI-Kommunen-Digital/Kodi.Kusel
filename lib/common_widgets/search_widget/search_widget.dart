import 'dart:async';
import 'dart:convert';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';

import '../../l10n/app_localizations.dart';
import '../../utility/kusel_date_utils.dart';
import '../image_utility.dart';

class SearchWidget extends ConsumerStatefulWidget {
  String hintText;
  TextEditingController searchController;
  FutureOr<List<Listing>?> Function(String) suggestionCallback;
  Function(Listing) onItemClick;
  VerticalDirection? verticalDirection;
  bool isPaddingEnabled;

  SearchWidget(
      {super.key,
        required this.hintText,
        required this.searchController,
        required this.suggestionCallback,
        required this.onItemClick,
        this.verticalDirection,
        required this.isPaddingEnabled});

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      width: 350.w,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(width: 1, color: Theme.of(context).dividerColor)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0.w),
          child: Row(
            children: [
              ImageUtil.loadSvgImage(
                  height: DeviceHelper.isMobile(context) ? null : 15.h,
                  width: DeviceHelper.isMobile(context) ? null : 15.h,
                  imageUrl: imagePath['search_icon'] ?? '',
                  context: context),
              8.horizontalSpace,
              Expanded(
                child: TypeAheadField<Listing>(
                  hideOnEmpty: true,
                  hideOnUnfocus: false,
                  hideOnSelect: true,
                  hideWithKeyboard: false,
                  direction: widget.verticalDirection ?? VerticalDirection.down,
                  debounceDuration: Duration(milliseconds: 1000),
                  controller: widget.searchController,
                  suggestionsCallback: widget.suggestionCallback,

                  decorationBuilder: (context, widget) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Container(
                        padding: super.widget.isPaddingEnabled
                            ? EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 5.w)
                            : null,
                        constraints: BoxConstraints(
                            maxHeight: 250.h,
                            maxWidth: double
                                .infinity // Set max height here as per your UI
                        ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(10.r)),
                        child: widget,
                      ),
                    );
                  },
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode, // Add this
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                          isDense: true,
                          hintText: widget.hintText,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).hintColor,
                              fontStyle: FontStyle.italic)),
                      onSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                  itemBuilder: (context, event) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 2.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: textRegularPoppins(
                            text: event.title ?? "",
                            fontSize: 16,
                            color: Colors.black87,
                            textAlign:
                                TextAlign.start, // Ensure text is left-aligned
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: textRegularPoppins(
                              text: KuselDateUtils.formatDate(
                                  event.startDate ?? ""),
                              fontSize: 14,
                              color: Colors.grey[600],
                              textAlign: TextAlign
                                  .start, // Ensure text is left-aligned
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ),
                    );
                  },
                  onSelected: (listing) {
                    widget.searchController.clear();
                    FocusScope.of(context).unfocus();
                    saveListingToPrefs(listing);
                    widget.onItemClick(listing);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  saveListingToPrefs(Listing newListing) {
    final existingJson =
        ref.read(sharedPreferenceHelperProvider).getString(searchListKey);

    List<Listing> currentListings = [];
    if (existingJson != null && existingJson.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(existingJson);
      currentListings = decoded.map((e) => Listing.fromJson(e)).toList();
    }

    currentListings.removeWhere((item) => item.id == newListing.id);
    currentListings.add(newListing);
    if (currentListings.length > 5) {
      currentListings.removeAt(0);
    }
    final updatedJson =
        jsonEncode(currentListings.map((e) => e.toJson()).toList());
    ref
        .read(sharedPreferenceHelperProvider)
        .setString(searchListKey, updatedJson);
  }
}

// TODO: This search widget is for the dropdown when sending a string.
// TODO:- Currently using setState, but will be refactored for a better implementation.

class SearchStringWidget extends ConsumerStatefulWidget {
  final TextEditingController searchController;
  final FutureOr<List<String>?> Function(String) suggestionCallback;
  final Function(String) onItemClick;
  final Function(String)? onFieldSubmitted;
  final VerticalDirection? verticalDirection;
  final bool isPaddingEnabled;

  const SearchStringWidget({
    super.key,
    required this.searchController,
    required this.suggestionCallback,
    required this.onItemClick,
    this.onFieldSubmitted,
    this.verticalDirection,
    required this.isPaddingEnabled,
  });

  @override
  ConsumerState<SearchStringWidget> createState() => SearchStringWidgetState();
}

class SearchStringWidgetState extends ConsumerState<SearchStringWidget> {
  final SuggestionsController<String> _suggestionsController =
  SuggestionsController<String>();
  final FocusNode _focusNode = FocusNode();
  String _lastSelectedValue = '';
  bool _showSuggestions = false;
  bool _hasResults = false;
  List<String> _currentFilteredSuggestions = [];
  bool _hasFocus = false; // Track focus state

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _suggestionsController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void closeSuggestions() {
    setState(() {
      _showSuggestions = false;
      _hasResults = false;
    });
    _suggestionsController.close();
  }

  void openSuggestions() {
    if (!_focusNode.hasFocus) _focusNode.requestFocus();
    _suggestionsController.refresh();
    setState(() {
      _showSuggestions = true;
    });
  }

  bool get isFocused => _focusNode.hasFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          width: 1.5.h.w,
          color: _hasFocus
              ? Theme.of(context).indicatorColor
              : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(1.h.w),
        child: Center(
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                  width: 1,
                  color: Theme.of(context).dividerColor
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 12.0.w, right: 0.w),
                child: Row(
                  children: [
                    Expanded(
                      child: TypeAheadField<String>(
                        controller: widget.searchController,
                        focusNode: _focusNode,
                        suggestionsController: _suggestionsController,
                        hideOnEmpty: true,
                        hideOnUnfocus: false,
                        hideOnSelect: true,
                        hideWithKeyboard: false,
                        direction: widget.verticalDirection ?? VerticalDirection.down,
                        debounceDuration: Duration(milliseconds: 300),
                        suggestionsCallback: (pattern) async {
                          final results = await widget.suggestionCallback(pattern);

                          if (results == null || results.isEmpty) {
                            setState(() {
                              _currentFilteredSuggestions = [];
                              _showSuggestions = false;
                              _hasResults = false;
                            });
                            return [];
                          }

                          final lowerPattern = pattern.toLowerCase().trim();
                          List<String> filteredResults;

                          if (lowerPattern.isEmpty) {
                            filteredResults = results;
                          } else {
                            final startsWith = <String>[];
                            final contains = <String>[];
                            for (final item in results) {
                              if (item.toLowerCase().startsWith(lowerPattern)) {
                                startsWith.add(item);
                              } else if (item.toLowerCase().contains(lowerPattern)) {
                                contains.add(item);
                              }
                            }
                            filteredResults = [...startsWith, ...contains];
                          }
                          setState(() {
                            _currentFilteredSuggestions = filteredResults;
                            _showSuggestions = filteredResults.isNotEmpty;
                            _hasResults = _showSuggestions;
                          });

                          return filteredResults;
                        },
                        itemBuilder: (context, suggestion) {
                          return Column(
                            children: [
                              ListTile(
                                title: textRegularPoppins(text: suggestion,
                                        fontSize: 15,
                          textAlign: TextAlign.left,
                                        color: Theme.of(context).primaryColor),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    size: 18,
                                  color: Theme.of(context).primaryColor, // Blue text color
                                ), // Blue icon color
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          );
                        },
                        onSelected: (suggestion) {
                          _lastSelectedValue = suggestion;
                          widget.onItemClick(suggestion);
                          setState(() {
                            _showSuggestions = false;
                            _hasResults = false;
                          });
                          _suggestionsController.close();
                          _focusNode.unfocus();
                        },
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.searchController.text.isEmpty
                                  ? '${AppLocalizations.of(context).search}...'
                                  : null,
                              hintStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: "Poppins",
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).hintColor),
                            ),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  _showSuggestions = false;
                                  _hasResults = false;
                                });
                              }
                            },
                            onSubmitted: (value) {
                              if (_currentFilteredSuggestions.length == 1) {
                                final firstSuggestion = _currentFilteredSuggestions.first;
                                widget.searchController.text = firstSuggestion;
                                widget.onItemClick(firstSuggestion);
                                widget.onFieldSubmitted?.call(firstSuggestion);

                                setState(() {
                                  _showSuggestions = false;
                                  _hasResults = false;
                                });
                                _suggestionsController.close();
                                _focusNode.unfocus();
                              } else {
                                setState(() {
                                  _showSuggestions = false;
                                  _hasResults = false;
                                });
                                _suggestionsController.close();
                                _focusNode.unfocus();

                                if (value.trim().isNotEmpty && _currentFilteredSuggestions.length > 1) {
                                }
                              }
                            },
                          );
                        },
                        decorationBuilder: (context, widgetChild) {
                          if (!_showSuggestions || !_hasResults)
                            return SizedBox.shrink();
                          return Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                            child: Container(
                              padding: widget.isPaddingEnabled
                                  ? EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 5.w)
                                  : null,
                              constraints: BoxConstraints(
                                  maxHeight: 250.h, maxWidth: double.infinity),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).canvasColor,
                                  borderRadius: BorderRadius.circular(6.r),),
                              child: widgetChild,
                            ),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showSuggestions = !_showSuggestions;
                        });
                        if (_showSuggestions) {
                          openSuggestions();
                        } else {
                          _suggestionsController.close();
                        }
                      },
                      child: Icon(Icons.keyboard_arrow_down,
                          color: Theme.of(context).iconTheme.color ?? Colors.grey,
                          size: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}