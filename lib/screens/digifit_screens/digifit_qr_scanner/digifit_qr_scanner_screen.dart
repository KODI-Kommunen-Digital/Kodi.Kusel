import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/digifit_exercise_details_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../common_widgets/arrow_back_widget.dart';
import '../../../navigation/navigation.dart';
import 'digifit_qr_scanner_controller.dart';

class DigifitQRScannerScreen extends ConsumerStatefulWidget {
  const DigifitQRScannerScreen({super.key});

  @override
  ConsumerState<DigifitQRScannerScreen> createState() =>
      _DigifitQRScannerScreenState();
}

class _DigifitQRScannerScreenState
    extends ConsumerState<DigifitQRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.all],
  );

  bool _isScanComplete = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    MatomoService.trackDigifitQrViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScannerUi(),
    );
  }

  _buildScannerUi() {
    final stateNotifier = ref.read(digifitQrScannerControllerProvider.notifier);
    return Stack(
      children: [
        MobileScanner(
            controller: cameraController,
            onDetect: (capture) async {
              final Barcode barcode = capture.barcodes.first;

              if (!_isScanComplete) {
                _isScanComplete = true;
                final String code = barcode.rawValue ?? '---';

                stateNotifier.trackCodeScanned();
                debugPrint('link received after scan : $code');
                ref.read(navigationProvider).removeTopPageAndReturnValue(
                    context: context, result: code);
              }
            }),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            painter: ScannerOverlay(
              borderColor: Theme.of(context).indicatorColor,
              borderWidth: 3.w,
              borderRadius: 12.r,
              cutOutSize: MediaQuery.of(context).size.width * 0.7,
              overlayColor:
                  Colors.black.withOpacity(0.5), // Adjust opacity here
            ),
          ),
        ),
        Positioned(
            bottom: 200,
            left: 50,
            right: 50,
            child: textSemiBoldPoppins(
                color: Theme.of(context).textTheme.labelSmall?.color,
                fontSize: 18,
                textOverflow: TextOverflow.visible,
                text: AppLocalizations.of(context).scan_the_qr_text)),
        Positioned(
            top: 50,
            left: 20,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ArrowBackWidget(
                  onTap: () {
                    ref
                        .read(navigationProvider)
                        .removeTopPage(context: context);
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => cameraController.toggleTorch(),
                      icon: Icon(Icons.flashlight_on,
                          color: Theme.of(context).canvasColor),
                    ),
                    IconButton(
                      onPressed: () => cameraController.switchCamera(),
                      icon: Icon(Icons.cameraswitch,
                          color: Theme.of(context).canvasColor),
                    ),
                  ],
                )
              ],
            )),
      ],
    );
  }
}

class ScannerOverlay extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double cutOutSize;
  final Color overlayColor;

  ScannerOverlay({
    this.borderColor = Colors.red,
    this.borderWidth = 4.0,
    this.borderRadius = 12.0,
    required this.cutOutSize,
    this.overlayColor = const Color(0xAA000000), // Semi-transparent black
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    // Draw the background overlay
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Calculate dimensions for the cutout
    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutOutSize,
      height: cutOutSize,
    );

    // Create a path that covers the entire screen
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create a path for the cutout
    final cutOutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        cutOutRect,
        Radius.circular(borderRadius),
      ));

    // Create a combined path that shows the overlay everywhere except the cutout
    final combinedPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutOutPath,
    );

    // Draw the combined path
    canvas.drawPath(combinedPath, backgroundPaint);

    // Draw border around cutout
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
