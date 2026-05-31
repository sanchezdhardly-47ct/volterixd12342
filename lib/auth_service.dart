import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> register(String email, String password, String nombre) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email.trim(),
        'nombre': nombre.trim(),
        'fechaRegistro': DateTime.now().toIso8601String(),
        'plan': 'gratuito',
        'setupCompletado': false, // ← NUEVO: saber si ya configuró su hogar
      });
      return {'success': true, 'user': userCredential.user, 'error': null};
    } on FirebaseAuthException catch (e) {
      String mensaje = '';
      if (e.code == 'weak-password') mensaje = 'La contraseña es muy débil';
      else if (e.code == 'email-already-in-use') mensaje = 'Este correo ya está registrado';
      else if (e.code == 'invalid-email') mensaje = 'Correo electrónico inválido';
      else mensaje = e.message ?? 'Error al registrar';
      return {'success': false, 'user': null, 'error': mensaje};
    } catch (e) {
      return {'success': false, 'user': null, 'error': 'Error de conexión'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return {'success': true, 'user': userCredential.user, 'error': null};
    } on FirebaseAuthException catch (e) {
      String mensaje = '';
      if (e.code == 'user-not-found') mensaje = 'Usuario no encontrado';
      else if (e.code == 'wrong-password') mensaje = 'Contraseña incorrecta';
      else if (e.code == 'invalid-email') mensaje = 'Correo electrónico inválido';
      else mensaje = e.message ?? 'Error al iniciar sesión';
      return {'success': false, 'user': null, 'error': mensaje};
    } catch (e) {
      return {'success': false, 'user': null, 'error': 'Error de conexión'};
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // Verificar si el usuario ya completó el setup
  Future<bool> hasCompletedSetup(String uid) async {
    try {
      final doc = await _firestore.collection('usuarios').doc(uid).get();
      return doc.data()?['setupCompletado'] ?? false;
    } catch (e) {
      return false;
    }
  }

  // Marcar setup como completado
  Future<void> markSetupAsCompleted(String uid) async {
    await _firestore.collection('usuarios').doc(uid).update({
      'setupCompletado': true,
    });
  }

  User? getCurrentUser() => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}