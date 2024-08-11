import 'dart:async';
import 'dart:io';

import 'package:fcl/riverpods/theme.dart';
import 'package:fcl/utils/storage/init.dart';
import 'package:fcl/routers/router.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    runApp(const ProviderScope(child: MainApp()));
  }, (error, stack) {
    if (kDebugMode) {
      print('$error, $stack');
    }
  });
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, dynamic> theme = ref.watch(themeRiverpod);
    ThemeMode themeMode;
    if (theme["theme"] == "auto") {
      themeMode = ThemeMode.system;
    } else if (theme["theme"] == "dark") {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }

    Widget app = FluentApp.router(
      title: 'FCL App',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: themeMode,
      theme: FluentThemeData(
        fontFamily: "HarmonyOSSans",
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
        navigationPaneTheme: NavigationPaneThemeData(
            backgroundColor:
                (theme["material"] == "default") ? null : Colors.transparent),
      ),
      darkTheme: FluentThemeData(
        fontFamily: "HarmonyOSSans",
        brightness: Brightness.dark,
        visualDensity: VisualDensity.standard,
        focusTheme:
            FocusThemeData(glowFactor: is10footScreen(context) ? 2.0 : 0.0),
        navigationPaneTheme: NavigationPaneThemeData(
            backgroundColor:
                (theme["material"] == "default") ? null : Colors.transparent),
      ),
      builder: (context, child) {
        Widget stack = Stack(children: <Widget>[
          child!,
        ]);

        return Overlay(initialEntries: [
          OverlayEntry(
            builder: (context) => stack,
          )
        ]);
      },
    );
    return app;
  }
}
