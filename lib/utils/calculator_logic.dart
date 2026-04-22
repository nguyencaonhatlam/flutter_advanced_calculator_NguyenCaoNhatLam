import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

class CalculatorLogic {
  static String calculate(String expression) {
    if (expression.isEmpty) return "0";
    try {
      String finalExp = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('√', 'sqrt')
          .replaceAll('π', math.pi.toString())
          .replaceAll('e', math.e.toString())
          .replaceAll('x²', '^2')
          .replaceAll('x^y', '^')
          .replaceAll('%', '/100');
      finalExp = finalExp.replaceAllMapped(RegExp(r'log\(([^)]+)\)'), (match) {
        return 'log(10,${match.group(1)})';
      });
      finalExp = finalExp.replaceAllMapped(RegExp(r'(sin|cos|tan)\(([^)]+)\)'), (match) {
        String function = match.group(1)!;
        String value = match.group(2)!;
        return '$function($value * ${math.pi} / 180)';
      });
      int open = '('.allMatches(finalExp).length;
      int close = ')'.allMatches(finalExp).length;
      if (open > close) {
        finalExp += ')' * (open - close);
      }
      Parser p = Parser();
      Expression exp = p.parse(finalExp);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      if (eval.isNaN || eval.isInfinite) return "Error";
      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      }
      return double.parse(eval.toStringAsFixed(8)).toString();
    } catch (e) {
      return "Error";
    }
  }
}