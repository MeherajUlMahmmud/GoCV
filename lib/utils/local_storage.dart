import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<Map<String, dynamic>> readData(String key) async {
    try {
      final prefs = await _getPreferences();
      final data = prefs.getString(key);
      return data != null ? jsonDecode(data) : <String, dynamic>{};
    } catch (e) {
      print(e);
      return <String, dynamic>{};
    }
  }

  Future<bool> writeData(String key, Map<String, dynamic> data) async {
    final prefs = await _getPreferences();
    return prefs.setString(key, jsonEncode(data));
  }

  Future<bool> removeData(String key) async {
    final prefs = await _getPreferences();
    return prefs.remove(key);
  }

  Future<bool> clearData() async {
    final prefs = await _getPreferences();
    return prefs.clear();
  }

  Future<bool> getBool(String key) async {
    final prefs = await _getPreferences();
    return prefs.getBool(key) ?? false;
  }

  Future<double> getDouble(String key) async {
    final prefs = await _getPreferences();
    return prefs.getDouble(key) ?? 0.0;
  }
}
