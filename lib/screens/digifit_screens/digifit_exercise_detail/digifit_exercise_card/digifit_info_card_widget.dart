import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/screens/digifit_screens/digifit_start/digifit_information_controller.dart';

import '../../../../common_widgets/text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../digifit_exercise_details_controller.dart';
import '../enum/digifit_exercise_session_status_enum.dart';

class InfoCardWidget extends ConsumerStatefulWidget {
  final VoidCallback startTimer;
  final int equipmentId;
  final bool showSuccessCard;


  const InfoCardWidget({
    super.key,
    required this.startTimer,
    required this.equipmentId,
    this.showSuccessCard = false
  });

  @override
  ConsumerState<InfoCardWidget> createState() => _InfoCardWidgetState();
}

class _InfoCardWidgetState extends ConsumerState<InfoCardWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(digifitExerciseDetailsControllerProvider(widget.equipmentId));

    final digifitExerciseUserProgress = controller.digifitExerciseEquipmentModel?.userProgress;
    final currentSet = controller.currentSetNumber;
    final totalSet = controller.totalSetNumber;
    final isReadyToSubmitSet = controller.isReadyToSubmitSet;
    final isScanButtonVisible = controller.isScannerVisible;

    return Container(
      width: double.infinity,
      height: (DeviceHelper.isMobile(context))?80.h:100.h,
      padding: EdgeInsets.only(
        top: 16.h,
        right: 24.w,
        bottom: 8.h,
        left: 26.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: widget.showSuccessCard
            ? BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        )
            : BorderRadius.circular(16.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textBoldPoppins(
                      text: AppLocalizations.of(context).digifit_exercise_set,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    SizedBox(height: 6.h),
                    textRegularMontserrat(
                      text: '$currentSet / $totalSet',
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textBoldPoppins(
                      text: AppLocalizations.of(context).digifit_exercise_reps,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    SizedBox(height: 6.h),
                    textRegularMontserrat(
                      text: '${digifitExerciseUserProgress?.repetitionsPerSet ?? 0}',
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: (isScanButtonVisible || !isReadyToSubmitSet)
                  ? null
                  : () {
                final isComplete = controller.digifitExerciseEquipmentModel?.userProgress.isCompleted ?? false;
                if (!isComplete) {
                  final locationId = controller.locationId;
                  final exerciseModel = controller.digifitExerciseEquipmentModel;
                  final reps = exerciseModel?.userProgress.repetitionsPerSet ?? 0;
                  final id = exerciseModel?.id ?? 0;

                  final stage = (currentSet == totalSet - 1)
                      ? ExerciseStageConstant.complete
                      : ExerciseStageConstant.progress;

                  ref.read(digifitExerciseDetailsControllerProvider(widget.equipmentId).notifier).trackExerciseDetails(
                    id,
                    locationId,
                    currentSet,
                    reps,
                    stage,
                        () {
                      ref.read(digifitExerciseDetailsControllerProvider(widget.equipmentId).notifier).updateIsReadyToSubmitSetVisibility(false);

                      if (stage == ExerciseStageConstant.complete) {
                        ref.read(digifitInformationControllerProvider.notifier).fetchDigifitInformation();
                      } else {
                        widget.startTimer();
                      }
                    },
                  );
                }
              },
              child: Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).disabledColor,
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: (!isScanButtonVisible && isReadyToSubmitSet)
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  child: Icon(
                    Icons.check,
                    color: (!isScanButtonVisible && isReadyToSubmitSet)
                        ? Colors.white
                        : Theme.of(context).disabledColor,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
