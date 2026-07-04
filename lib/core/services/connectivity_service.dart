import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  static final ConnectivityService _instance = ConnectivityService._internal();
  static ConnectivityService get instance => _instance;
  factory ConnectivityService() => _instance;

  ConnectivityService._internal() {
    _connectivity.onConnectivityChanged.listen((results) {
      final isConnected =
          results.any((result) => result != ConnectivityResult.none);
      _controller.add(isConnected);
    });
  }

  Stream<bool> get connectivityStream => _controller.stream;

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  void dispose() {
    _controller.close();
  }
}

final connectivityProvider = StreamProvider<bool>((ref) {
  return ConnectivityService.instance.connectivityStream;
});
