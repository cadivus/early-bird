import 'package:early_bird/screens/sleep_detection_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Early Bird',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SleepDetectionScreen(),
    );
  }
}
