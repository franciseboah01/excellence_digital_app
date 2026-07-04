import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  
  ApiException({
    required this.message,
    this.statusCode,
    this.errors,
  });
  
  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Délai de connexion dépassé. Vérifiez votre connexion.');
        
      case DioExceptionType.connectionError:
        return ApiException(message: 'Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
        
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response!);
        
      case DioExceptionType.cancel:
        return ApiException(message: 'Requête annulée.');
        
      default:
        return ApiException(message: 'Une erreur inattendue est survenue.');
    }
  }
  
  factory ApiException._fromJson(Map<String, dynamic> json, int statusCode) {
    return ApiException(
      message: json['message'] ?? 'Erreur serveur',
      statusCode: statusCode,
      errors: json['errors'],
    );
  }
  
  static ApiException _handleResponseError(Response response) {
    final statusCode = response.statusCode ?? 500;
    final data = response.data;
    
    if (data is Map<String, dynamic>) {
      switch (statusCode) {
        case 400:
          return ApiException(message: data['message'] ?? 'Requête invalide.', statusCode: statusCode);
        case 401:
          return ApiException(message: 'Session expirée. Veuillez vous reconnecter.', statusCode: statusCode);
        case 403:
          return ApiException(message: data['message'] ?? 'Accès non autorisé.', statusCode: statusCode);
        case 404:
          return ApiException(message: 'Ressource introuvable.', statusCode: statusCode);
        case 422:
          return ApiException(
            message: data['message'] ?? 'Données invalides.',
            statusCode: statusCode,
            errors: data['errors'],
          );
        case 429:
          return ApiException(message: 'Trop de requêtes. Veuillez patienter.', statusCode: statusCode);
        case 500:
          return ApiException(message: 'Erreur serveur. Réessayez plus tard.', statusCode: statusCode);
        default:
          return ApiException(message: data['message'] ?? 'Erreur ${statusCode}', statusCode: statusCode);
      }
    }
    
    return ApiException(message: 'Erreur serveur inattendue.', statusCode: statusCode);
  }
}