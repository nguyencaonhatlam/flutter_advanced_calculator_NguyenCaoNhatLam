import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../model/calculator_mode.dart';
class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    var calc = Provider.of<CalculatorProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBtn(context, "Basic", CalculatorMode.basic),
        _buildBtn(context, "Sci", CalculatorMode.scientific),
        _buildBtn(context, "Prog", CalculatorMode.programmer),
      ],
    );
  }

  Widget _buildBtn(context, text, mode) {
    var calc = Provider.of<CalculatorProvider>(context);

    return ElevatedButton(
      onPressed: () => calc.toggleMode(mode),
      child: Text(text),
    );
  }
}