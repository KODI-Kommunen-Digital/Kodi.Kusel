import 'dart:async';

import 'package:domain/model/response_model/digifit/brain_teaser_game/pictures_game_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../common_widgets/image_utility.dart';
import '../../../../../../common_widgets/text_styles.dart';
import '../../../../../../l10n/app_localizations.dart';

class Level3DialogWithTimer extends StatefulWidget {
  final List<ImageWithId> allImages;
  final Function(int) onImageSelected;
  final int initialSeconds;
  final VoidCallback onTimeout;
  final VoidCallback onCloseDialog;

  const Level3DialogWithTimer({
    super.key,
    required this.allImages,
    required this.onImageSelected,
    required this.onTimeout,
    required this.onCloseDialog,
    this.initialSeconds = 30,
  });

  @override
  State<Level3DialogWithTimer> createState() => _Level3DialogWithTimerState();
}

class _Level3DialogWithTimerState extends State<Level3DialogWithTimer> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        timer.cancel();
        if (mounted) {
          widget.onCloseDialog();
          widget.onTimeout();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Column(
        children: [
          textBoldPoppins(
            text: AppLocalizations.of(context).select_image,
            textAlign: TextAlign.center,
            fontSize: 18,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _remainingSeconds <= 10
                  ? Colors.red.withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  size: 18,
                  color: _remainingSeconds <= 10 ? Colors.red : Colors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _remainingSeconds <= 10 ? Colors.red : Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: widget.allImages.length,
          itemBuilder: (context, index) {
            final imageItem = widget.allImages[index];
            final imageUrl = imageItem.image ?? '';
            final imageId = imageItem.id;

            return GestureDetector(
              onTap: () {
                _timer?.cancel();
                if (imageId != null) {
                  widget.onImageSelected(int.parse(imageId.toString()));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl.isNotEmpty
                      ? ImageUtil.loadNetworkImage(
                          imageUrl: imageUrl,
                          context: context,
                          sourceId: 1,
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.image,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
