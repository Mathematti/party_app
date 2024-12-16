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

  void _rollDice() {
    setState(() {
      _diceResult = Random().nextInt(6) + 1;
    });
  }

  @override
  void initState() {
    super.initState();
    var hasVibrator = Vibration.hasVibrator();
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () async {
      _rollDice();
      if (await hasVibrator ?? false) {
        Vibration.vibrate(duration: 200);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Dice Game"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_diceResult',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 500),
            ),
          ],
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
