import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/theme_settings.dart';
import '../l10n/generated/app_localizations.dart';
import 'router.dart';
import 'theme.dart';

/// Root widget of the app.
class TrackfitApp extends ConsumerWidget {
  const TrackfitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider).value ?? ThemeMode.system,
      routerConfig: ref.watch(routerProvider),
      // The app draws behind the system navigation bar, so that bar must not
      // paint a background of its own. A region is needed: without one the
      // framework does not send the color of the bar.
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        ),
        child: child!,
      ),
    );
  }
}
