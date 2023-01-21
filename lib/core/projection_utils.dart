import 'package:desktop_multi_window/desktop_multi_window.dart';

class ProjectionUtils {
  static Future<void> methodChannel({required String methodName, required String arguments, required bool isLive}) async {
    if (!isLive) return;

    int projectionWindowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);

    DesktopMultiWindow.invokeMethod(projectionWindowID, methodName, arguments);
  }

  static Future<void> clearSlide(bool isLive) async {
    if (!isLive) return;

    int projectionWindowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);

    DesktopMultiWindow.invokeMethod(projectionWindowID, 'clearSlide');
  }

  static Future<void> showSlide(String arguments, bool isLive) async {
    if (!isLive) return;

    int projectionWindowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);

    DesktopMultiWindow.invokeMethod(projectionWindowID, 'showSlide', arguments);
  }

  static Future<void> setBackground(String filePath, bool isLive) async {
    if (!isLive) return;

    int projectionWindowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);

    DesktopMultiWindow.invokeMethod(projectionWindowID, 'setBackground', filePath);
  }

  static Future<void> clearBackground(bool isLive) async {
    if (!isLive) return;

    int projectionWindowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);

    DesktopMultiWindow.invokeMethod(projectionWindowID, 'clearBackground');
  }

  static Future<void> close() async {
    int projectionWindowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);

    DesktopMultiWindow.invokeMethod(projectionWindowID, 'close');
  }

  static void open() {
    DesktopMultiWindow.createWindow(
      'Projection Window',
    );
  }
}
