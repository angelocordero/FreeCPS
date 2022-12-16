import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

import '../panels/scripture_picker.dart';

class MainWindow extends ConsumerWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO : put this in a loading widget
    //ref.read(availableBiblesProvider);

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
        body: ResizableWidget(
          isHorizontalSeparator: true,
          isDisabledSmartHide: true,
          percentages: const [0.7, 0.3], // optional
          minPercentages: const [0.0, 0.25],
          maxPercentages: const [double.infinity, 0.4],
          children: [
            Container(),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: ScripturePickerPanel(),
                ),
                const VerticalDivider(),
                Expanded(
                  flex: 4,
                  child: Container(),
                  //child: ScripturePanel(),
                ),
                const VerticalDivider(),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> toggleLive(bool to) async {}
}
