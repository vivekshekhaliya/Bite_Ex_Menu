import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {

  /// Save
  static Future<bool> savePref(String key, dynamic value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    if (value is String) {
      return sp.setString(key, value);
    } else {
      return sp.setString(key, jsonEncode(value));
    }
  }

  /// Get
  static Future<dynamic> getPref(String key) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? data = sp.getString(key);

    if (data != null) {
      try {
        return jsonDecode(data);
      } catch (e) {
        return data;
      }
    }
    return null;
  }

  /// Clear
  static Future<bool> clearPref(String key) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.remove(key);
  }
}