import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/core_providers.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class MainWindow extends ConsumerWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FreeCPS'),
          actions: [
            TapDebouncer(
              cooldown: const Duration(seconds: 1),
              onTap: () async {
                bool live = await ref.watch(liveProvider);

                ref.watch(liveProvider.notifier).state = !live;

                if (!live) {
                  await DesktopMultiWindow.createWindow('Projector Window');
                } else {
                  await DesktopMultiWindow.getAllSubWindowIds().then(
                    (value) async {
                      if (value.isNotEmpty) {
                        await DesktopMultiWindow.invokeMethod(value.first, 'close', '');
                      }
                      return;
                    },
                  );
                }
              },
              builder: (context, onTap) {
                return Switch(
                  value: ref.watch(liveProvider),
                  onChanged: (value) async {
                    if (onTap != null) {
                      onTap();
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.green,
        ),
      ),
    );
  }

  Future<void> toggleLive(bool to) async {}
}
