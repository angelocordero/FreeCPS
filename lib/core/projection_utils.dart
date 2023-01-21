import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:freecps/core/constants.dart';

class ProjectionUtils {
  static void methodChannel({required String methodName, required String arguments, required bool isLive}) {
    if (!isLive) return;

    DesktopMultiWindow.invokeMethod(projectionWindowID, methodName, arguments);
  }

  static void clearSlide(bool isLive) {
    if (!isLive) return;
    DesktopMultiWindow.invokeMethod(projectionWindowID, 'clearSlide');
  }

  static void showSlide(String text, bool isLive) {
    if (!isLive) return;
    DesktopMultiWindow.invokeMethod(projectionWindowID, 'showSlide', text);
  }

  static void setBackground(String filePath, bool isLive) {
    if (!isLive) return;

    DesktopMultiWindow.invokeMethod(projectionWindowID, 'setBackground', filePath);
  }

  static void clearBackground(bool isLive) {
    if (!isLive) return;

    DesktopMultiWindow.invokeMethod(projectionWindowID, 'clearBackground');
  }

  static void close() {
    DesktopMultiWindow.invokeMethod(projectionWindowID, 'close');
  }

  static void open() {
    DesktopMultiWindow.createWindow(
      jsonEncode(
        {
          'args1': 'Projection Window',
          'args2': projectionWindowID,
        },
      ),
    );
  }
}
