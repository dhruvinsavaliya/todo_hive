import 'dart:async';

import 'package:flutter/material.dart';


class ReversedTimer extends StatefulWidget {
  final String durationString;
  int? index;
  bool? showControls;
  String? documentKey;

  ReversedTimer(
      {super.key,
      required this.durationString,
      this.index,
      this.showControls = true,this.documentKey});

  @override
  _ReversedTimerState createState() => _ReversedTimerState();
}

class _ReversedTimerState extends State<ReversedTimer> {
  late Duration duration;
  late Timer? timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    duration = parseDurationString(widget.durationString);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (duration.inSeconds > 0) {
            duration = duration - const Duration(seconds: 1);

          } else {
            stopTimer();
          }
        });
      }
    });
    isRunning = true;
  }

  void stopTimer() {
    timer?.cancel();
    isRunning = false;
    if (mounted) {
      setState(() {});
    }
  }

  Duration parseDurationString(String durationString) {
    List<String> parts = durationString.split(":");
    int minutes = int.parse(parts[0]);
    int seconds = int.parse(parts[1]);
     return Duration(minutes: minutes, seconds: seconds);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
        ),
        const SizedBox(width: 10),
        widget.showControls == false
            ? const SizedBox()
            : IconButton(
                onPressed: isRunning ? stopTimer : startTimer,
                icon: Icon(isRunning ? Icons.pause_circle_outline : Icons.play_circle_fill_outlined),
              ),
      ],
    );
  }
}
