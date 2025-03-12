import 'package:flutter/material.dart';
import 'package:flutter_assignment_1/MapScreen.dart';

void main() {
  runApp(const GoogleMapsApp());
}

class GoogleMapsApp extends StatelessWidget {
  const GoogleMapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen()
    );
  }
}
