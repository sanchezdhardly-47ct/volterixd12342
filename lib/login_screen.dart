import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'welcome_setup_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Verificar si el usuario ya tiene mapeo guardado (para saber a dónde ir)
  Future<bool> _hasCompletedSetup() async {
    // Por ahora retorna false, después verificaremos en Firestore
    // Si el usuario ya configuró su hogar, ir directo al Dashboard
    return false;
  }

  Future<void> _handleSubmit() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      _mostrarError('Por favor, llena todos los campos');
      return;
    }
    if (!_isLogin && _nombreController.text.trim().isEmpty) {
      _mostrarError('Por favor, ingresa tu nombre');
      return;
    }
    if (!_emailController.text.contains('@') || !_emailController.text.contains('.')) {
      _mostrarError('Ingresa un correo electrónico válido');
      return;
    }
    if (_passwordController.text.length < 6) {
      _mostrarError('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    setState(() => _isLoading = true);
    Map<String, dynamic> resultado;
    if (_isLogin) {
      resultado = await _auth.login(_emailController.text.trim(), _passwordController.text.trim());
    } else {
      resultado = await _auth.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nombreController.text.trim(),
      );
    }
    setState(() => _isLoading = false);

    if (resultado['success']) {
      if (!mounted) return;
      
      // Verificar si el usuario ya configuró su hogar
      final hasSetup = await _hasCompletedSetup();
      if (hasSetup) {
        // Si ya configuró, va directo al Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        // Si no, va al flujo de configuración
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeSetupScreen()),
        );
      }
    } else {
      _mostrarError(resultado['error']);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: GoogleFonts.outfit(fontSize: 14)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Navigator.canPop(context))
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Color(0xFF1A1A1A), shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                  ),
                )
              else
                const SizedBox(height: 38),
              const SizedBox(height: 48),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF7CDF1E), Color(0xFF5BAE14)]),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flash_on, size: 32, color: Colors.black87),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      _isLogin ? 'Acceder a VOLTER' : 'Crear cuenta en VOLTER',
                      style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isLogin ? 'Ingresa tus credenciales' : 'Regístrate para comenzar',
                      style: GoogleFonts.outfit(fontSize: 16, color: const Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 56),
              if (!_isLogin) ...[
                Text('Nombre completo', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFFE5E7EB))),
                const SizedBox(height: 8),
                TextField(
                  controller: _nombreController,
                  style: GoogleFonts.outfit(fontSize: 16, color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Ej: Juan Pérez',
                    hintStyle: TextStyle(color: Color(0xFF6B7280)),
                    filled: true,
                    fillColor: Color(0xFF1A1A1A),
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(12))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Text('Correo electrónico', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFFE5E7EB))),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.outfit(fontSize: 16, color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'usuario@ejemplo.com',
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  filled: true,
                  fillColor: Color(0xFF1A1A1A),
                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(12))),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 24),
              Text('Contraseña', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFFE5E7EB))),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: GoogleFonts.outfit(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  hintText: '•••••••• (mínimo 6 caracteres)',
                  hintStyle: GoogleFonts.outfit(fontSize: 15, color: const Color(0xFF6B7280)),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 22),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: const OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(12))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CDF1E),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black87))
                      : Text(_isLogin ? 'INICIAR SESIÓN' : 'REGISTRARSE', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_isLogin ? '¿No tienes cuenta?' : '¿Ya tienes cuenta?', style: GoogleFonts.outfit(fontSize: 15, color: const Color(0xFF9CA3AF))),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        _emailController.clear();
                        _passwordController.clear();
                        _nombreController.clear();
                      });
                    },
                    child: Text(_isLogin ? 'Regístrate' : 'Inicia sesión', style: GoogleFonts.outfit(fontSize: 15, color: const Color(0xFF7CDF1E), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Demo: Puedes registrarte con cualquier correo real\nLa contraseña debe tener mínimo 6 caracteres',
                        style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF9CA3AF)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}