import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_colors.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  TextEditingController myController = TextEditingController();

  void checkUser() {
    if (myController.text == "Carlo") {
      Navigator.pushNamed(context, "/homepage");
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Usuario Incorrecto'),
          content: const Text('Ingrese un usuario registrado'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.textColor),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStartScreen,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Espaciado superior
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),

          // Título
          Center(
            child: Text(
              "BlueMoney",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Línea de separación
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 50,
              right: 50,
            ),
            child: Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Subtítulo
          Center(
            child: Text(
              "Maneja tus ingresos y gastos",
              style: TextStyle(fontSize: 20),
            ),
          ),

          // Espaciado
          SizedBox(height: 20),

          // Animación
          SizedBox(
            height: 300, // Altura fija para la animación
            child: Lottie.network(
              "https://lottie.host/0299cdda-fba8-43ca-a5fd-0da211dfcd8b/th0GObha2Q.json",
            ),
          ),

          // Espaciado
          SizedBox(height: 20),

          // Texto del campo
          Center(
            child: Text(
              "Ingresa tu usuario",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Campo de texto
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 50,
              left: 30,
              right: 30,
            ),
            child: TextField(
              controller: myController,
              keyboardType: TextInputType.text,
              obscureText: true,
              maxLength: 8,
              decoration: InputDecoration(
                hintText: "Usuario",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.remove_red_eye_rounded),
              ),
            ),
          ),

          // Botón
          Center(
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton.icon(
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  checkUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                label: Text(
                  "Iniciar",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),

          // Espaciado inferior
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        ],
      ),
    );
  }
}
