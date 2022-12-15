import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';

class MainWindow extends StatelessWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final WindowController window = await DesktopMultiWindow.createWindow('Projector Window');
            window.setFrame(const Offset(0, 0) & const Size(0, 0));
            window.show();
          },
        ),
        body: Container(
          color: Colors.green,
        ),
      ),
    );
  }
}
