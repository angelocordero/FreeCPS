import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:freecps/windows/main_window.dart';
import 'package:freecps/windows/projector_window.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.isEmpty) {
    runApp(const MainWindow());
  } else {
    await runProjectorWindow();
  }
}

Future<void> runProjectorWindow() async {
  await windowManager.ensureInitialized();
  DartVLC.initialize();

  WindowOptions windowOptions = const WindowOptions(
    fullScreen: true,
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );

  windowManager.waitUntilReadyToShow(windowOptions);

  windowManager.setBounds(
    null,
    position: const Offset(1920, 0),
    size: const Size(1920, 1080),
    animate: false,
  );
  windowManager.setAsFrameless();
  windowManager.show();

  runApp(const ProjectorWindow());
}
