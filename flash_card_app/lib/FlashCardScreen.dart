import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';

import 'EndScreen.dart';

Color color1 = const Color.fromARGB(255, 235, 148, 33);
Color color2 = const Color.fromARGB(255, 246, 187, 109);
Color color3 = const Color.fromARGB(255, 240, 217, 186);

class FlashCardScreen extends StatefulWidget {
  final String response;
  final String language;
  final String difficulty;

  const FlashCardScreen({Key? key, required this.response, required this.language, required this.difficulty})
      : super(key: key);

  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  bool _showFrontSide = true;
  List<List<String>> flashCardData = [];
  int currentIndex = 0;
  List<String> trueWords = [];
  List<String> falseWords = [];
  int trueCount = 0;
  int falseCount = 0;

  @override
  void initState() {
    super.initState();
    parseResponse();
  }

  void parseResponse() {
    int startIndex = widget.response.indexOf('[');
    int endIndex = widget.response.lastIndexOf(']');

    String jsonDataString = widget.response.substring(startIndex, endIndex + 1);
    List<dynamic> jsonData = json.decode(jsonDataString);
    flashCardData = [];

    for (var item in jsonData) {
      if (item['word'] != null && item['definition'] != null) {
        String word = item['word'] as String;
        String definition = item['definition'] as String;
        flashCardData.add([word, definition]);
      }
    }
  }

  void moveToTrueWords() {
    if (flashCardData.isNotEmpty) {
      setState(() {
        trueWords.add(flashCardData[currentIndex][0]);
        flashCardData.removeAt(currentIndex);
        trueCount = trueWords.length;
        if (currentIndex >= flashCardData.length && currentIndex > 0) {
          currentIndex--;
        }
        checkCompletion();
      });
    }
  }

  void moveToFalseWords() {
    if (flashCardData.isNotEmpty) {
      setState(() {
        falseWords.add(flashCardData[currentIndex][0]);
        flashCardData.removeAt(currentIndex);
        falseCount = falseWords.length;
        if (currentIndex >= flashCardData.length && currentIndex > 0) {
          currentIndex--;
        }
        checkCompletion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flash Card"),
        centerTitle: true,
        backgroundColor: color1,
      ),
      backgroundColor: color3,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Container(
                constraints: BoxConstraints.tight(const Size(300, 500)),
                child: _buildFlipAnimation(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color1,
                      ),
                      onPressed: () {
                        setState(() {
                          if (currentIndex > 0) {
                            currentIndex--;
                          }
                        });
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 96,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color3,
                        side: BorderSide(color: color1, width: 2),
                      ),
                      onPressed: moveToTrueWords,
                      child: Text(
                        "${trueWords.length}",
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 96,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color3,
                        side: BorderSide(color: color1, width: 2),
                      ),
                      onPressed: moveToFalseWords,
                      child: Text(
                        "${falseWords.length}",
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color1,
                      ),
                      onPressed: () {
                        setState(() {
                          if (currentIndex < flashCardData.length - 1) {
                            currentIndex++;
                          }
                        });
                      },
                      child: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Flashcard part

  void _switchCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }

  Key generateUniqueKey() {
    final randomNumber = Random().nextInt(999999);
    final uniqueKey = ValueKey<int>(randomNumber);
    return uniqueKey;
  }

  Widget _buildLayout({Key? key, String? faceName, TextStyle? textStyle, Color? backgroundColor}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                  child: Text(
                faceName!,
                style: textStyle,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              )),
            ),
            Text(
              "${currentIndex + 1}",
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFront(int index) {
    if (flashCardData.isEmpty) {
      return Container();
    }
    return _buildLayout(
      key: const ValueKey(true),
      backgroundColor: color2,
      faceName: flashCardData[index][0],
      textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildRear(int index) {
    if (flashCardData.isEmpty) {
      return Container();
    }
    return _buildLayout(
      key: const ValueKey(false),
      backgroundColor: color2,
      faceName: flashCardData[index][1],
      textStyle: const TextStyle(fontSize: 32, color: Colors.white),
    );
  }

  Widget _buildFlipAnimation() {
    return GestureDetector(
      onTap: _switchCard,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        transitionBuilder: _transitionBuilder,
        child: _showFrontSide ? _buildFront(currentIndex) : _buildRear(currentIndex),
      ),
    );
  }

  Widget _transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }

  void checkCompletion() {
    if (flashCardData.isEmpty) {
      setState(() {
        currentIndex = 0;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: color3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Your statistics are being prepared...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context); // Bekleme ekranını kapat
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EndScreen(
              trueWords: trueWords,
              falseWords: falseWords,
              language: widget.language,
              difficulty: widget.difficulty,
            ),
          ),
        );
      });
    }
  }
}
