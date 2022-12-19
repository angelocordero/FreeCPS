import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';
import 'package:freecps/panels/slides_panel.dart';
import 'package:freecps/panels/verses_list.dart';
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
          percentages: const [0.65, 0.35], // optional
          minPercentages: const [0.6, 0.0],
          maxPercentages: const [0.7, double.infinity],
          children: [
            ResizableWidget(
              isDisabledSmartHide: true,
              percentages: const [0.175, 1 - 0.175 - 0.175, 0.175], // optional
              minPercentages: const [0.15, 0.0, 0.15],
              maxPercentages: const [0.2, double.infinity, 0.2],
              children: [
                Container(),
                const SlidesPanel(),
                Container(),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: ScripturePickerPanel(),
                ),
                const VerticalDivider(),
                const Expanded(
                  flex: 4,
                  child: VersesList(),
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
