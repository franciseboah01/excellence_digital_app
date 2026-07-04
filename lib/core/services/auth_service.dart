import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../models/user.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Login
  Future<User> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
        'device_name': 'mobile_app',
      },
    );
    
    final token = response.data['token'];
    final user = User.fromJson(response.data['user']);
    
    // Sauvegarder le token et les données utilisateur
    await _secureStorage.write(key: 'auth_token', value: token);
    await _secureStorage.write(key: 'user_data', value: user.toJsonString());
    
    return user;
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
    
    final token = response.data['token'];
    final user = User.fromJson(response.data['user']);
    
    await _secureStorage.write(key: 'auth_token', value: token);
    await _secureStorage.write(key: 'user_data', value: user.toJsonString());
    
    return user;
  }
  
  // Logout
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } catch (_) {}
    
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_data');
  }
  
  // Récupérer l'utilisateur connecté
  Future<User?> getCurrentUser() async {
    try {
      final userData = await _secureStorage.read(key: 'user_data');
      if (userData != null) {
        return User.fromJsonString(userData);
      }
      
      // Si pas de données locales, récupérer depuis l'API
      final response = await _apiClient.get(ApiConstants.user);
      final user = User.fromJson(response.data);
      await _secureStorage.write(key: 'user_data', value: user.toJsonString());
      return user;
    } catch (e) {
      return null;
    }
  }
  
  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return token != null;
  }
  
  // Mot de passe oublié
  Future<void> forgotPassword(String email) async {
    await _apiClient.post(
      ApiConstants.forgotPassword,
      data: {'email': email},
    );
  }
  
  // Réinitialiser le mot de passe
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
  
  // Mettre à jour le profil
  Future<User> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.put(ApiConstants.updateProfile, data: data);
    final user = User.fromJson(response.data['user']);
    await _secureStorage.write(key: 'user_data', value: user.toJsonString());
    return user;
  }
}

// Provider Riverpod
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final currentUserProvider = FutureProvider<User?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUser();
});