import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class SessionService {
  static const _lastLoginKey = 'last_login';
  static const _onboardingDoneKey = 'onboarding_done';

  final SharedPreferences _prefs;

  SessionService._(this._prefs);

  static Future<SessionService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return SessionService._(prefs);
  }

  // Dernière connexion
  DateTime? get lastLogin {
    final value = _prefs.getString(_lastLoginKey);
    return value != null ? DateTime.tryParse(value) : null;
  }

  Future<void> setLastLogin(DateTime date) async {
    await _prefs.setString(_lastLoginKey, date.toIso8601String());
  }

  // Onboarding
  bool get onboardingDone => _prefs.getBool(_onboardingDoneKey) ?? false;

  Future<void> setOnboardingDone() async {
    await _prefs.setBool(_onboardingDoneKey, true);
  }

  // Clear
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}

final sessionServiceProvider = FutureProvider<SessionService>((ref) async {
  return SessionService.init();
});
