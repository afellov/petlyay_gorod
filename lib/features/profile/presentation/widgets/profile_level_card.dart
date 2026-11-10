import 'package:flutter/material.dart';

class ProfileLevelCard extends StatelessWidget {
  final int level;
  final int currentXp;
  final int maxXp;

  const ProfileLevelCard({
    super.key,
    this.level = 1,
    this.currentXp = 70,
    this.maxXp = 100,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (currentXp / maxXp).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$level Уровень", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              Text("$currentXp/$maxXp", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 14,
              width: double.infinity,
              color: Colors.pink.shade50,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress,
                child: Container(color: const Color(0xFFE5397F)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}