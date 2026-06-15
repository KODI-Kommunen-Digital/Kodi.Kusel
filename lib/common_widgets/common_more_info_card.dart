import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_phone_number_card.dart';
import 'package:kusel/common_widgets/text_styles.dart';

class CommonMoreInfoCard extends ConsumerStatefulWidget {
  final String title;
  final String phoneNumber;
  final String? description;
  final bool? isStrikeThrough;
  final Function()? onTap;

  const CommonMoreInfoCard({
    super.key,
    required this.title,
    required this.phoneNumber,
    this.description,
    this.onTap,
    this.isStrikeThrough
  });

  @override
  ConsumerState<CommonMoreInfoCard> createState() =>
      _CommonMoreInfoCardState();
}

class _CommonMoreInfoCardState extends ConsumerState<CommonMoreInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        5.verticalSpace,
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: textBoldPoppins(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            text: widget.title,
            textOverflow: TextOverflow.visible,
            textAlign: TextAlign.left,
            fontSize: 14,
          ),
        ),
        8.verticalSpace,
        if (widget.description != null)
          textRegularMontserrat(
            textAlign: TextAlign.start,
            fontSize: 12,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            text: widget.description!,
            textOverflow: TextOverflow.visible,
          ),
        10.verticalSpace,
        CommonPhoneNumberCard(
          phoneNumber: widget.phoneNumber,
            isStrikeThrough : widget.isStrikeThrough
        ),
      ],
    );
  }
}
