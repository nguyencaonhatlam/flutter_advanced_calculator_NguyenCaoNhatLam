import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveHistory(List history) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('history', jsonEncode(history));
  }

  static Future<List> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('history');

    if (data == null) return [];

    return jsonDecode(data);
  }
}