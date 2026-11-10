import 'package:flutter/material.dart';

class ProfileRatingCard extends StatelessWidget {
  const ProfileRatingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Рейтинг",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            Text(
              "Смотреть весь рейтинг >",
              style: TextStyle(
                color: Color(0xFFE5397F),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ваше место",
                      style: TextStyle(
                        color: Color(0xFFE5397F),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Text(
                          "35",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFE5397F),
                          ),
                        ),
                        Text(
                          "место",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE5397F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 80,
                      height: 1,
                      color: Colors.pink.shade200,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Ваш опыт",
                      style: TextStyle(
                        color: Color(0xFFE5397F),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "70 XP",
                      style: TextStyle(
                        color: Color(0xFFE5397F),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(width: 1, height: 80, color: Colors.grey.shade200),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildLeader(
                      "2",
                      "СОБАЧКА",
                      "1950 XP",
                      Colors.grey.shade400,
                      48,
                    ),
                    _buildLeader(
                      "1",
                      "КОТ",
                      "2450 XP",
                      Colors.pink.shade300,
                      60,
                      isFirst: true,
                    ),
                    _buildLeader(
                      "3",
                      "КОТИК",
                      "1900 XP",
                      Colors.amber.shade600,
                      46,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeader(
    String rank,
    String name,
    String xp,
    Color color,
    double size, {
    bool isFirst = false,
  }) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isFirst
                      ? const Color(0xFFE5397F)
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: Colors.grey.shade300,
              ),
              child: const Icon(Icons.pets, size: 20, color: Colors.white),
            ),
            Positioned(
              top: -8,
              child: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Text(
                  rank,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: isFirst ? Colors.black : Colors.black87,
          ),
        ),
        Text(
          xp,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE5397F),
          ),
        ),
      ],
    );
  }
}
