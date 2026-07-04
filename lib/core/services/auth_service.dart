import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_exceptions.dart';
import '../models/user.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';
  static const _rolesKey = 'user_roles';

  // Login
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
          'device_name': 'mobile_app',
        },
      );

      final data = response.data;
      final token = data['token'] as String;
      final user = User.fromJson(data['user']);
      final roles = List<String>.from(data['roles'] ?? []);

      await Future.wait([
        _secureStorage.write(key: _tokenKey, value: token),
        _secureStorage.write(key: _userKey, value: jsonEncode(data['user'])),
        _secureStorage.write(key: _rolesKey, value: jsonEncode(roles)),
      ]);

      return user;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Erreur de connexion: $e');
    }
  }

  // Register
  Future<User> register({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? telephone,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.register,
        data: {
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'telephone': telephone,
        },
      );

      final token = response.data['token'] as String;
      final user = User.fromJson(response.data['user']);

      await _secureStorage.write(key: _tokenKey, value: token);
      await _secureStorage.write(
          key: _userKey, value: jsonEncode(response.data['user']));

      return user;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Erreur d\'inscription: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } catch (_) {}
    await _secureStorage.deleteAll();
  }

  // Vérifier si connecté
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Récupérer l'utilisateur courant
  Future<User?> getCurrentUser() async {
    try {
      final userData = await _secureStorage.read(key: _userKey);
      if (userData != null) {
        return User.fromJson(jsonDecode(userData));
      }

      final response = await _apiClient.get(ApiConstants.user);
      final user = User.fromJson(response.data);
      await _secureStorage.write(
          key: _userKey, value: jsonEncode(response.data));
      return user;
    } catch (e) {
      return null;
    }
  }

  // Récupérer les rôles
  Future<List<String>> getRoles() async {
    final rolesData = await _secureStorage.read(key: _rolesKey);
    if (rolesData != null) {
      return List<String>.from(jsonDecode(rolesData));
    }
    return [];
  }

  // Vérifier un rôle
  Future<bool> hasRole(String role) async {
    final roles = await getRoles();
    return roles.contains(role);
  }

  // Mot de passe oublié
  Future<void> forgotPassword(String email) async {
    await _apiClient.post(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );
  }

  // Réinitialiser mot de passe
  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    await _apiClient.post(
      ApiConstants.resetPassword,
      data: {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }
}

// Providers Riverpod
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.isLoggedIn();
});

final currentUserProvider = FutureProvider<User?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUser();
});

final userRolesProvider = FutureProvider<List<String>>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.getRoles();
});
