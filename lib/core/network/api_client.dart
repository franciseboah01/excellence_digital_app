import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_constants.dart';
import 'api_exceptions.dart';

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _dio.interceptors.add(AuthInterceptor(_secureStorage, _dio));
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }
  
  // GET
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
  
  // POST
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
  
  // PUT
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
  
  // DELETE
  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
  
  // Upload fichier
  Future<Response> uploadFile(String path, FormData formData) async {
    try {
      return await _dio.post(path, data: formData);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

// Interceptor pour ajouter le token automatiquement
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final Dio _dio;
  
  AuthInterceptor(this._secureStorage, this._dio);
  
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
  
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expiré, on déconnecte
      await _secureStorage.delete(key: 'auth_token');
      await _secureStorage.delete(key: 'user_data');
      // Ici on pourrait naviguer vers l'écran de login
    }
    handler.next(err);
  }
}