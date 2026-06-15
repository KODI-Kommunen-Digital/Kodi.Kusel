import 'package:core/environment/environment_type.dart';
import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common_widgets/text_styles.dart';
import '../../navigation/navigation.dart';
import 'environment_controller.dart';

Future<void> showEnvironmentDialog(
    {required BuildContext context, required WidgetRef ref}) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: textBoldPoppins(
          color: Colors.white,
          text: AppLocalizations.of(context).select_environment,
        ),
        content: Container(
          color: Theme.of(context).colorScheme.secondary,
          width: double.maxFinite,
          height: 90.h,
          child: ListView(
            shrinkWrap: true,
            children: EnvironmentType.values.map((environment) {
              return RadioTheme(
                  data: RadioThemeData(
                    fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white; // selected radio button
                      }
                      return Colors.white; // unselected radio button
                    }),
                  ),
                  child: RadioListTile<EnvironmentType>(
                    hoverColor: Colors.white,
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: textRegularPoppins(
                          text: environment.name, color: Colors.white),
                    ),
                    value: environment,
                    selectedTileColor: Colors.white,
                    groupValue: ref
                        .watch(environmentControllerProvider)
                        .environmentType,
                    onChanged: (EnvironmentType? value) async {
                      if (value != null) {
                        await ref
                            .read(environmentControllerProvider.notifier)
                            .updateEnvironment(value);
                        ref
                            .read(navigationProvider)
                            .removeDialog(context: context);
                      }
                    },
                  ));
            }).toList(),
          ),
        ),
      );
    },
  );
}
