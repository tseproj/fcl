import 'dart:async';
import 'dart:io';

import 'package:fcl/utils/storage/init.dart';
import 'package:fcl/routers/router.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        print('${details.exception}, ${details.stack}');
      }
    };

    WidgetsFlutterBinding.ensureInitialized();

    if (!ConfigInitializer.isInitialized) {
      await ConfigInitializer.initializeConfig();
    }

    if (!Platform.isAndroid) {
      await windowManager.ensureInitialized();
      await Window.initialize();
      Size size = const Size(1200, 600);
      WindowOptions windowOptions = WindowOptions(
        title: "FCL",
        size: size,
        minimumSize: const Size(1000, 300),
        center: true,
        skipTaskbar: false,
        windowButtonVisibility: false,
        titleBarStyle: TitleBarStyle.hidden,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }

    runApp(const MainApp());
  }, (error, stack) {
    if (kDebugMode) {
      print('$error, $stack');
    }
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      title: 'FCL App',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: FluentThemeData(
        fontFamily: "HarmonyOSSans",
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
        navigationPaneTheme: const NavigationPaneThemeData(
            backgroundColor: (Colors.transparent)),
      ),
    );
  }
}
