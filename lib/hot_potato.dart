import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shake_plus/shake_plus.dart';
import 'package:vibration/vibration.dart';

class HotPotato extends StatefulWidget {
  const HotPotato({super.key});

  @override
  State<HotPotato> createState() => _HotPotatoState();
}

class _HotPotatoState extends State<HotPotato> {
  var isSetOff = false;
  var hasVibrator = Vibration.hasVibrator();

  void _restart() {
    setState(() {
      isSetOff = false;
    });
    Timer(const Duration(seconds: 3), () {
      setState(() {
        isSetOff = true;
      });
    });
  }

  void _handleShake() async {
    // setState(() {
    //   s = Random().nextInt(6) + 1;
    // });
    // if (await hasVibrator ?? false) {
    //   Vibration.vibrate(duration: 200);
    // }
  }

  @override
  void initState() {
    super.initState();
    _restart();
    ShakeDetector.autoStart(onPhoneShake: _handleShake);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isSetOff
            ? Colors.red[500]
            : Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Hot Potato"),
      ),
      backgroundColor: isSetOff
          ? Colors.red[500]
          : Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: _restart,
        tooltip: 'Increment',
        child: const Icon(Icons.restart_alt_outlined),
      ),
    );
  }
}
