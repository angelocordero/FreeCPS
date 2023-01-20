import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/providers_declaration.dart';

import 'package:freecps/dialogs/media_center.dart';
import 'package:freecps/panels/playlist_panel.dart';
import 'package:freecps/panels/projector_controls.dart';

import 'package:freecps/panels/slides_panel.dart';
import 'package:freecps/panels/verses_list.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

import '../models/scripture_model.dart';
import '../panels/scripture_picker.dart';
import '../core/custom_popup_route.dart';

class MainWindow extends ConsumerWidget {
  const MainWindow({super.key});

  // TODO: change appbar to custom app bar

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('FreeCPS'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                CustomPopupRoute(
                  builder: (context) {
                    return const MediaCenter();
                  },
                ),
              );
            },
            child: const Text('Media'),
          ),
          const VerticalDivider(
            width: 30,
          ),
          const Center(
            child: Text('LIVE'),
          ),
          TapDebouncer(
            cooldown: const Duration(seconds: 3),
            onTap: () async {
              bool live = await ref.watch(liveProvider);

              ref.read(liveProvider.notifier).state = !live;

              if (!live) {
                await DesktopMultiWindow.createWindow('Projector Window');
              } else {
                int windowID = await DesktopMultiWindow.getAllSubWindowIds().then((value) => value.first);

                await DesktopMultiWindow.invokeMethod(windowID, 'close');
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
            percentages: const [0.175, 0.65, 0.175], // optional
            minPercentages: const [0.15, 0.0, 0.15],
            maxPercentages: const [0.2, double.infinity, 0.2],
            children: const [
              PlaylistPanel(),
              SlidesPanel(),
              ProjectorControls(),
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
              ),
              const VerticalDivider(),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Scripture scripture = ref.read(scriptureProvider);

                    ref.read(projectorSlidesProvider.notifier).generateScriptureSlides(scripture: scripture);
                  },
                  child: const Text('Generate'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
