import 'package:finestra_app/core/app_colors.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cuenta", style: TextStyle(fontSize: 25)),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Placeholder(),
    );
  }
}
