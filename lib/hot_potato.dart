import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class HotPotato extends StatefulWidget {
  const HotPotato({super.key});

  @override
  State<HotPotato> createState() => _HotPotatoState();
}

class _HotPotatoState extends State<HotPotato> {
  // Word Beginnings
  final List<String> wordBeginnings = [
    'Sta',
    'Pro',
    'Ent',
    'Ver',
    'Un',
    'Re',
    'Ex',
    'An',
    'Out',
    'In',
  ];

  // Word Endings
  final List<String> wordEndings = [
    'ing',
    'ness',
    'ful',
    'able',
    'est',
    'ed',
    'er',
    'ly',
    'ion',
    'ism',
  ];

  // Word Middle Parts
  final List<String> wordMiddleParts = [
    'ight',
    'and',
    'ear',
    'ove',
    'ant',
    'art',
    'orn',
    'end',
    'ing',
    'est',
  ];

  // Themes
  final List<String> themes = [
    'Animals',
    'Fruits',
    'Vegetables',
    'Jobs',
    'Colors',
    'Countries',
    'Cities',
    'Sports',
    'Furniture',
    'Clothing',
  ];

  // Animal Themes
  final List<String> animalThemes = [
    'Animals with wings',
    'Animals in water',
    'Fast animals',
    'Striped animals',
    'Pets',
  ];

  // Food Themes
  final List<String> foodThemes = [
    'Fruits',
    'Vegetables',
    'Desserts',
    'Drinks',
    'Spicy dishes',
  ];

  // Places
  final List<String> placeThemes = [
    'Countries in Europe',
    'Cities starting with "B"',
    'Places with beaches',
    'Places with snow',
    'Famous landmarks',
  ];

  // Challenges
  final List<String> challenges = [
    'Words with exactly 5 letters',
    'Words with 3 vowels',
    'Palindromes (e.g., level, radar)',
    'Compound words (e.g., sunflower, toothbrush)',
    'Words with silent letters (e.g., knife, autumn)',
  ];

  var isSetOff = false;
  var hasVibrator = Vibration.hasVibrator();
  String randomPrompt = '';
  Timer? timer;

  void _restart() {
    setState(() {
      isSetOff = false;
      randomPrompt = getRandomPrompt();
    });
    timer = Timer(Duration(seconds: Random().nextInt(20) + 3), () async {
      setState(() {
        isSetOff = true;
      });
      if (await hasVibrator ?? false) {
        Vibration.vibrate(duration: 1000);
      }
    });
  }

  String getRandomPrompt() {
    final allPrompts = [
      ...wordBeginnings.map((e) => 'Words starting with "$e"'),
      ...wordEndings.map((e) => 'Words ending with "$e"'),
      ...wordMiddleParts.map((e) => 'Words with "$e" in the middle'),
      ...themes,
      ...animalThemes,
      ...foodThemes,
      ...placeThemes,
      ...challenges,
    ];
    return allPrompts[Random().nextInt(allPrompts.length)];
  }

  @override
  void initState() {
    super.initState();
    _restart();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
      floatingActionButton: isSetOff
          ? FloatingActionButton(
              onPressed: _restart,
              tooltip: 'Restart',
              child: const Icon(Icons.restart_alt_outlined),
            )
          : null,
      body: Center(
        child: isSetOff ? const Text("BOOM!", style: TextStyle(fontSize: 42),) : Text(
          randomPrompt,
          style: const TextStyle(
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
