import 'package:flutter/material.dart';
import 'package:party_app/drawing_game.dart';

class DrawingGameOptions extends StatefulWidget {
  const DrawingGameOptions({super.key});

  @override
  State<DrawingGameOptions> createState() => _DrawingGameOptionsState();
}

class _DrawingGameOptionsState extends State<DrawingGameOptions> {
  final List<String> easyThingsToDraw = [
    'Sun',
    'Tree',
    'House',
    'Cat',
    'Heart',
    'Rainbow',
    'Fish',
    'Smiley face',
    'Balloon',
    'Apple',
    'Star',
    'Cup',
    'Book',
    'Cloud',
    'Moon',
    'Hat',
    'Shoe',
    'Flower',
    'Carrot',
    'Leaf',
    'Bread',
    'Clock',
    'Ice cream cone',
    'Chair',
    'Lollipop',
  ];

  final List<String> mediumThingsToDraw = [
    'Airplane',
    'Glasses',
    'Dog',
    'Mountain',
    'Car',
    'Umbrella',
    'Boat',
    'Cactus',
    'Backpack',
    'Guitar',
    'Bicycle',
    'Basketball',
    'Lamp',
    'Rocket',
    'Penguin',
    'Tiger',
    'Camera',
    'Key',
    'Ladder',
    'Sandwich',
    'Pineapple',
    'Watermelon',
    'Donut',
    'Whale',
    'Parrot',
    'Snowman',
    'Castle',
    'Bridge',
  ];

  final List<String> hardThingsToDraw = [
    'Eiffel Tower',
    'Dinosaur',
    'Piano',
    'Octopus',
    'Lighthouse',
    'Helicopter',
    'Kangaroo',
    'Statue of Liberty',
    'Space Station',
    'Dragonfly',
    'Microscope',
    'Snowmobile',
    'Phoenix',
    'Magic Wand',
    'Alien',
    'Pirate Ship',
    'Anchor',
    'Volcano',
    'Treasure Chest',
    'Ballet Shoes',
    'Telescope',
    'Robot',
    'Chessboard',
    'Unicorn',
    'Mermaid',
    'Wizard',
  ];

  String selectedDifficulty = 'Easy';
  String selectedWord = '';
  int time = 45;

  void randomizeWord() {
    List<String> words;
    switch (selectedDifficulty) {
      case 'Medium':
        words = mediumThingsToDraw;
        break;
      case 'Hard':
        words = hardThingsToDraw;
        break;
      case 'Easy':
      default:
        words = easyThingsToDraw;
        break;
    }
    setState(() {
      selectedWord = (words..shuffle()).first;
    });
  }

  @override
  void initState() {
    super.initState();
    randomizeWord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Drawing game"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Difficulty: ',
                  style: TextStyle(fontSize: 18),
                ),
                DropdownButton<String>(
                  value: selectedDifficulty,
                  items: ['Easy', 'Medium', 'Hard'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDifficulty = newValue!;
                      randomizeWord();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Text(
                'Time: ',
                style: TextStyle(fontSize: 18),
              ),
              Slider(
                value: time.toDouble(),
                min: 30,
                max: 120,
                divisions: 3,
                label: '$time seconds',
                onChanged: (double newValue) {
                setState(() {
                  time = newValue.toInt();
                });
                },
              ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Draw: ',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              selectedWord,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: randomizeWord,
              child: const Text('Re-randomize'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DrawingGame(time: time)),
                );
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
