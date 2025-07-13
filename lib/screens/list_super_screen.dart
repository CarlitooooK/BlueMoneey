import 'package:flutter/material.dart';

class ListSuperScreen extends StatefulWidget {
  const ListSuperScreen({super.key});

  @override
  State<ListSuperScreen> createState() => _ListSuperScreenState();
}

class _ListSuperScreenState extends State<ListSuperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("LISTA DEL SUPER")));
  }
}
