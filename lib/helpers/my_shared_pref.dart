import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final AppPreferences _instance = AppPreferences._internal();
  static SharedPreferences? _prefs;

  factory AppPreferences() => _instance;

  AppPreferences._internal();

  /// Initialize preferences (call in main before runApp)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save String
  Future<void> setString({required String key, required String value}) async {
    await _prefs?.setString(key, value);
  }

  /// Get String
  String? getString({required String key}) {
    return _prefs?.getString(key);
  }

  /// Save Int
  Future<void> setInt({required String key, required int value}) async {
    await _prefs?.setInt(key, value);
  }

  /// Get Int
  int? getInt({required String key}) {
    return _prefs?.getInt(key);
  }

  /// Save Bool
  Future<void> setBool({required String key, required bool value}) async {
    await _prefs?.setBool(key, value);
  }

  /// Get Bool
  bool? getBool({required String key}) {
    return _prefs?.getBool(key);
  }

  /// Save Object (convert to JSON)
  Future<void> setObject({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    await _prefs?.setString(key, jsonEncode(value));
  }

  /// Get Object
  Map<String, dynamic>? getObject({required String key}) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  /// Remove Key
  Future<void> remove({required String key}) async {
    await _prefs?.remove(key);
  }

  /// Clear all
  Future<void> clear() async {
    await _prefs?.clear();
  }
}
