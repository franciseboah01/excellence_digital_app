import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import 'api_exceptions.dart';

class ApiClient {
  late final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      sendTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
    ));

    dio.interceptors.addAll([
      AuthInterceptor(_secureStorage),
      ConnectivityInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('[API] $obj'),
      ),
    ]);
  }

  // Méthodes HTTP
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await dio.post(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await dio.put(path, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      final response = await dio.delete(path);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Response _handleResponse(Response response) {
    if (response.statusCode == 401) {
      _secureStorage.deleteAll();
    }
    return response;
  }
}

// Interceptor Auth
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['X-API-Version'] = 'v1';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _secureStorage.deleteAll();
      // Rediriger vers login
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/login', (route) => false);
    }
    handler.next(err);
  }
}

// Interceptor Connectivité
class ConnectivityInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      // Notifier l'utilisateur
      print('⚠️ Pas de connexion internet');
    }
    handler.next(err);
  }
}
