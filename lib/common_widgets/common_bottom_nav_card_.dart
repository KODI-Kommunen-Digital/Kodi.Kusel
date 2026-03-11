import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/enum/digifit_exercise_session_status_enum.dart';

import '../l10n/app_localizations.dart';
import '../screens/digifit_screens/brain_teaser_game/enum/game_session_status.dart';

class CommonBottomNavCard extends ConsumerStatefulWidget {
  final void Function() onBackPress;
  final void Function()? onFavChange;
  bool isFavVisible;
  bool isFav;
  ExerciseStageConstant? sessionStage;
  final VoidCallback? onSessionTap;
  GameStageConstant? gameDetailsStageConstant;
  final VoidCallback? onGameStageConstantTap;
  bool? isScannerVisible;
  final VoidCallback? onScannerTap;

  CommonBottomNavCard(
      {super.key,
      required this.onBackPress,
      required this.isFavVisible,
      this.onFavChange,
      required this.isFav,
      this.sessionStage,
      this.onSessionTap,
      this.gameDetailsStageConstant,
      this.onGameStageConstantTap,
      this.isScannerVisible,
      this.onScannerTap});

  @override
  ConsumerState<CommonBottomNavCard> createState() =>
      _CommonBottomNavCardState();
}

class _CommonBottomNavCardState extends ConsumerState<CommonBottomNavCard> {
  @override
  Widget build(BuildContext context) {
    String buttonText = '';
    IconData icon = Icons.close;

    final canAbortTap = widget.sessionStage == ExerciseStageConstant.start ||
        widget.sessionStage == ExerciseStageConstant.progress;

    if (widget.gameDetailsStageConstant != null) {
      switch (widget.gameDetailsStageConstant) {
        case GameStageConstant.initial:
          buttonText = AppLocalizations.of(context)
              .digifit_exercise_details_start_session;
          icon = Icons.play_circle_outline;
          break;

        case GameStageConstant.progress:
          buttonText = AppLocalizations.of(context).digifit_abort;
          icon = Icons.close;
          break;

        case GameStageConstant.abort:
          buttonText = AppLocalizations.of(context).try_again;
          icon = Icons.refresh;
          break;

        case GameStageConstant.complete:
          buttonText = AppLocalizations.of(context)
              .digifit_exercise_details_start_session;
          icon = Icons.play_circle_outline;
          break;

        default:
          buttonText = AppLocalizations.of(context)
              .digifit_exercise_details_start_session;
          icon = Icons.play_arrow;
          break;
      }
    }

    if (widget.sessionStage != null) {
      switch (widget.sessionStage) {
        case ExerciseStageConstant.initial:
          buttonText = AppLocalizations.of(context)
              .digifit_exercise_details_start_session;
          icon = Icons.flag_outlined;
          break;

        case ExerciseStageConstant.start:
          buttonText = AppLocalizations.of(context).digifit_abort;
          icon = Icons.close;
          break;

        case ExerciseStageConstant.progress:
          buttonText = AppLocalizations.of(context).digifit_abort;
          icon = Icons.close;
          break;

        case ExerciseStageConstant.complete:
          buttonText = AppLocalizations.of(context).complete;
          icon = Icons.verified_outlined;
          break;

        default:
          buttonText = 'Start';
          icon = Icons.play_arrow;
          break;
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left:16.w,right: 4.w),
      height: 50.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Theme.of(context).colorScheme.secondary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 48.h,
            width: 48.w,
            child: IconButton(
              onPressed: widget.onBackPress,
              icon: Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.arrow_back,
                color: Theme.of(context).canvasColor,
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: widget.isFavVisible,
                child: GestureDetector(
                  onTap: widget.onFavChange,
                  child: SizedBox(
                    height: 30.h,
                    width: 30.w,
                    child: Icon(
                      size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                      widget.isFav
                          ? Icons.favorite_sharp
                          : Icons.favorite_border,
                      color: !widget.isFav
                          ? Theme.of(context).canvasColor
                          : Theme.of(context).colorScheme.onTertiaryFixed,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.isFavVisible,
                child: SizedBox(width: 10.w),
              ),
              Visibility(
                visible: widget.sessionStage != null,
                child: GestureDetector(
                  onTap: canAbortTap ? widget.onSessionTap : null,
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            color: Colors.white,
                            size: 18.h.w,
                          ),
                          8.horizontalSpace,
                          textBoldMontserrat(
                            text: buttonText,
                            color: Colors.white,
                            textOverflow: TextOverflow.visible,
                            fontSize: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.gameDetailsStageConstant != null,
                child: GestureDetector(
                  onTap: widget.onGameStageConstantTap,
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 9.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.gameDetailsStageConstant ==
                                  GameStageConstant.abort
                              ? Transform.scale(
                                  scaleX: -1,
                                  child: Transform.rotate(
                                    angle: -1.5708,
                                    child: Icon(
                                      icon,
                                      color: Colors.white,
                                      size: 18.h.w,
                                    ),
                                  ),
                                )
                              : Icon(
                                  icon,
                                  color: Colors.white,
                                  size: 18.h.w,
                                ),
                          8.horizontalSpace,
                          textBoldMontserrat(
                            text: buttonText,
                            color: Colors.white,
                            textOverflow: TextOverflow.visible,
                            fontSize: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.isScannerVisible ?? false,
                child: GestureDetector(
                  onTap: widget.onScannerTap,
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ImageUtil.loadAssetImage(
                            imageUrl: imagePath['scanner_image'] ?? '',
                            height: 20.h,
                            width: 20.w,
                            fit: BoxFit.contain,
                            context: context,
                          ),
                          8.horizontalSpace,
                          textBoldMontserrat(
                            text: AppLocalizations.of(context).details_scanner,
                            color: Colors.white,
                            textOverflow: TextOverflow.visible,
                            fontSize: 16,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
