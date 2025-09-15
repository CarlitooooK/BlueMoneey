import 'package:finestra_app/features/home_screen.dart';
import 'package:finestra_app/screens/register_screen.dart';
import 'package:finestra_app/screens/start_screen.dart';
import 'package:finestra_app/features/navigation/account_screen.dart';
import 'package:finestra_app/features/navigation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qyelvkeiumcuiovckurk.supabase.co', // Reemplaza con tu URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF5ZWx2a2VpdW1jdWlvdmNrdXJrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NTY1NDUxNiwiZXhwIjoyMDcxMjMwNTE2fQ.6ZT_HYOdkXZVgyXpVqrp2oZALS8vmZFFhLWfbSTbxVI', // Reemplaza con tu clave anónima
  );
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
        '/registerpage': (context) => RegisterScreen(),
      },
    );
  }
}
