import 'package:flutter/material.dart';

class ProfileStatsCard extends StatelessWidget {
  final int tasksCompleted;
  final int kmPassed;

  const ProfileStatsCard({
    super.key,
    this.tasksCompleted = 140,
    this.kmPassed = 350,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text("Выполнено заданий", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("$tasksCompleted", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          Container(width: 1.5, height: 40, color: Colors.grey.shade300),
          Expanded(
            child: Column(
              children: [
                const Text("Пройдено километров", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("$kmPassed", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}