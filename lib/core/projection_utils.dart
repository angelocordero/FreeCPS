import 'package:desktop_multi_window/desktop_multi_window.dart';

class ProjectionUtils {
  static Future<void> methodChannel({required String methodName, String? arguments, required bool isLive}) async {
    if (!isLive) return;

    int projectionWindowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);

    DesktopMultiWindow.invokeMethod(projectionWindowID, methodName, arguments);
  }

  static Future<void> clearSlide(bool isLive) async {
    if (!isLive) return;

    await methodChannel(methodName: 'clearSlide', isLive: isLive);
  }

  static Future<void> showSongSlide(String arguments, bool isLive) async {
    if (!isLive) return;

    await methodChannel(methodName: 'showSongSlide', arguments: arguments, isLive: isLive);
  }

  static Future<void> showScriptureSlide(String arguments, bool isLive) async {
    if (!isLive) return;

    await methodChannel(methodName: 'showScriptureSlide', arguments: arguments, isLive: isLive);
  }

  static Future<void> setBackground(String filePath, bool isLive) async {
    if (!isLive) return;

    await methodChannel(methodName: 'setBackground', arguments: filePath, isLive: isLive);
  }

  static Future<void> clearBackground(bool isLive) async {
    if (!isLive) return;

    await methodChannel(methodName: 'clearBackground', isLive: isLive);
  }

  static Future<void> close() async {
    await methodChannel(methodName: 'close', isLive: true);
  }

  static void open() {
    DesktopMultiWindow.createWindow(
      'Projection Window',
    );
  }
}
