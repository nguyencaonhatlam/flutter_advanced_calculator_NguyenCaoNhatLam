import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../model/calculator_mode.dart';
import '../widgets/calculator_button.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalculatorProvider>(context);
    final history = Provider.of<HistoryProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // dark primary
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.history, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HistoryScreen()),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// DISPLAY
            Expanded(
              flex: 3,
              child: GestureDetector(
                onHorizontalDragEnd: (_) =>
                    provider.addToExpression('CE', history),
                child: _buildDisplay(provider),
              ),
            ),

            /// MODE
            _buildModeSelector(provider),

            /// BUTTON GRID
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildGrid(provider, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= DISPLAY =================
  Widget _buildDisplay(CalculatorProvider p) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.bottomRight,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(24), // đúng spec
      ),
      margin: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            p.expression,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            p.result,
            style: const TextStyle(
              fontSize: 32, // đúng spec
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  /// ================= MODE =================
  Widget _buildModeSelector(CalculatorProvider p) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _modeBtn(Icons.calculate, CalculatorMode.basic, p),
        _modeBtn(Icons.science, CalculatorMode.scientific, p),
        _modeBtn(Icons.memory, CalculatorMode.programmer, p),
      ],
    );
  }

  Widget _modeBtn(IconData icon, CalculatorMode mode, CalculatorProvider p) {
    final isActive = p.mode == mode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () => p.toggleMode(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300), // animation spec
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF4ECDC4) : const Color(0xFF424242),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }

  /// ================= GRID =================
  Widget _buildGrid(CalculatorProvider p, BuildContext context) {
    switch (p.mode) {
      case CalculatorMode.scientific:
        return _scientific(p, context);
      case CalculatorMode.programmer:
        return _programmer(p, context);
      default:
        return _basic(p, context);
    }
  }

  Widget _basic(CalculatorProvider p, BuildContext context) {
    final rows = [
      ['C', 'CE', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['±', '0', '.', '=']
    ];
    return _buildRows(rows, p, context);
  }

  Widget _scientific(CalculatorProvider p, BuildContext context) {
    final rows = [
      ['sin', 'cos', 'tan', 'ln', 'log', '√'],
      ['(', ')', 'x²', 'x^y', 'π', 'e'],
      ['MC', '7', '8', '9', 'C', '÷'],
      ['MR', '4', '5', '6', 'CE', '×'],
      ['M+', '1', '2', '3', '%', '-'],
      ['M-', '±', '0', '.', '=', '+'],
    ];
    return _buildRows(rows, p, context);
  }

  Widget _programmer(CalculatorProvider p, BuildContext context) {
    final rows = [
      ['BIN', 'OCT', 'DEC', 'HEX'],
      ['AND', 'OR', 'XOR', 'NOT'],
      ['<<', '>>', 'C', 'CE'],
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['0', '.', '=', '+'],
    ];
    return _buildRows(rows, p, context);
  }

  Widget _buildRows(List<List<String>> rows, CalculatorProvider p, BuildContext context) {
    final history = Provider.of<HistoryProvider>(context, listen: false);

    return Column(
      children: rows.map((row) {
        return Expanded(
          child: Row(
            children: row.map((label) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6), // 12px spacing
                  child: CalculatorButton(
                    label: label,
                    backgroundColor: _color(label),
                    onPressed: () => p.addToExpression(label, history),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Color _color(String label) {
    if (RegExp(r'[0-9.πe]').hasMatch(label)) return const Color(0xFF2C2C2C);
    if (['=', '+', '-', '×', '÷'].contains(label)) return const Color(0xFF4ECDC4);
    return const Color(0xFF424242);
  }
}