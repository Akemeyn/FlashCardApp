import 'package:flutter/material.dart';

import 'UserScreen.dart';

Color color1 = const Color.fromARGB(255, 235, 148, 33);
Color color2 = const Color.fromARGB(255, 246, 187, 109);
Color color3 = const Color.fromARGB(255, 240, 217, 186);

class EndScreen extends StatelessWidget {
  final List<String> trueWords;
  final List<String> falseWords;
  final String language;
  final String difficulty;

  const EndScreen({
    Key? key,
    required this.trueWords,
    required this.falseWords,
    required this.language,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        centerTitle: true,
        backgroundColor: color1,
      ),
      backgroundColor: color3,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Congratulations!\nYou have finished the set.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Correct Words:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  ...trueWords.map((word) => ListTile(
                        title: Text(word),
                        leading: const Icon(Icons.check, color: Colors.green),
                      )),
                  const Divider(
                    thickness: 4,
                  ),
                  const Text(
                    'Incorrect Words:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  ...falseWords.map((word) => ListTile(
                        title: Text(word),
                        leading: const Icon(Icons.close, color: Colors.red),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color1,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoadingScreen(
                      language: language,
                      difficulty: difficulty,
                      trueWords: trueWords,
                      falseWords: falseWords,
                    ),
                  ),
                );
              },
              child: const Text(
                'Go to next set',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color1,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserSelectionScreen(),
                  ),
                );
              },
              child: const Text(
                'Exit',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
