import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/history_provider.dart';
import 'history_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  int decimalPrecision = 4;
  bool isDegree = true;
  int historySize = 50;
  bool haptic = true;
  bool sound = false;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final history = Provider.of<HistoryProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontFamily: 'Roboto')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [

          /// ================= APPEARANCE =================
          const Text(
            "APPEARANCE",
            style: TextStyle(
              color: Color(0xFF4ECDC4),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          _card(
            isDark,
            ListTile(
              title: Text("Theme Mode",
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
              trailing: DropdownButton<ThemeMode>(
                value: theme.themeMode,
                dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                underline: Container(height: 2, color: const Color(0xFF4ECDC4)),
                onChanged: (m) => theme.setTheme(m!),
                items: const [
                  DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
                  DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// ================= CALCULATION =================
          const Text(
            "CALCULATION",
            style: TextStyle(
              color: Color(0xFF4ECDC4),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          _card(
            isDark,
            Column(
              children: [

                /// Decimal Precision
                ListTile(
                  title: Text("Decimal Precision",
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                  trailing: DropdownButton<int>(
                    value: decimalPrecision,
                    dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                    onChanged: (v) => setState(() => decimalPrecision = v!),
                    items: List.generate(9, (i) => i + 2)
                        .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("$e digits")))
                        .toList(),
                  ),
                ),

                /// Angle Mode
                SwitchListTile(
                  title: Text("Angle Mode (DEG/RAD)",
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                  value: isDegree,
                  activeColor: const Color(0xFF4ECDC4),
                  onChanged: (v) => setState(() => isDegree = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// ================= DATA =================
          const Text(
            "DATA & HISTORY",
            style: TextStyle(
              color: Color(0xFF4ECDC4),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          _card(
            isDark,
            Column(
              children: [

                /// View history
                ListTile(
                  leading: const Icon(Icons.history, color: Color(0xFF4ECDC4)),
                  title: Text("View History",
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    );
                  },
                ),

                /// History size
                ListTile(
                  title: Text("History Size",
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                  trailing: DropdownButton<int>(
                    value: historySize,
                    dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                    onChanged: (v) => setState(() => historySize = v!),
                    items: [25, 50, 100]
                        .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("$e items")))
                        .toList(),
                  ),
                ),

                /// Clear history
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
                  title: const Text("Clear History",
                      style: TextStyle(color: Colors.redAccent)),
                  onTap: () => _confirmDelete(context, history),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// ================= EXTRA =================
          const Text(
            "EXTRA",
            style: TextStyle(
              color: Color(0xFF4ECDC4),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          _card(
            isDark,
            Column(
              children: [

                /// Haptic
                SwitchListTile(
                  title: Text("Haptic Feedback",
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                  value: haptic,
                  activeColor: const Color(0xFF4ECDC4),
                  onChanged: (v) => setState(() => haptic = v),
                ),

                /// Sound
                SwitchListTile(
                  title: Text("Sound Effects",
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                  value: sound,
                  activeColor: const Color(0xFF4ECDC4),
                  onChanged: (v) => setState(() => sound = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= CARD UI =================
  Widget _card(bool isDark, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  /// ================= CONFIRM DELETE =================
  void _confirmDelete(BuildContext context, HistoryProvider history) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text("Clear History?",
            style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        content: Text(
          "Bạn có chắc chắn muốn xóa toàn bộ lịch sử không?",
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("HỦY"),
          ),
          TextButton(
            onPressed: () {
              history.clearHistory(); // ✅ FIX ĐÚNG
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("History cleared!"),
                  backgroundColor: Color(0xFF4ECDC4),
                ),
              );
            },
            child: const Text("XÓA", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}