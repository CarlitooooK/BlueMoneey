import 'package:finestra_app/database/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  // Obtener usuario actual
  User? get currentUser => _client.auth.currentUser;

  // Stream de cambios de autenticación
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Registrar usuario
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String nombre,
    String? apellido,
    String? telefono,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'nombre': nombre,
          'apellido': apellido,
          'telefono': telefono,
        },
      );

      if (response.user != null) {
        return {
          'success': true,
          'user': response.user,
          'message': 'Usuario registrado exitosamente'
        };
      } else {
        return {
          'success': false,
          'message': 'Error al registrar usuario'
        };
      }
    } on AuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e.message)
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: ${e.toString()}'
      };
    }
  }

  // Iniciar sesión
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return {
          'success': true,
          'user': response.user,
          'message': 'Sesión iniciada exitosamente'
        };
      } else {
        return {
          'success': false,
          'message': 'Credenciales inválidas'
        };
      }
    } on AuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e.message)
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: ${e.toString()}'
      };
    }
  }

  // Cerrar sesión
  Future<Map<String, dynamic>> signOut() async {
    try {
      await _client.auth.signOut();
      return {
        'success': true,
        'message': 'Sesión cerrada exitosamente'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al cerrar sesión: ${e.toString()}'
      };
    }
  }

  // Obtener perfil del usuario
  Future<UserProfile?> getUserProfile() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final response = await _client
          .from('profiles')
          .select('*')
          .eq('id', user.id)
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      print('Error al obtener perfil: $e');
      return null;
    }
  }

  // Actualizar perfil
  Future<Map<String, dynamic>> updateProfile({
    required String nombre,
    String? apellido,
    String? telefono,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        return {
          'success': false,
          'message': 'Usuario no autenticado'
        };
      }

      await _client.from('profiles').update({
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'fecha_actualizacion': DateTime.now().toIso8601String(),
      }).eq('id', user.id);

      return {
        'success': true,
        'message': 'Perfil actualizado exitosamente'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al actualizar perfil: ${e.toString()}'
      };
    }
  }

  // Restablecer contraseña
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return {
        'success': true,
        'message': 'Email de recuperación enviado'
      };
    } on AuthException catch (e) {
      return {
        'success': false,
        'message': _getErrorMessage(e.message)
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error inesperado: ${e.toString()}'
      };
    }
  }

  // Traducir mensajes de error
  String _getErrorMessage(String error) {
    switch (error.toLowerCase()) {
      case 'invalid login credentials':
        return 'Credenciales inválidas';
      case 'user already registered':
        return 'El usuario ya está registrado';
      case 'email not confirmed':
        return 'Email no confirmado';
      case 'invalid email':
        return 'Email inválido';
      case 'password should be at least 6 characters':
        return 'La contraseña debe tener al menos 6 caracteres';
      default:
        return error;
    }
  }
}