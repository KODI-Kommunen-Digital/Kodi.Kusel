import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';

class CustomDropdown extends ConsumerStatefulWidget {
  final String hintText;
  final List<String> items;
  final String selectedItem;
  final Function(String? newValue) onSelected;
  final bool? disableBorder;
  final bool? textAlignCenter;

  const CustomDropdown(
      {super.key,
      required this.hintText,
      required this.items,
      required this.selectedItem,
      required this.onSelected,
      this.disableBorder,
      this.textAlignCenter});

  @override
  ConsumerState<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends ConsumerState<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(30.r),
            border: (widget.disableBorder ?? false)
                ? null
                : Border.all(
                    color: Theme.of(context).dividerColor, width: 0.7)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            style: TextStyle(
                fontSize: 20.sp,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400,
                color: Theme.of(context).textTheme.displayMedium!.color),
            icon: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Theme.of(context).primaryColor,
            ),
            hint: (widget.textAlignCenter ?? false)
                ? Center(
                    child: textRegularPoppins(
                      text: widget.hintText,
                      color: Theme.of(context).hintColor,
                      fontSize: 12,
                    ),
                  )
                : textRegularMontserrat(
                    text: widget.hintText,
                    color: Theme.of(context).hintColor,
                    fontSize: 14,
                  ),
            value: widget.items.contains(widget.selectedItem)
                ? widget.selectedItem
                : null,
            isExpanded: true,
            items: widget.items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: textRegularMontserrat(text: item, fontSize: 14),
              );
            }).toList(),
            onChanged: (String? newValue) {
              widget.onSelected(newValue);
            },
          ),
        ),
      ),
    );
  }
}
