import 'package:finestra_app/features/home_screen.dart';
import 'package:finestra_app/screens/start_screen.dart';
import 'package:finestra_app/features/navigation/account_screen.dart';
import 'package:finestra_app/features/navigation/settings_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StartScreen(),
      routes: {
        '/homepage': (contex) => HomeScreen(),
        '/accountpage': (context) => AccountScreen(),
        '/settingspage': (context) => SettingsScreen(),
        '/startpage': (context) => StartScreen(),
      },
    );
  }
}
