import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/digifit_exercise_details_controller.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/enum/digifit_exercise_timer_state.dart';

import '../../../../l10n/app_localizations.dart';

class PauseCardWidget extends ConsumerStatefulWidget {
  final VoidCallback startTimer;
  final VoidCallback pauseTimer;
  final int equipmentId;

  const PauseCardWidget(
      {super.key,
      required this.startTimer,
      required this.pauseTimer,
      required this.equipmentId});

  @override
  ConsumerState<PauseCardWidget> createState() => _PauseCardWidgetState();
}

class _PauseCardWidgetState extends ConsumerState<PauseCardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(16.r),
        bottomRight: Radius.circular(16.r),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 2.w, right: 36.w, top: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16.h, left: 25.h),
              child: Text(
                ((ref
                            .watch(digifitExerciseDetailsControllerProvider(
                                widget.equipmentId))
                            .timerState ==
                        TimerState.start))
                    ? AppLocalizations.of(context).play
                    : AppLocalizations.of(context).pause,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF151846),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.h, left: 20.h),
              child: textSemiBoldMontserrat(
                  text:
                      '${formatTime(ref.watch(digifitExerciseDetailsControllerProvider(widget.equipmentId)).remainingPauseSecond)}${AppLocalizations.of(context).min}',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            Padding(
              padding: EdgeInsets.only(top: 18.h, bottom: 6.h, left: 30.h),
              child: InkWell(
                onTap: () {
                  if (ref
                          .read(digifitExerciseDetailsControllerProvider(
                              widget.equipmentId))
                          .timerState ==
                      TimerState.start) {
                    widget.pauseTimer();
                  } else {
                    widget.startTimer();
                  }
                },
                child: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: const Color(0xFF233B8C),
                  child: Icon(
                    (ref
                                .watch(digifitExerciseDetailsControllerProvider(
                                    widget.equipmentId))
                                .timerState ==
                            TimerState.start)
                        ? Icons.pause
                        : Icons.skip_next_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
