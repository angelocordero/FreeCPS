import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/projection_utils.dart';
import 'package:freecps/core/providers_declaration.dart';

import 'package:freecps/dialogs/media_center.dart';
import 'package:freecps/panels/playlist_panel.dart';
import 'package:freecps/panels/projection_controls.dart';

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
              bool isLive = ref.watch(liveProvider);

              if (!isLive) {
                ProjectionUtils.open();
              } else {
                ProjectionUtils.close();
              }

              ref.read(liveProvider.notifier).state = !isLive;
            },
            builder: (context, onTap) {
              return Switch(
                focusNode: FocusNode(canRequestFocus: false),
                value: ref.watch(liveProvider),
                onChanged: (value) {
                  if (onTap == null) return;
                  onTap();
                },
              );
            },
          ),
        ],
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyDownEvent && event.isKeyPressed(LogicalKeyboardKey.enter) || event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
            ref.read(projectionSlidesProvider.notifier).generateScriptureSlides(scripture: ref.read(scriptureProvider));
          } else if (event is RawKeyDownEvent && event.isKeyPressed(LogicalKeyboardKey.controlLeft) ||
              event.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
            ref.read(verseListCtrlKeyNotifier.notifier).state = true;
            return;
          } else {
            ref.read(verseListCtrlKeyNotifier.notifier).state = false;
          }
        },
        child: ResizableWidget(
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
                ProjectionControls(),
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

                      ref.read(projectionSlidesProvider.notifier).generateScriptureSlides(scripture: scripture);
                    },
                    child: const Text('Generate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
