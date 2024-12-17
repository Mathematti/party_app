import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:vibration/vibration.dart';

class DrawingGame extends StatelessWidget {
  DrawingGame({super.key});

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
    // exportBackgroundColor: ,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Drawing game"),
      ),
      body: Signature(
        controller: _controller,
        // width: 300,
        // height: 300,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
