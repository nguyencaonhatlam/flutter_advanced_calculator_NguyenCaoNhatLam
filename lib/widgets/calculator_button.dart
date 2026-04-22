import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget {
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  double scale = 1.0;

  void _onTapDown(_) {
    setState(() => scale = 0.9);
  }

  void _onTapUp(_) {
    setState(() => scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(6), // spacing 12px tổng
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(16), // đúng spec
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16, // đúng spec
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ),
    );
  }
}