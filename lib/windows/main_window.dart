import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecps/core/constants.dart';
import 'package:freecps/core/helper_functions.dart';
import 'package:freecps/core/media_center_slide_route.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

import '../core/projection_utils.dart';
import '../core/providers_declaration.dart';
import '../media_center/media_center.dart';
import '../panels/playlist_panel.dart';
import '../panels/projection_controls.dart';
import '../panels/scripture_picker.dart';
import '../panels/scripture_settings.dart';
import '../panels/slides_panel.dart';
import '../panels/verses_list.dart';

class MainWindow extends ConsumerWidget {
  const MainWindow({super.key});

  static final MultiSplitViewController topSplitViewController = MultiSplitViewController(
    areas: [
      Area(
        weight: 0.175,
        minimalWeight: 0.15,
      ),
      Area(
        weight: constantSlidePanelInitialWeight,
        minimalWeight: 0.5,
      ),
      Area(
        weight: 0.175,
        minimalWeight: 0.15,
      ),
    ],
  );

  // TODO: change appbar to custom app bar
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DesktopMultiWindow.setMethodHandler((call, _) async {
      if (call.method == 'close') {
        bool isLive = ref.read(liveProvider);

        await ProjectionUtils.close();

        ref.read(liveProvider.notifier).state = !isLive;
      }
    });

    return ref.watch(initProvider).when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('FreeCPS'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MediaCenterSlideRoute(
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
                  bool isLive = ref.read(liveProvider);

                  if (!isLive) {
                    ProjectionUtils.open();
                  } else {
                    await ProjectionUtils.close();
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
                double scaleFactor = calculateScaleOfSlides(
                  mediaQueryWidth: MediaQuery.sizeOf(context).width,
                  projectionWindowWidth: 1920,
                  slidesPanelWeight: ref.read(slidesPanelWeightProvider),
                );

                ref.read(projectionSlidesProvider.notifier).generateScriptureSlides(
                      scripture: ref.read(scriptureProvider),
                      scaleFactor: scaleFactor,
                    );
              } else if (event is RawKeyDownEvent && event.isKeyPressed(LogicalKeyboardKey.controlLeft) ||
                  event.isKeyPressed(LogicalKeyboardKey.shiftLeft)) {
                ref.read(ctrlKeyNotifier.notifier).state = true;
                return;
              } else {
                ref.read(ctrlKeyNotifier.notifier).state = false;
              }
            },
            child: MultiSplitViewTheme(
              data: MultiSplitViewThemeData(
                dividerPainter: DividerPainters.background(
                  color: Theme.of(context).dividerColor,
                ),
                dividerThickness: 5,
              ),
              child: MultiSplitView(
                axis: Axis.vertical,
                controller: MultiSplitViewController(
                  areas: [
                    Area(
                      weight: 0.6,
                      minimalWeight: 0.5,
                    ),
                    Area(
                      weight: 0.4,
                      minimalWeight: 0.3,
                    ),
                  ],
                ),
                children: [
                  MultiSplitViewTheme(
                    data: MultiSplitViewThemeData(
                      dividerPainter: DividerPainters.background(color: Theme.of(context).dividerColor),
                      dividerThickness: 5,
                    ),
                    child: MultiSplitView(
                      axis: Axis.horizontal,
                      controller: topSplitViewController,
                      children: const [
                        PlaylistPanel(),
                        SlidesPanel(),
                        ProjectionControls(),
                      ],
                      onWeightChange: () {
                        ref.read(slidesPanelWeightProvider.notifier).state = topSplitViewController.getArea(1).weight!;
                        ref.read(projectionToSlidePanelScaleFactorProvider.notifier).state = calculateScaleOfSlides(
                          mediaQueryWidth: MediaQuery.sizeOf(context).width,
                          projectionWindowWidth: 1920,
                          slidesPanelWeight: topSplitViewController.getArea(1).weight!,
                        );
                      },
                    ),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ScripturePickerPanel(),
                      ),
                      VerticalDivider(),
                      Expanded(
                        flex: 4,
                        child: VersesList(),
                      ),
                      VerticalDivider(),
                      Expanded(
                        flex: 1,
                        child: ScriptureSettings(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (e, s) {
        return Center(child: Text(e.toString()));
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
