import 'package:flutter/material.dart';
import 'UserScreen.dart';

void main() {

  runApp(const FlashCardApp());
}

class FlashCardApp extends StatelessWidget {
  const FlashCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserSelectionScreen(),
    );
  }
}
