import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/digifit_exercise_details_controller.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/video_player/video_player_controller.dart';
import 'package:video_player/video_player.dart';

import '../digifit_exercise_card/digifit_exercise_timer_widget.dart';
import '../digifit_exercise_card/digifit_info_card_widget.dart';
import '../digifit_exercise_card/digifit_success_card_widget.dart';

class DigifitVideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;
  final VoidCallback startTimer;
  final VoidCallback pauseTimer;
  final int sourceId;
  final int equipmentId;

  const DigifitVideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.startTimer,
    required this.pauseTimer,
    required this.sourceId,
    required this.equipmentId,
  });

  @override
  ConsumerState<DigifitVideoPlayerWidget> createState() =>
      _DigifitVideoPlayerWidgetState();
}

class _DigifitVideoPlayerWidgetState
    extends ConsumerState<DigifitVideoPlayerWidget> {
  @override
  void didUpdateWidget(covariant DigifitVideoPlayerWidget oldWidget) {
    if ((oldWidget.videoUrl != widget.videoUrl && widget.videoUrl.isNotEmpty) &&
        (oldWidget.sourceId != widget.sourceId && widget.sourceId != 0)) {
      ref
          .read(videoPlayerControllerProvider(widget.equipmentId).notifier)
          .initializeVideoController(widget.videoUrl, widget.sourceId);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        ref.watch(digifitExerciseDetailsControllerProvider(widget.equipmentId));

    bool isPauseCardWidgetVisible = (controller.isScannerVisible == false &&
        !controller.isReadyToSubmitSet &&
        (controller.digifitExerciseEquipmentModel?.userProgress.isCompleted !=
                null &&
            !controller
                .digifitExerciseEquipmentModel!.userProgress.isCompleted));

    bool isSuccessCardVisible = (controller.isScannerVisible == false &&
        !controller.isReadyToSubmitSet &&
        controller.digifitExerciseEquipmentModel?.userProgress.isCompleted ==
            true);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildVideoPlayer(),
                SizedBox(height: 28.h),
                Visibility(
                  visible: isPauseCardWidgetVisible,
                  child: PauseCardWidget(
                    startTimer: widget.startTimer,
                    pauseTimer: widget.pauseTimer,
                    equipmentId: widget.equipmentId,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 214.h,
              left: 0.w,
              right: 0.w,
              child: Material(
                elevation: 6,
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(isSuccessCardVisible ? 0 : 16.r),
                  bottomRight: Radius.circular(isSuccessCardVisible ? 0 : 16.r),
                ),
                child: Column(
                  children: [
                    InfoCardWidget(
                      startTimer: widget.startTimer,
                      equipmentId: widget.equipmentId,
                      showSuccessCard: isSuccessCardVisible,
                    ),
                    if (isSuccessCardVisible) const SuccessCardWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    final videoControllerState =
        ref.watch(videoPlayerControllerProvider(widget.equipmentId));
    final controller = ref.watch(digifitExerciseDetailsControllerProvider(widget.equipmentId));
    bool isSuccessCardVisible = (controller.isScannerVisible == false &&
        !controller.isReadyToSubmitSet &&
        controller.digifitExerciseEquipmentModel?.userProgress.isCompleted == true);

    return Container(
      width: 361.w,
      height: 246.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: Radius.circular(isSuccessCardVisible ? 0 : 16.r),
          bottomRight: Radius.circular(isSuccessCardVisible ? 0 : 16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF283583).withOpacity(0.4),
            offset: const Offset(0, 4),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
          bottomLeft: Radius.circular(isSuccessCardVisible ? 0 : 16.r),
          bottomRight: Radius.circular(isSuccessCardVisible ? 0 : 16.r),
        ),
        child: videoControllerState.when(
          data: (controller) => GestureDetector(
            onTap: () {
              ref
                  .read(videoPlayerControllerProvider(widget.equipmentId)
                      .notifier)
                  .playPauseVideo();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ColoredBox(
                    color: const Color(0xFF283583),
                    child: VideoPlayer(controller),
                  ),
                ),
                if (!controller.value.isPlaying)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.play_arrow,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          loading: () => Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF283583),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          error: (error, _) => Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red.shade100,
            ),
            child: const Center(
              child: Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
