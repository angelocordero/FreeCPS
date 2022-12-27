import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import '../core/constants.dart' as constants;

class PlaylistPanel extends StatelessWidget {
  const PlaylistPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () async {
              try {
                int windowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);

                await DesktopMultiWindow.invokeMethod(windowID, 'setBackground', constants.motionBackgroundFilePath);
              } catch (e) {
//
              }
            },
            child: Image.asset(constants.motionBackgroundThumbnailPath),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () async {
              try {
                int windowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);

                await DesktopMultiWindow.invokeMethod(
                    windowID, 'setBackground', constants.stillBackgroundFilePath);
              } catch (e) {
//
              }
            },
            child: Image.asset(constants.stillBackgroundFilePath),
          ),
        ),
      ],
    );
  }
}
