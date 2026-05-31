import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              
              // Texto principal
              RichText(
                text: TextSpan(
                  style: GoogleFonts.outfit(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                  children: const [
                    TextSpan(text: 'AHORRA Y\n'),
                    TextSpan(text: 'CONTROLA TU\n'),
                    TextSpan(text: 'ENERGIA CON\n'),
                    TextSpan(
                      text: 'VOLTER',
                      style: TextStyle(color: Color(0xFF7CDF1E)),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 100),
              
              // Texto de bienvenida
              Text(
                'Bienvenido, empecemos\ncon lo básico....',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFF9CA3AF),
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Botón EMPEZAR
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CDF1E),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'EMPEZAR',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}