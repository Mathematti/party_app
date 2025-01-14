import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:shake_plus/shake_plus.dart';
// import 'package:vibration/vibration.dart';

import 'package:sensors_plus/sensors_plus.dart';

import 'package:flutter_svg/flutter_svg.dart';

class TurnGame extends StatefulWidget {
  const TurnGame({super.key});

  @override
  State<TurnGame> createState() => _TurnGameState();
}

class _TurnGameState extends State<TurnGame>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  // int _diceResult = Random().nextInt(6) + 1;

  // var hasVibrator = Vibration.hasVibrator();

  // void _rollDice() async {
  //   setState(() {
  //     _diceResult = Random().nextInt(6) + 1;
  //   });
  //   if (await hasVibrator ?? false) {
  //     Vibration.vibrate(duration: 200);
  //   }
  // }

  GyroscopeEvent? lastEvent;
  // bool currentlyTur

  late StreamSubscription<GyroscopeEvent> streamSubscription;

  bool isSpinning = false;

  void doSpin({bool turnLeft = false}) async {
    if (isSpinning == true) return;
    setState(() {
      isSpinning = true;
    });

    int baseSpinDuration = 300;
    double target = Random().nextDouble();
    int totalSpin = 4;
    int spinCount = 0;

    do {
      if (turnLeft) {
        _animationController.value = _animationController.upperBound;
      } else {
        _animationController.reset();
      }

      _animationController.duration = Duration(milliseconds: baseSpinDuration);

      if (spinCount == totalSpin) {
        await _animationController.animateTo(target,
            duration: Duration(
                milliseconds:
                    (baseSpinDuration * (turnLeft ? 1 - target : target) + 50)
                        .toInt()),
            curve: Curves.easeOut);
      } else {
        if (turnLeft) {
          await _animationController.animateBack(0);
        } else {
          await _animationController.forward();
        }
      }
      baseSpinDuration = baseSpinDuration + 200;
      _animationController.duration = Duration(milliseconds: baseSpinDuration);
      spinCount++;
    } while (spinCount <= totalSpin);

    setState(() {
      isSpinning = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      value: 2 * pi,
      vsync: this,
    );

    streamSubscription = gyroscopeEventStream().listen(
      (GyroscopeEvent event) {
        var localLastEvent = lastEvent;
        if (localLastEvent != null) {
          var delta = event.z - localLastEvent.z;
          if (delta.abs() > 1.5) {
            doSpin(turnLeft: delta > 0);
          }
        }
        setState(() {
          lastEvent = event;
        });
      },
      onError: (error) {
        print('ERROR $error');
        // Logic to handle error
        // Needed for Android in case sensor is not available
      },
      cancelOnError: true,
    );
    // ShakeDetector.autoStart(onPhoneShake: _rollDice);
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Turning Game"),
      ),
      // body: AnimatedRotation(turns: 10, duration: Duration(seconds: 3), child: Text('asdf'))
      body: Center(
        child: RotationTransition(
          alignment: Alignment.center,
          turns: _animationController,
          child: SizedBox(
            child: SvgPicture.asset(
              'assets/bottle-filled.svg',
              height: 300,
              width: 300,
            ),
          ),
        ),
      ),
    );
  }
}
