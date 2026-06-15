import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';

import '../../offline_router.dart';

class NetworkStatusScreen extends ConsumerStatefulWidget {
  const NetworkStatusScreen({super.key});

  @override
  ConsumerState<NetworkStatusScreen> createState() =>
      _NetworkStatusScreenState();
}

class _NetworkStatusScreenState extends ConsumerState<NetworkStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_sharp,
                size: 25.h.w,
                color: Theme.of(context).primaryColor,
              ),
              10.verticalSpace,
              textBoldPoppins(text: "No internet connection!", fontSize: 18),
              10.verticalSpace,
              textRegularPoppins(
                  text: "Please check your internet and try again"),
              25.verticalSpace,
              CustomButton(
                onPressed: () => ref
                    .read(networkStatusProvider.notifier)
                    .checkNetworkStatus(),
                text: "Retry",
                width: 200,
              ),
              20.verticalSpace,
              CustomButton(
                onPressed: () => ref
                    .read(navigationProvider)
                    .removeAllAndNavigate(
                        path: offlineDigifitStartScreenPath, context: context),
                text: AppLocalizations.of(context).digifit,
                width: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
