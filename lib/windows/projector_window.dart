import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class ProjectorWindow extends StatelessWidget {
  const ProjectorWindow({super.key});

  @override
  Widget build(BuildContext context) {
    DesktopMultiWindow.setMethodHandler(
      (call, _) async {
        if (call.method == 'close') {
          windowManager.close();
        }
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Container(),
      ),
    );
  }
}
