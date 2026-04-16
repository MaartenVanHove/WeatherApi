import 'package:flutter/material.dart';
import 'package:weather_api/features/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CommuteScreen(), theme: ThemeData());
  }
}
