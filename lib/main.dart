import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/file_utils.dart';
import 'package:freecps/windows/main_window.dart';
import 'package:freecps/windows/projector_window.dart';
import 'package:window_manager/window_manager.dart';

void main(List<String> args) {

// TODO: put in initialize window before main window?
  FileUtils.initializeDirectories();
  WidgetsFlutterBinding.ensureInitialized();
  DartVLC.initialize();

  if (args.isEmpty) {


    // TODO: put minimum size in main window
    runApp(
      ProviderScope(
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: const MainWindow(),
        ),
      ),
    );

  } else {
    runProjectorWindow();
  }
}

void runProjectorWindow() {
  windowManager.ensureInitialized();
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
  windowManager.setClosable(false);
  runApp(const ProjectorWindow());
  windowManager.show();
}
