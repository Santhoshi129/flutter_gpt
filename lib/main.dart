import 'dart:io';
import 'dart:ui';
import 'package:chat_diffusion_app/screens/chat.dart';
import 'package:chat_diffusion_app/utils/constants.dart';
import 'package:chat_diffusion_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await WindowManager.instance.ensureInitialized();

    await windowManager.waitUntilReadyToShow(
      null,
      () async {
        await windowManager.setTitleBarStyle(
          TitleBarStyle.normal,
          windowButtonVisibility: true,
        );
        await windowManager.setTitle(appName);
        await windowManager.center();
        await windowManager.show();
        await windowManager.setPreventClose(false);
        await windowManager.setSkipTaskbar(false);
        await windowManager.setAlwaysOnTop(true);
        await windowManager.setSize(const Size(800, 700));
        await windowManager.setMinimumSize(const Size(800, 700));
        await windowManager.setMaximumSize(const Size(800, 700));
        //await windowManager.setBackgroundColor("181a20".toColor());
      },
    );
  }
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: setThemeData(),
      home: const Scaffold(
        body: ChatScreen(),
      ),
    );
  }
}
