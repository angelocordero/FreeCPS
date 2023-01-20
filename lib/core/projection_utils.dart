import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:freecps/core/constants.dart';

class ProjectionUtils {
  static void methodChannel({required String methodName, required String arguments}) {
    DesktopMultiWindow.invokeMethod(projectionWindowID, methodName, arguments);
  }

  static void clearSlide() {
    DesktopMultiWindow.invokeMethod(projectionWindowID, 'clearSlide');
  }

  static void showSlide(String text) {
    DesktopMultiWindow.invokeMethod(projectionWindowID, 'showSlide', text);
  }

  static void setBackground(String filePath) {
    DesktopMultiWindow.invokeMethod(projectionWindowID, 'setBackground', filePath);
  }

  static void clearBackground() {
    DesktopMultiWindow.invokeMethod(projectionWindowID, 'clearBackground');
  }

  static void close() {
    DesktopMultiWindow.invokeMethod(projectionWindowID, 'close');
  }


  
}
