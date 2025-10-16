
// Custom animated text widget
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class CustomAnimatedText extends StatelessWidget {
  final String text;
  const CustomAnimatedText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.0,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Color(0xff2C2C2C),
          fontSize: 16,
          fontFamily: 'PlusJakartaSans',
          fontWeight: FontWeight.w600,
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(text),
          ],
          repeatForever: true,
          pause: const Duration(milliseconds: 1500),
        ),
      ),
    );
  }
}
