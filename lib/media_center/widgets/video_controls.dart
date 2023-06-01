import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freecps/core/helper_functions.dart';
import 'package:media_kit/media_kit.dart';

class VideoControls extends StatelessWidget {
  const VideoControls({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _VideoProgressBar(player),
        _VideoButtons(player),
      ],
    );
  }
}

class _VideoProgressBar extends StatefulWidget {
  const _VideoProgressBar(this.player, {Key? key}) : super(key: key);

  final Player player;

  @override
  _VideoProgressBarState createState() {
    return _VideoProgressBarState();
  }
}

class _VideoButtons extends StatefulWidget {
  const _VideoButtons(this.player);

  final Player player;

  @override
  State<_VideoButtons> createState() => _VideoButtonsState();
}

class _VideoButtonsState extends State<_VideoButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.outlined(
          onPressed: () {},
          icon: const Icon(
            Icons.skip_previous,
          ),
        ),
        _CenterButton(
          widget.player,
        ),
        IconButton.outlined(
          onPressed: () {},
          icon: const Icon(
            Icons.skip_next,
          ),
        ),
      ],
    );
  }
}

class _VideoProgressBarState extends State<_VideoProgressBar> {
  Player get player => widget.player;

  bool seeking = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  List<StreamSubscription> subscriptions = [];

  void listener() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    position = player.state.position;
    duration = player.state.duration;
    subscriptions.addAll(
      [
        player.streams.position.listen((event) {
          setState(() {
            if (!seeking) {
              position = event;
              return;
            }
          });
        }),
        player.streams.duration.listen((event) {
          setState(() {
            duration = event;
          });
        }),
      ],
    );
  }

  @override
  void dispose() {
    for (final s in subscriptions) {
      s.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Expanded(
            child: Slider(
              min: 0.0,
              max: duration.inMilliseconds.toDouble(),
              value: position.inMilliseconds.toDouble().clamp(
                    0.0,
                    duration.inMilliseconds.toDouble(),
                  ),
              onChangeStart: (e) {
                seeking = true;
              },
              onChanged: position.inMilliseconds > 0
                  ? (e) {
                      setState(() {
                        position = Duration(milliseconds: e ~/ 1);
                      });
                    }
                  : null,
              onChangeEnd: (e) {
                seeking = false;
                player.seek(Duration(milliseconds: e ~/ 1));
              },
            ),
          ),
          Text(
            '${formatDuration(position)} / ${formatDuration(duration)}',
          ),
        ],
      ),
    );
  }
}

class _CenterButton extends StatefulWidget {
  const _CenterButton(this.player);

  final Player player;

  @override
  State<_CenterButton> createState() => _CenterButtonState();
}

class _CenterButtonState extends State<_CenterButton> {
  Player get player => widget.player;

  bool playing = false;
  bool completed = false;

  List<StreamSubscription> subscriptions = [];

  void listener() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    playing = player.state.playing;
    subscriptions.addAll(
      [
        player.streams.playing.listen((event) {
          setState(() {
            playing = event;
          });
        }),
        player.streams.completed.listen((event) {
          setState(() {
            completed = event;
          });
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      icon: completed
          ? const Icon(Icons.replay)
          : playing
              ? const Icon(Icons.pause)
              : const Icon(Icons.play_arrow),
      onPressed: () {
        player.playOrPause();
      },
    );
  }

  @override
  void dispose() {
    for (final s in subscriptions) {
      s.cancel();
    }

    super.dispose();
  }
}
