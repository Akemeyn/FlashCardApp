import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'flashCardScreen.dart';

Color color1 = const Color.fromARGB(255, 235, 148, 33);
Color color2 = const Color.fromARGB(255, 246, 187, 109);
Color color3 = const Color.fromARGB(255, 240, 217, 186);

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({Key? key}) : super(key: key);

  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  String? _selectedLanguage;
  String? _selectedDifficulty;

  final List<String> _languages = ['English', 'Chinese', 'Turkish', 'Spanish', 'German', 'Arabic'];
  final List<String> _difficulties = [
    'A1 - Beginner',
    'A2 - Elementary',
    'B1 - Intermediate',
    'B2 - Upper Intermediate',
    'C1 - Advanced',
    'C2 - Proficient'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      appBar: AppBar(
        title: const Text('Select Language and Difficulty'),
        centerTitle: true,
        backgroundColor: color1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            const Text(
              'Select Language',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color1, width: 2),
              ),
              child: DropdownButton<String>(
                dropdownColor: color2,
                iconEnabledColor: color1,
                isExpanded: true,
                value: _selectedLanguage,
                hint: const Text('Select Language'),
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(
                      language,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                },
                underline: Container(),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Select Difficulty:',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Container(
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color1, width: 2),
              ),
              child: DropdownButton<String>(
                iconEnabledColor: color1,
                dropdownColor: color2,
                isExpanded: true,
                value: _selectedDifficulty,
                hint: const Text('Select Difficulty'),
                items: _difficulties.map((String difficulty) {
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: Text(
                      difficulty,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDifficulty = newValue;
                  });
                },
                underline: Container(),
              ),
            ),
            const SizedBox(height: 96),
            SizedBox(
              width: 240,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color1,
                ),
                onPressed: () async {
                  if (_selectedDifficulty != null && _selectedLanguage != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoadingScreen(
                          language: _selectedLanguage!,
                          difficulty: _selectedDifficulty!,
                          falseWords: const [],
                          trueWords: const [],
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a language and difficulty level')),
                    );
                  }
                },
                child: const Text(
                  'Start Flash Cards',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  final String language;
  final String difficulty;
  final List<String> trueWords;
  final List<String> falseWords;

  const LoadingScreen({super.key, 
    required this.language,
    required this.difficulty,
    required this.trueWords,
    required this.falseWords,
  });

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<String?> generateResponse() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: 'AIzaSyDS6VD-XxOcW7lbRierL_5CRF5rYMTT5ic');
    final knownWords = widget.trueWords.join(', ');
    final unknownWords = widget.falseWords.join(', ');

    final prompt =
        "Generate 30 ${widget.language} words with their definitions like learning language flash cards with ${widget.difficulty} difficulty. Exclude these words: $knownWords. Include these words: $unknownWords. Try to ensure that each word starts with a different letter. Write json format. [{word: '', definition: ''}]";

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    return response.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color3,
      body: FutureBuilder<String?>(
        future: generateResponse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 96),
                  CircularProgressIndicator(
                    color: color1,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Your language set is being created.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'It will take approximately 10-15 seconds.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color1),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return FlashCardScreen(response: snapshot.data!, difficulty: widget.difficulty, language: widget.language);
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
