import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';

class ProjectorControls extends ConsumerWidget {
  const ProjectorControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              int windowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);
              await DesktopMultiWindow.invokeMethod(windowID, 'clearSlide', '');
              ref.read(slideIndexProvider.notifier).clearSlide();
            },
            child: const Text('Clear Slide'),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () async {
              int windowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);
              await DesktopMultiWindow.invokeMethod(windowID, 'clearBackground', '');
            },
            child: const Text('Clear Background'),
          ),
        ],
      ),
    );
  }
}
