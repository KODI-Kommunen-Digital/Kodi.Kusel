import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/text_to_speech_widget/text_to_speech_controller.dart';
import 'package:kusel/common_widgets/text_to_speech_widget/text_to_speech_widget.dart';
import 'package:kusel/images_path.dart';

import '../theme_manager/colors.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FeedbackCardWidget extends ConsumerStatefulWidget {
  final Function() onTap;
  final double? height;
  final bool enableTts;

  const FeedbackCardWidget({
    super.key,
    required this.onTap,
    this.height,
    this.enableTts = false,
  });

  @override
  ConsumerState<FeedbackCardWidget> createState() => _FeedbackCardWidgetState();
}

class _FeedbackCardWidgetState extends ConsumerState<FeedbackCardWidget> {
  @override
  Widget build(BuildContext context) {
    final heading = AppLocalizations.of(context).feedback_heading;
    final description = AppLocalizations.of(context).feedback_description;

    return Container(
      height: widget.height,
      color: lightThemeFeedbackCardColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
            child: Row(
              children: [
                Image.asset(
                  imagePath['feedback_image.png'] ?? '',
                  height: 110.h,
                  width: 110.w,
                ),

                /// TEXT SECTION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: textBoldPoppins(
                              fontWeight: FontWeight.w600,
                              text: heading,
                              fontSize: 15,
                              color: Colors.white,
                              textOverflow: TextOverflow.visible,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          if(widget.enableTts &&
                              (!ref.watch(textToSpeechControllerProvider).isPlaying || ref.watch(textToSpeechControllerProvider).ttsWidgetId == "feedback_card"))
                            Expanded(
                              flex: 1,
                              child: TextToSpeechButton(
                                texts: [heading, description],
                                size: TtsButtonSize.small,
                                isDarkTheme: true,
                                ttsWidgetId: 'feedback_card', // Optional: provide consistent ID
                              ),
                            )
                        ],
                      ),

                      SizedBox(height: 8.h),

                      /// DESCRIPTION + TTS
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: textSemiBoldPoppins(
                                text: description,
                                color: Colors.white,
                                fontSize: 12,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w200,
                                textOverflow: TextOverflow.visible,
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                )
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            child: CustomButton(
              onPressed: widget.onTap,
              text: AppLocalizations.of(context).send_feedback,
              buttonColor: Theme.of(context).primaryColor,
            ),
          ),

          28.verticalSpace
        ],
      ),
    );
  }
}