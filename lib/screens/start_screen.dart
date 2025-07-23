import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool obscureText = true;
  TextEditingController myController = TextEditingController();

  void checkUser() {
    if (myController.text == "Carlo") {
      Navigator.pushNamed(context, "/homepage");
    } else {
      showDialog<String>(
        animationStyle: AnimationStyle(duration: Duration(milliseconds: 550)),
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
            child: Image.asset("assets/gifs/bluey1.gif"),
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
          SizedBox(height: 20),

          // Campo de texto
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 50,
              left: 30,
              right: 30,
            ),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 3, 20, 0),
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                obscureText: obscureText,
                controller: myController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.person, color: Colors.black),
                    color: Colors.grey,
                  ),
                  hintText: 'Usuario',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),

          // Botón
          Center(
            child: SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton.icon(
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  checkUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
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
