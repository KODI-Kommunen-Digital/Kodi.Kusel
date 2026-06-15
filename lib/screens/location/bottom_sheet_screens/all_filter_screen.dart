import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/location/location_screen_provider.dart';

import '../../../common_widgets/category_icon.dart';
import '../../../common_widgets/image_utility.dart';
import '../../../common_widgets/search_widget/search_widget.dart';
import '../../../l10n/app_localizations.dart';
import '../bottom_sheet_selected_ui_type.dart';
import '../filter_category.dart';

class AllFilterScreen extends ConsumerStatefulWidget {
  ScrollController scrollController;
   AllFilterScreen({super.key,required this.scrollController});

  @override
  ConsumerState<AllFilterScreen> createState() => _AllFilterScreenState();
}

class _AllFilterScreenState extends ConsumerState<AllFilterScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(locationScreenProvider.notifier).getAllEventList();
      ref
          .read(locationScreenProvider.notifier)
          .setSliderHeight(BottomSheetSelectedUIType.allEvent);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      children: [
        Column(children: [
          16.verticalSpace,
          Container(
            height: 5.h,
            width: 100.w,
            padding: EdgeInsets.only(left: 8.w, right: 18.w, bottom: 40.h),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          15.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: SearchWidget(
              onItemClick: (listing) {
                ref.read(locationScreenProvider.notifier).setEventItem(listing);
                ref
                    .read(locationScreenProvider.notifier)
                    .updateBottomSheetSelectedUIType(
                    BottomSheetSelectedUIType.eventDetail);
              },
              searchController: TextEditingController(),
              hintText: AppLocalizations.of(context).enter_search_term,
              suggestionCallback: (search) async {
                List<Listing>? list;
                if (search.isEmpty) return [];
                try {
                  list = await ref.read(locationScreenProvider.notifier).searchList(
                      searchText: search, success: () {}, error: (err) {});
                } catch (e) {
                  return [];
                }
                final sortedList = ref
                    .watch(locationScreenProvider.notifier)
                    .sortSuggestionList(search, list);
                return sortedList;
              },
              isPaddingEnabled: true,
            ),
          ),
          20.verticalSpace,
          GridView.builder(
            shrinkWrap: true,
            itemCount: staticFilterCategoryList(context).length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 90.h,
              crossAxisSpacing: 6.h,
              mainAxisSpacing: 15.h,
            ),
            itemBuilder: (context, index) {
              final listing = staticFilterCategoryList(context)[index];
              final imagePath = getCategoryIconPath(listing.categoryId);

              return filterCard(
                  imagePath, listing.categoryId.toString(), listing.categoryName);
            },
          ),
        ])
      ],
    );
  }

  filterCard(String image, String categoryID, String categoryName) {
    return GestureDetector(
      onTap: () {
        ref
            .read(locationScreenProvider.notifier)
            .updateSelectedCategory(int.parse(categoryID), categoryName);
        ref
            .read(locationScreenProvider.notifier)
            .updateBottomSheetSelectedUIType(
            BottomSheetSelectedUIType.eventList);

      },
      child: Column(
        children: [
          Material(
            elevation: 6,
            shape: const CircleBorder(),
            color: Theme.of(context).colorScheme.onPrimary, // background color
            child: Padding(
              padding: EdgeInsets.all(17),
              child: SizedBox(
                height: 20.h,
                width: 20.w,
                child: ImageUtil.loadLocalSvgImage(
                  imageUrl: image,
                  context: context,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          6.verticalSpace,
          textRegularMontserrat(
              text: categoryName,
              fontSize: 13,
              textAlign: TextAlign.center,
              textOverflow: TextOverflow.visible),
        ],
      ),
    );
  }
}
