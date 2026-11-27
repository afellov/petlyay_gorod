import 'package:flutter/material.dart';
import 'package:walk_city/core/theme/app_visuals.dart';

class ProfileStatsCard extends StatelessWidget {
  final int tasksCompleted;
  final double kmPassed;

  const ProfileStatsCard({
    super.key,
    this.tasksCompleted = 0,
    this.kmPassed = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(color: AppVisuals.of(context).shadow, blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Выполнено заданий",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "$tasksCompleted",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1.5, height: 40, color: Colors.grey.shade300),
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Пройдено километров",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  kmPassed.toStringAsFixed(kmPassed % 1 == 0 ? 0 : 1),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
