import 'package:flutter/material.dart';
import 'package:flutter_assignment_1/home_screen.dart';

void main() {
  //Api Key for Google Map
  //AIzaSyC-Uu7Kic0MsR77V1SB_SHhfzHLxCmEZ24
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
