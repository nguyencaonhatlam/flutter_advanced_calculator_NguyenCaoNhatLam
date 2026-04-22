import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/calculation_history.dart';

class HistoryProvider extends ChangeNotifier {
  List<CalculationHistory> _history = [];
  static const String _storageKey = 'calculator_history_data';

  List<CalculationHistory> get history => _history;

  HistoryProvider() {
    _loadFromPrefs();
  }

  void addHistory(String exp, String res) {
    _history.insert(0, CalculationHistory(
      expression: exp,
      result: res,
      timestamp: DateTime.now(),
    ));

    if (_history.length > 50) _history.removeLast();
    _saveToPrefs();
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _history.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString(_storageKey);

    if (savedData != null) {
      final List<dynamic> decodedData = jsonDecode(savedData);
      _history = decodedData
          .map((item) => CalculationHistory.fromJson(item))
          .toList();
      notifyListeners();
    }
  }
}