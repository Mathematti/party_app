import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:vibration/vibration.dart';

class DrawingGame extends StatefulWidget {
  final int time;
  const DrawingGame({super.key, required this.time});

  @override
  State<DrawingGame> createState() => _DrawingGameState();
}

class _DrawingGameState extends State<DrawingGame> {
  final hasVibrator = Vibration.hasVibrator();

  void _restart() async {
    _controller.clear();
    if (await hasVibrator ?? false) {
      Vibration.vibrate(duration: 200);
    }
  }

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.white,
  );

  late final StopWatchTimer stopWatchTimer;

  @override
  void initState() {
    super.initState();
    stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond:
          StopWatchTimer.getMilliSecFromSecond(widget.time),
    );
    stopWatchTimer.onStartTimer();
    stopWatchTimer.fetchEnded.listen((value) {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Drawing game"),
      ),
      body: Column(
        children: [
          StreamBuilder<int>(
            stream: stopWatchTimer.rawTime,
            initialData: stopWatchTimer.rawTime.value,
            builder: (context, snap) {
              final value = snap.data!;
              final displayTime = StopWatchTimer.getDisplayTime(value,
                  hours: false, minute: false);
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  displayTime,
                  style: const TextStyle(
                    fontSize: 40,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Signature(
              controller: _controller,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: _restart,
        tooltip: 'Clear canvas',
        child: const Icon(Icons.restart_alt_outlined),
      ),
    );
  }
}
