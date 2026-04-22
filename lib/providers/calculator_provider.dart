import 'package:flutter/material.dart';
import '../model/calculator_mode.dart';
import '../utils/calculator_logic.dart';
import 'history_provider.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _result = '0';
  CalculatorMode _mode = CalculatorMode.basic;
  bool _isCalculated = false;
  double _memory = 0;
  String get expression => _expression;
  String get result => _result;
  CalculatorMode get mode => _mode;

  void addToExpression(String value, HistoryProvider historyProvider) {
    if (_isCalculated) {
      if (RegExp(r'[0-9.πe]').hasMatch(value) ||
          ['sin', 'cos', 'tan', 'ln', 'log', '√', '('].contains(value)) {
        _expression = '';
      }
      else if (['+', '-', '×', '÷', '%', 'x^y', 'x²'].contains(value)) {
        _expression = _result;
      }
      _isCalculated = false;
    }

    if (value == 'MC') { _memory = 0; return; }
    if (value == 'MR') {
      _expression += _memory.toString();
      notifyListeners();
      return;
    }
    if (value == 'M+') { _memory += double.tryParse(_result) ?? 0; return; }
    if (value == 'M-') { _memory -= double.tryParse(_result) ?? 0; return; }

    if (value == '=') {
      calculate(historyProvider);
    } else if (value == 'C') {
      _expression = '';
      _result = '0';
      _isCalculated = false;
    } else if (value == 'CE') {
      if (_expression.isNotEmpty) _expression = _expression.substring(0, _expression.length - 1);
    }
    else if (value == 'x^y') {
      _expression += '^';
    }
    else if (value == 'x²') {
      _expression += '^2';
    }
    else if (['sin', 'cos', 'tan', 'ln', 'log', '√'].contains(value)) {
      _expression += value == '√' ? '√(' : '$value(';
    }
    else {
      _expression += value;
    }

    notifyListeners();
  }

  void calculate(HistoryProvider historyProvider) {
    if (_expression.isEmpty) return;

    String currentExp = _expression;
    _result = CalculatorLogic.calculate(_expression);

    if (_result != "Error") {
      historyProvider.addHistory(currentExp, _result);
    }

    _isCalculated = true;
    notifyListeners();
  }

  void toggleMode(CalculatorMode newMode) {
    _mode = newMode;
    notifyListeners();
  }
  void changeMode(CalculatorMode newMode) {
    _mode = newMode;
    notifyListeners();
  }
}