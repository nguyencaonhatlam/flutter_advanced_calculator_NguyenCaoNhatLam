import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../model/calculation_history.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
            "Calculation History",
            style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
            onPressed: () => _showDeleteDialog(context, historyProvider),
          )
        ],
      ),
      body: historyProvider.history.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(historyProvider, isDark),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
              "No history yet",
              style: TextStyle(color: Colors.grey, fontSize: 18, fontFamily: 'Roboto')
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(HistoryProvider provider, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: provider.history.length,
      itemBuilder: (context, index) {
        final item = provider.history[index];
        return Card(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(20),
            title: Text(
              item.expression,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                item.result,
                style: TextStyle(
                  color: isDark ? const Color(0xFF4ECDC4) : Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Text(
              "${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  // Hộp thoại xác nhận xóa
  void _showDeleteDialog(BuildContext context, HistoryProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Clear all history?"),
        content: const Text("Bạn có muốn xóa lịch sử hay không ?."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("HỦY", style: TextStyle(color: Colors.grey))
          ),
          TextButton(
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(context);
            },
            child: const Text("XÓA NGAY", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}