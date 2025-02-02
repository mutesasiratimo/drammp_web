import 'dart:async';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SessionTimeoutListener extends StatefulWidget {
  Widget child;
  Duration duration;
  VoidCallback onCallBack;
  SessionTimeoutListener(
      {super.key,
      required this.child,
      required this.duration,
      required this.onCallBack});

  @override
  State<SessionTimeoutListener> createState() => _SessionTimeoutListenerState();
}

class _SessionTimeoutListenerState extends State<SessionTimeoutListener> {
  Timer? _timer;

  _startTimer() {
    debugPrint("Timer reset");
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    _timer = Timer(widget.duration, () {
      debugPrint("Timer elapsed");
      widget.onCallBack();
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      //onPointerHover - consider changing to this
      onPointerDown: (event) {
        _startTimer();
      },
      child: widget.child,
    );
  }
}
