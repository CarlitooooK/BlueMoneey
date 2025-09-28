import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  bool obscureText = true;
  TextEditingController myController = TextEditingController();
  AnimationController? _fadeController;
  AnimationController? _slideController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController!, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController!, curve: Curves.easeOutBack),
        );

    _fadeController!.forward();
    _slideController!.forward();
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    _slideController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundStartScreen,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.10),

              // Header con animación
              FadeTransition(
                opacity: _fadeAnimation ?? AlwaysStoppedAnimation(1.0),
                child: SlideTransition(
                  position:
                      _slideAnimation ?? AlwaysStoppedAnimation(Offset.zero),
                  child: Column(
                    children: [
                      // Logo/Icono decorativo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.buttonColor,
                              AppColors.buttonColor.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.buttonColor.withAlpha(100),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Título principal
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.black, Colors.black.withOpacity(0.8)],
                        ).createShader(bounds),
                        child: const Text(
                          "BlueMoney",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtítulo con estilo
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(30),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.black.withAlpha(10),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          "Maneja tus ingresos y gastos",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Animación mejorada con marco
              FadeTransition(
                opacity: _fadeAnimation ?? AlwaysStoppedAnimation(1.0),
                child: Image.asset(
                  'assets/gifs/bluey1.gif',
                  height: 250,
                  fit: BoxFit.fitHeight,
                ),
              ),

              const SizedBox(height: 70),

              // Sección de entrada mejorada
              SlideTransition(
                position:
                    _slideAnimation ?? AlwaysStoppedAnimation(Offset.zero),
                child: Column(
                  children: [
                    // Título del campo con icono
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rocket_launch_rounded,
                          color: AppColors.buttonColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Empieza ahora",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Botón moderno con gradiente
                    Container(
                      width: 280,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.buttonColor,
                            AppColors.buttonColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.buttonColor.withAlpha(200),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/homepage');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        label: const Text(
                          "Iniciar",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            ],
          ),
        ),
      ),
    );
  }
}
