class Route {
  final String id;
  final String slug;
  final String title;
  final String summary;
  final String description;
  final String? coverUrl;
  final double? distanceKm;
  final int? estimatedMinutes;
  final int? rewardPoints;
  final String? difficulty;
  final int checkpointRadiusM;

  const Route({
    required this.id,
    required this.slug,
    required this.title,
    required this.summary,
    required this.description,
    required this.coverUrl,
    required this.distanceKm,
    required this.estimatedMinutes,
    required this.rewardPoints,
    required this.difficulty,
    this.checkpointRadiusM = 30,
  });
}
