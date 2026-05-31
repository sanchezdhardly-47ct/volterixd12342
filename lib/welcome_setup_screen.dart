import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'select_location_screen.dart';

class WelcomeSetupScreen extends StatelessWidget {
  const WelcomeSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String userEmail = user?.email ?? 'Usuario';
    final String userName = userEmail.split('@').first;

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
              
              // Primera línea - más grande
              Text(
                'VAMOS A\nPONERNOS\nCOMODOS',
                style: GoogleFonts.outfit(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Segunda línea - más pequeña pero legible
              Text(
                'ESCOGE EL\nLUGAR\nDONDE\nTRABAJARE',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Mensaje personalizado
              Text(
                'Hola $userName, estoy listo para ayudarte\na optimizar tu consumo energético.',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                  height: 1.4,
                ),
              ),
              
              const Spacer(),
              
              // Botón EMPEZAR
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectLocationScreen(),
                      ),
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
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}