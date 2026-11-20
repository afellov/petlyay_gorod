import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:walk_city/core/widgets/custom_app_bar.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: CustomAppBar(title: 'КАРТА'),
            ),
            Expanded(
              child: FlutterMap(
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
                  ),
                  SimpleAttributionWidget(
                    source: const Text('OpenStreetMap contributors'),
                    alignment: Alignment.bottomRight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
