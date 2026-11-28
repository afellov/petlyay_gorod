import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:walk_city/core/theme/app_assets.dart';
import 'package:walk_city/core/theme/app_visuals.dart';
import 'package:walk_city/core/widgets/custom_app_bar.dart';
import 'package:walk_city/features/events/data/event_data.dart';

const _darkFilterFill = Color(0xFF4D2639);

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final scale = ((width - 32) / 408).clamp(.78, 1.1);

    return Scaffold(
      backgroundColor: AppVisuals.of(context).page,
      body: Stack(
        children: [
          const AppPageBackground(),
          Column(
            children: [
              const CustomAppBar(title: 'АФИША'),
              Expanded(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          16 * scale,
                          8,
                          16 * scale,
                          0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _BackButton(onPressed: onBack),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          16 * scale,
                          16,
                          16 * scale,
                          10,
                        ),
                        child: _EventFilters(scale: scale),
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                            16 * scale,
                            0,
                            16 * scale,
                            118,
                          ),
                          itemCount: allEvents.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(height: 8 * scale),
                          itemBuilder: (context, index) => _EventListCard(
                            event: allEvents[index],
                            scale: scale,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: AppVisuals.of(context).card,
    elevation: 1,
    borderRadius: BorderRadius.circular(7),
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(7),
      child: SizedBox(
        width: 30,
        height: 30,
        child: Icon(
          Icons.chevron_left,
          size: 26,
          color: AppVisuals.of(context).heading,
        ),
      ),
    ),
  );
}

class _EventFilters extends StatelessWidget {
  const _EventFilters({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      _FilterIcon(icon: AppAssets.search, scale: scale),
      SizedBox(width: 12 * scale),
      _FilterIcon(icon: AppAssets.filter, scale: scale, selected: true),
      SizedBox(width: 12 * scale),
      SizedBox(
        width: 88 * scale,
        child: _FilterPill(
          scale: scale,
          height: 32,
          selected: true,
          child: Text(
            'Рядом',
            maxLines: 1,
            style: TextStyle(
              color: AppVisuals.accent,
              fontSize: 12 * scale,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      SizedBox(width: 12 * scale),
      Expanded(
        flex: 2,
        child: _FilterPill(
          scale: scale,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Выбрать дату',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppVisuals.of(context).heading,
                    fontSize: 12 * scale,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down, size: 17 * scale),
            ],
          ),
        ),
      ),
      SizedBox(width: 15 * scale),
    ],
  );
}

class _FilterIcon extends StatelessWidget {
  const _FilterIcon({
    required this.icon,
    required this.scale,
    this.selected = false,
  });

  final String icon;
  final double scale;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final visuals = AppVisuals.of(context);
    return Container(
      width: 42 * scale,
      height: 36 * scale,
      decoration: BoxDecoration(
        color: selected
            ? visuals.dark
                  ? _darkFilterFill.withValues(alpha: .7)
                  : visuals.pill
            : visuals.card,
        borderRadius: BorderRadius.circular(10 * scale),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        icon,
        width: 18 * scale,
        height: 18 * scale,
        colorFilter: ColorFilter.mode(
          selected ? AppVisuals.accent : visuals.heading,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.scale,
    required this.child,
    this.height = 36,
    this.selected = false,
  });

  final double scale;
  final Widget child;
  final double height;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final visuals = AppVisuals.of(context);
    return Container(
      height: height * scale,
      padding: EdgeInsets.symmetric(horizontal: 9 * scale),
      decoration: BoxDecoration(
        color: selected
            ? visuals.dark
                  ? _darkFilterFill.withValues(alpha: .7)
                  : visuals.pill
            : visuals.card,
        borderRadius: BorderRadius.circular(10 * scale),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _EventListCard extends StatelessWidget {
  const _EventListCard({required this.event, required this.scale});

  final EventData event;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final visuals = AppVisuals.of(context);
    final imageWidth = (MediaQuery.sizeOf(context).width - 32) * .42;
    const cardHeight = 98.0;

    return Container(
      height: cardHeight,
      padding: EdgeInsets.fromLTRB(
        5 * scale,
        6.5 * scale,
        12 * scale,
        6.5 * scale,
      ),
      decoration: BoxDecoration(
        color: visuals.card,
        borderRadius: BorderRadius.circular(16 * scale),
      ),
      child: Row(
        children: [
          SizedBox(
            width: imageWidth,
            height: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11 * scale),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(event.asset, fit: BoxFit.cover),
                  Positioned(
                    left: 5 * scale,
                    top: 4 * scale,
                    child: _DateBadge(event: event, scale: scale),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 9 * scale),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EventKind(event: event, scale: scale),
                  SizedBox(height: 6 * scale),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: visuals.heading,
                          fontSize: 15 * scale,
                          height: 1.05,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.mapPin,
                        width: 11 * scale,
                        height: 11 * scale,
                      ),
                      SizedBox(width: 4 * scale),
                      Expanded(
                        child: Text(
                          event.place,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: visuals.heading,
                            fontSize: 7.5 * scale,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 5 * scale),
          Container(
            width: 24 * scale,
            height: 24 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: visuals.dark
                  ? _darkFilterFill.withValues(alpha: .7)
                  : visuals.pill,
              border: Border.all(color: AppVisuals.accent, width: .5 * scale),
            ),
            child: Icon(
              Icons.chevron_right,
              size: 14 * scale,
              color: AppVisuals.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.event, required this.scale});

  final EventData event;
  final double scale;

  @override
  Widget build(BuildContext context) => Container(
    width: 36 * scale,
    padding: EdgeInsets.symmetric(vertical: 2 * scale),
    decoration: BoxDecoration(
      color: AppVisuals.of(context).card,
      borderRadius: BorderRadius.circular(7 * scale),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          event.day,
          style: TextStyle(
            color: AppVisuals.accent,
            fontFamily: 'Russo One',
            fontSize: 15 * scale,
            height: 1,
          ),
        ),
        Text(
          event.month,
          style: TextStyle(
            color: AppVisuals.of(context).heading,
            fontSize: 8 * scale,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
      ],
    ),
  );
}

class _EventKind extends StatelessWidget {
  const _EventKind({required this.event, required this.scale});

  final EventData event;
  final double scale;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 6 * scale, vertical: 2 * scale),
    decoration: BoxDecoration(
      color: AppVisuals.of(context).dark
          ? _darkFilterFill.withValues(alpha: .7)
          : AppVisuals.of(context).pill,
      borderRadius: BorderRadius.circular(10 * scale),
    ),
    child: Text(
      event.kind,
      style: TextStyle(
        color: AppVisuals.accent,
        fontSize: 8 * scale,
        height: 1,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
