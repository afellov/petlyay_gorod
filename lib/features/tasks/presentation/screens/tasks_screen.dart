import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:walk_city/core/theme/app_assets.dart';
import 'package:walk_city/core/theme/app_visuals.dart';
import 'package:walk_city/core/widgets/custom_app_bar.dart';
import 'package:walk_city/features/tasks/presentation/widgets/mission_content.dart';

const _pink = Color(0xFFDC3978);
const _darkTaskSurface = Color(0xFF462134);

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _showMissions = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: Stack(
      children: [
        const AppPageBackground(),
        Column(
          children: [
            const CustomAppBar(title: 'ЗАДАНИЯ'),
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: LayoutBuilder(
                  builder: (context, viewport) {
                    // The Figma content frame is 408 px wide within a 440 px screen.
                    final contentWidth = viewport.maxWidth - 32;
                    final scale = (contentWidth / 408).clamp(.68, 1.0);
                    return Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  16,
                                  20 * scale,
                                  16,
                                  23 * scale,
                                ),
                                child: _Tabs(
                                  scale: scale,
                                  showMissions: _showMissions,
                                  onSelect: (value) =>
                                      setState(() => _showMissions = value),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    130,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (_showMissions)
                                        MissionBanner(scale: scale)
                                      else
                                        _RandomMarkersBanner(scale: scale),
                                      SizedBox(height: 24 * scale),
                                      _SearchFilters(
                                        scale: scale,
                                        missions: _showMissions,
                                      ),
                                      SizedBox(height: 12 * scale),
                                      if (_showMissions)
                                        MissionList(scale: scale)
                                      else
                                        for (
                                          var i = 0;
                                          i < _figmaRoutes.length;
                                          i++
                                        ) ...[
                                          _RouteCard(
                                            route: _figmaRoutes[i],
                                            scale: scale,
                                          ),
                                          SizedBox(height: 12 * scale),
                                        ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.scale,
    required this.showMissions,
    required this.onSelect,
  });
  final double scale;
  final bool showMissions;
  final ValueChanged<bool> onSelect;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _GlassTaskTab(
          label: 'Маршруты',
          scale: scale,
          selected: !showMissions,
          onTap: () => onSelect(false),
        ),
      ),
      SizedBox(width: 12 * scale),
      Expanded(
        child: _GlassTaskTab(
          label: 'Миссии',
          scale: scale,
          selected: showMissions,
          onTap: () => onSelect(true),
        ),
      ),
    ],
  );
}

class _GlassTaskTab extends StatelessWidget {
  const _GlassTaskTab({
    required this.label,
    required this.scale,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final double scale;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final visuals = AppVisuals.of(context);
    final radius = BorderRadius.circular(25);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: !visuals.dark && !selected
            ? const [BoxShadow(color: Color(0x24000000), blurRadius: 5)]
            : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 40 * scale,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: visuals.dark
                    ? selected
                          ? _darkTaskSurface.withValues(alpha: .85)
                          : AppVisuals.darkBase.withValues(alpha: .78)
                    : selected
                    ? visuals.pill
                    : visuals.card,
                borderRadius: radius,
                border: visuals.dark
                    ? Border.all(
                        color: Colors.white.withValues(alpha: .10),
                        width: .5,
                      )
                    : null,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w700,
                  fontSize: 17 * scale,
                  color: selected ? _pink : visuals.heading,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// The image slot follows Figma. Set this path when the original map art is supplied.
const _mapAsset = 'assets/images/tasks/route_map.png';

class _RandomMarkersBanner extends StatelessWidget {
  const _RandomMarkersBanner({required this.scale});
  final double scale;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: 152 * scale,
    padding: EdgeInsets.fromLTRB(
      14 * scale,
      10 * scale,
      10 * scale,
      10 * scale,
    ),
    decoration: _cardDecoration(context, 15),
    child: Row(
      children: [
        SizedBox(
          width: 191 * scale,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Случайные метки',
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 20 * scale,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: AppVisuals.of(context).heading,
                ),
              ),
              SizedBox(height: 10 * scale),
              Expanded(
                child: Text(
                  'Ищите случайные метки на карте города и получайте награды за каждую пройденную точку!',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12 * scale,
                    height: 1.33,
                    color: AppVisuals.of(context).body,
                  ),
                ),
              ),
              Container(
                width: 143 * scale,
                height: 28 * scale,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppVisuals.of(context).dark
                      ? _darkTaskSurface
                      : const Color(0xFFE9669B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Искать метки',
                  style: TextStyle(
                    fontFamily: 'Russo One',
                    fontSize: 12 * scale,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 150 * scale,
          height: 130 * scale,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppAssets.bannerSplatter,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 126 * scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.asset(
                    _mapAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const _MapArtworkPlaceholder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _MapArtworkPlaceholder extends StatelessWidget {
  const _MapArtworkPlaceholder();
  @override
  Widget build(BuildContext context) => const CustomPaint(
    painter: _MapArtworkPainter(),
    child: SizedBox.expand(),
  );
}

class _MapArtworkPainter extends CustomPainter {
  const _MapArtworkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas.drawRect(bounds, Paint()..color = const Color(0xFFF5E4E8));
    final street = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 4;
    final blocks = [
      const Color(0xFFD7CDD7),
      const Color(0xFFE6D6D9),
      const Color(0xFFCDC1CE),
      const Color(0xFFD5DDBB),
    ];
    for (var column = -2; column < 9; column++) {
      for (var row = -2; row < 9; row++) {
        final rect = Rect.fromLTWH(
          column * 23.0 + (row.isEven ? 9 : 0),
          row * 21.0,
          19,
          17,
        );
        canvas.drawRect(
          rect,
          Paint()..color = blocks[(column.abs() + row.abs()) % blocks.length],
        );
      }
    }
    for (var x = -size.height; x < size.width + size.height; x += 24) {
      canvas.drawLine(
        Offset(x.toDouble(), 0),
        Offset(x + size.height, size.height),
        street,
      );
    }
    final river = Path()
      ..moveTo(size.width * .38, size.height)
      ..cubicTo(
        size.width * .65,
        size.height * .73,
        size.width * .67,
        size.height * .61,
        size.width,
        size.height * .5,
      );
    canvas.drawPath(
      river,
      Paint()
        ..color = const Color(0xFFF2EBCD)
        ..strokeWidth = 26
        ..style = PaintingStyle.stroke,
    );
    canvas.drawPath(
      river,
      Paint()
        ..color = const Color(0xFF91B3D5)
        ..strokeWidth = 19
        ..style = PaintingStyle.stroke,
    );
    final points = [
      Offset(size.width * .75, size.height * .18),
      Offset(size.width * .36, size.height * .51),
      Offset(size.width * .79, size.height * .79),
    ];
    final route = Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..quadraticBezierTo(
        size.width * .78,
        size.height * .4,
        points[1].dx,
        points[1].dy,
      )
      ..quadraticBezierTo(
        size.width * .35,
        size.height * .83,
        points[2].dx,
        points[2].dy,
      );
    final metrics = route.computeMetrics();
    final dash = Paint()
      ..color = const Color(0xFFD84980)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    for (final metric in metrics) {
      for (double d = 0; d < metric.length; d += 8) {
        canvas.drawPath(
          metric.extractPath(d, (d + 4).clamp(0, metric.length)),
          dash,
        );
      }
    }
    for (final point in points) {
      canvas.drawCircle(point, 12, Paint()..color = const Color(0xFFD84980));
      canvas.drawCircle(point, 5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _MapArtworkPainter oldDelegate) => false;
}

class _SearchFilters extends StatelessWidget {
  const _SearchFilters({required this.scale, required this.missions});
  final double scale;
  final bool missions;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      _FilterBox(
        width: 50 * scale,
        height: 40 * scale,
        child: SvgPicture.asset(
          AppAssets.search,
          width: 23 * scale,
          colorFilter: ColorFilter.mode(
            AppVisuals.of(context).heading,
            BlendMode.srcIn,
          ),
        ),
      ),
      SizedBox(width: 12 * scale),
      _FilterBox(
        width: 50 * scale,
        height: 40 * scale,
        highlighted: missions,
        child: SvgPicture.asset(
          AppAssets.filter,
          width: 23 * scale,
          colorFilter: ColorFilter.mode(
            missions ? _pink : AppVisuals.of(context).heading,
            BlendMode.srcIn,
          ),
        ),
      ),
      SizedBox(width: 12 * scale),
      _FilterBox(
        width: 88 * scale,
        height: 32 * scale,
        highlighted: missions,
        child: Text(
          'Рядом',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 14 * scale,
            fontWeight: FontWeight.w700,
            color: missions ? _pink : AppVisuals.of(context).heading,
          ),
        ),
      ),
      SizedBox(width: 12 * scale),
      _FilterBox(
        width: 99 * scale,
        height: 32 * scale,
        child: Text(
          'До 30 мин',
          style: TextStyle(
            fontFamily: 'Arial',
            fontSize: 14 * scale,
            fontWeight: FontWeight.w700,
            color: AppVisuals.of(context).heading,
          ),
        ),
      ),
    ],
  );
}

class _FilterBox extends StatelessWidget {
  const _FilterBox({
    required this.width,
    required this.height,
    required this.child,
    this.highlighted = false,
  });
  final double width, height;
  final Widget child;
  final bool highlighted;
  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: highlighted
          ? AppVisuals.of(context).dark
                ? _darkTaskSurface
                : AppVisuals.of(context).pill
          : AppVisuals.of(context).card,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(color: Color(0x23000000), blurRadius: 4)],
    ),
    child: child,
  );
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.route, required this.scale});
  final _RoutePreview route;
  final double scale;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: 163 * scale,
    padding: EdgeInsets.all(8 * scale),
    decoration: _cardDecoration(context, 15),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 142 * scale,
            height: 143 * scale,
            child: Stack(
              children: [
                Positioned.fill(
                  child: route.asset == null
                      ? const ColoredBox(
                          color: Color(0xFFF0E2E7),
                          child: Center(
                            child: Icon(
                              Icons.directions_walk,
                              color: Color(0xFF665A60),
                              size: 38,
                            ),
                          ),
                        )
                      : Image.asset(
                          route.asset!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const ColoredBox(
                            color: Color(0xFFF0E2E7),
                            child: Center(
                              child: Icon(
                                Icons.directions_walk,
                                color: Color(0xFF665A60),
                                size: 38,
                              ),
                            ),
                          ),
                        ),
                ),
                if (route.venue != null)
                  Positioned(
                    left: 4 * scale,
                    top: 4 * scale,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6 * scale,
                        vertical: 2 * scale,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        route.venue!,
                        style: TextStyle(
                          fontFamily: 'UNCAGE',
                          fontSize: 9 * scale,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(width: 14 * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4 * scale,
                    height: 4 * scale,
                    decoration: BoxDecoration(
                      color: route.difficultyColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6 * scale),
                  Expanded(
                    child: Text(
                      route.difficulty,
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12 * scale,
                        color: route.difficultyColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  for (final reward in route.rewards)
                    Padding(
                      padding: EdgeInsets.only(left: 4 * scale),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6 * scale,
                          vertical: 3 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: AppVisuals.of(context).dark
                              ? _darkTaskSurface
                              : AppVisuals.of(context).reward,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          reward,
                          style: TextStyle(
                            color: _pink,
                            fontSize: 11 * scale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 11 * scale),
              Text(
                route.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 14 * scale,
                  height: 1.14,
                  fontWeight: FontWeight.w700,
                  color: AppVisuals.of(context).heading,
                ),
              ),
              SizedBox(height: 6 * scale),
              Expanded(
                child: Text(
                  route.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 11 * scale,
                    height: 1.45,
                    color: AppVisuals.of(context).body,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 30 * scale,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _pink,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'Начать маршрут',
                        style: TextStyle(
                          fontFamily: 'Russo One',
                          fontSize: 12 * scale,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8 * scale),
                  Container(
                    width: 30 * scale,
                    height: 30 * scale,
                    decoration: BoxDecoration(
                      color: AppVisuals.of(context).dark
                          ? _darkTaskSurface
                          : AppVisuals.of(context).reward,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      route.favorite ? Icons.favorite : Icons.favorite_border,
                      color: _pink,
                      size: 18 * scale,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

BoxDecoration _cardDecoration(BuildContext context, double radius) =>
    BoxDecoration(
      color: AppVisuals.of(context).card,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(color: AppVisuals.of(context).shadow, blurRadius: 4),
      ],
    );

class _RoutePreview {
  const _RoutePreview(
    this.title,
    this.summary,
    this.difficulty,
    this.difficultyColor,
    this.rewards, {
    this.venue,
    this.asset,
    this.favorite = false,
  });
  final String title, summary, difficulty;
  final Color difficultyColor;
  final List<String> rewards;
  final String? venue, asset;
  final bool favorite;
}

const _figmaRoutes = <_RoutePreview>[
  _RoutePreview(
    'Стальной характер города',
    'Разгадайте, как строительство комбината изменило Новокузнецк.',
    'Средний',
    Color(0xFFE18400),
    ['+100 XP', '+150 Б.'],
    venue: 'БАРДАК',
    asset: 'assets/images/tasks/steel_city.png',
  ),
  _RoutePreview(
    'По следам великого писателя',
    'Пройдите по старой части города и раскройте историю его жизни в Кузнецке',
    'Лёгкий',
    Color(0xFF11B928),
    ['+100 XP'],
    favorite: true,
    asset: 'assets/images/tasks/writer.png',
  ),
  _RoutePreview(
    'Город, воспетый поэтом',
    'Пройдите по центру и соберите знаменитые строки Маяковского о городе.',
    'Сложный',
    Color(0xFFE00000),
    ['+90 XP', '+95 Б.'],
    venue: 'SURF COFFEE',
    asset: 'assets/images/tasks/poet.png',
  ),
];
