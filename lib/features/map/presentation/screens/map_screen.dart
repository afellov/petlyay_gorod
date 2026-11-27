import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:walk_city/core/theme/app_assets.dart';
import 'package:walk_city/core/theme/app_visuals.dart';
import 'package:walk_city/core/widgets/custom_app_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  late final AnimationController _zoomAnimation;
  Animation<double>? _zoomTween;
  LatLng? _zoomCenter;
  String _selectedCategory = 'ЗАДАНИЯ';

  @override
  void initState() {
    super.initState();
    _zoomAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..addListener(_applyZoomFrame);
  }

  void _applyZoomFrame() {
    final zoom = _zoomTween;
    final center = _zoomCenter;
    if (zoom == null || center == null) return;
    _mapController.move(center, zoom.value);
  }

  void _changeZoom(double delta) {
    final camera = _mapController.camera;
    final targetZoom = (camera.zoom + delta).clamp(4.0, 18.0);
    if (targetZoom == camera.zoom) return;

    _zoomAnimation.stop();
    _zoomCenter = camera.center;
    _zoomTween = Tween<double>(begin: camera.zoom, end: targetZoom).animate(
      CurvedAnimation(parent: _zoomAnimation, curve: Curves.easeOutCubic),
    );
    _zoomAnimation.forward(from: 0);
  }

  @override
  void dispose() {
    _zoomAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visuals = AppVisuals.of(context);

    return Scaffold(
      body: Column(
        children: [
          const CustomAppBar(title: 'КАРТА'),
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: const MapOptions(
                        initialCenter: LatLng(53.7596, 87.1216),
                        initialZoom: 12,
                        minZoom: 4,
                        maxZoom: 18,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'ru.gulyai_gorod.app',
                          tileBuilder: visuals.dark
                              ? darkModeTileBuilder
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 16,
                    right: 16,
                    child: _MapToolbar(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) =>
                          setState(() => _selectedCategory = category),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ZoomButton(
                            icon: Icons.add_rounded,
                            label: 'Увеличить масштаб карты',
                            onPressed: () => _changeZoom(1),
                          ),
                          const SizedBox(height: 10),
                          _ZoomButton(
                            icon: Icons.remove_rounded,
                            label: 'Уменьшить масштаб карты',
                            onPressed: () => _changeZoom(-1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapToolbar extends StatelessWidget {
  const _MapToolbar({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      _MapIconTool(asset: AppAssets.search, label: 'Поиск'),
      const SizedBox(width: 8),
      _MapIconTool(asset: AppAssets.filter, label: 'Фильтры'),
      const SizedBox(width: 8),
      Expanded(
        child: _MapCategoryTool(
          label: 'ЗАДАНИЯ',
          selected: selectedCategory == 'ЗАДАНИЯ',
          onTap: () => onCategorySelected('ЗАДАНИЯ'),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _MapCategoryTool(
          label: 'ПАРТНЁРЫ',
          selected: selectedCategory == 'ПАРТНЁРЫ',
          onTap: () => onCategorySelected('ПАРТНЁРЫ'),
        ),
      ),
    ],
  );
}

class _MapIconTool extends StatelessWidget {
  const _MapIconTool({required this.asset, required this.label});

  final String asset;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: label,
      child: Container(
        width: 44,
        height: 40,
        alignment: Alignment.center,
        decoration: _toolDecoration(context, selected: false),
        child: SvgPicture.asset(
          asset,
          width: 22,
          height: 22,
          colorFilter: ColorFilter.mode(
            theme.colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class _MapCategoryTool extends StatelessWidget {
  const _MapCategoryTool({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visuals = AppVisuals.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: _toolDecoration(context, selected: selected),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected
                  ? visuals.accentText
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    shape: const CircleBorder(),
    elevation: 3,
    shadowColor: Colors.black.withValues(alpha: .25),
    child: IconButton(
      tooltip: label,
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      constraints: const BoxConstraints.tightFor(width: 44, height: 44),
      padding: EdgeInsets.zero,
    ),
  );
}

BoxDecoration _toolDecoration(BuildContext context, {required bool selected}) {
  final visuals = AppVisuals.of(context);
  final theme = Theme.of(context);
  return BoxDecoration(
    color: selected ? visuals.pill : visuals.card,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: theme.colorScheme.onSurface.withValues(alpha: .1),
    ),
    boxShadow: [BoxShadow(color: visuals.shadow, blurRadius: 4)],
  );
}
