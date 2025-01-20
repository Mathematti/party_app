import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shake_plus/shake_plus.dart';
import 'package:vibration/vibration.dart';

class DiceGame extends StatefulWidget {
  const DiceGame({super.key});

  @override
  State<DiceGame> createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGame> {
  int _diceResult = Random().nextInt(6) + 1;

  var hasVibrator = Vibration.hasVibrator();

  void _rollDice() async {
    setState(() {
      _diceResult = Random().nextInt(6) + 1;
    });
    if (await hasVibrator ?? false) {
      Vibration.vibrate(duration: 200);
    }
  }

  ShakeDetector? shakeDetector;

  @override
  void initState() {
    super.initState();
    shakeDetector = ShakeDetector.autoStart(onPhoneShake: _rollDice);
  }

  @override
  void dispose() {
    shakeDetector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Dice Game"),
      ),
      body: Center(
        child: FittedBox(
          child: Text(
            '$_diceResult',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 500),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _rollDice,
        tooltip: 'Increment',
        child: const Icon(Icons.casino),
      ),
    );
  }
}
