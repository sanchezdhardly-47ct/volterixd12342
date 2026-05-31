import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'welcome_screen.dart';
import 'dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VolterApp());
}

class VolterApp extends StatelessWidget {
  const VolterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VOLTER',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF7CDF1E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7CDF1E),
          secondary: Color(0xFF5BAE14),
          surface: Color(0xFF1A1A1A),
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(), // ← NUEVO: Wrapper de autenticación
    );
  }
}

// NUEVO: Wrapper que decide qué pantalla mostrar según sesión
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const WelcomeScreen();
          }
          return const DashboardScreen();
        }
        // Pantalla de carga mientras verifica sesión
        return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7CDF1E)),
            ),
          ),
        );
      },
    );
  }
}