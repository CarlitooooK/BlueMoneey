import 'package:finestra_app/core/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuración", style: TextStyle(fontSize: 25)),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Placeholder(),
    );
  }
}
