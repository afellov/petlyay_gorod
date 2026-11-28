import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:walk_city/core/theme/app_assets.dart';
import 'package:walk_city/core/widgets/custom_app_bar.dart';
import 'package:walk_city/core/theme/app_visuals.dart';
import 'package:walk_city/features/events/data/event_data.dart';

const _pink = AppVisuals.accent;
const _darkLegendSurface = Color(0xFF462134);
const _darkAddLegend = Color(0xFF5E223C);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onShowAllEvents});

  final VoidCallback? onShowAllEvents;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _legendExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppVisuals.of(context).page,
      body: Stack(
        children: [
          const AppPageBackground(),
          Column(
            children: [
              const CustomAppBar(title: 'ГЛАВНАЯ', showUnreadDot: true),
              Expanded(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(14, 24, 14, 118),
                        sliver: SliverList.list(
                          children: [
                            _LegendSection(
                              expanded: _legendExpanded,
                              onToggle: () => setState(
                                () => _legendExpanded = !_legendExpanded,
                              ),
                            ),
                            SizedBox(height: 12),
                            _ShareLegendBanner(),
                            SizedBox(height: 20),
                            _EventsSection(onShowAll: widget.onShowAllEvents),
                          ],
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

class _LegendSection extends StatelessWidget {
  const _LegendSection({required this.expanded, required this.onToggle});
  final bool expanded;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              'ЛЕГЕНДА ДНЯ',
              style: TextStyle(
                fontFamily: 'UNCAGE',
                fontSize: 18,
                color: AppVisuals.of(context).heading,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: AppVisuals.of(context).dark
                      ? _darkLegendSurface
                      : AppVisuals.of(context).reward,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'Сменится через: 12ч. 32мин.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _pink,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      _LegendCard(expanded: expanded, onToggle: onToggle),
    ],
  );
}

class _LegendCard extends StatelessWidget {
  const _LegendCard({required this.expanded, required this.onToggle});
  final bool expanded;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppVisuals.of(context).card,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(color: AppVisuals.of(context).shadow, blurRadius: 4),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Image.asset(
              'assets/images/home/event_1.png',
              width: double.infinity,
              height: 172,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -.35),
            ),
            Positioned(
              left: 12,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '@USERNAME',
                  style: TextStyle(
                    fontFamily: 'UNCAGE',
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(13, 9, 13, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Кузнецкая крепость',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppVisuals.of(context).heading,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedSize(
                duration: const Duration(milliseconds: 360),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: expanded
                    ? const _LegendDetails()
                    : Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          'Рассказываем, как деревянный острог превратился в каменный бастион и почему его пушки так и остались мирными...',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            height: 1.28,
                            color: AppVisuals.of(context).body,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (!expanded)
                    Expanded(
                      child: SizedBox(
                        height: 28,
                        child: ElevatedButton(
                          onPressed: onToggle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pink,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            elevation: 2,
                          ),
                          child: const Text(
                            'ЧИТАТЬ',
                            style: TextStyle(
                              fontFamily: 'Russo One',
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        onPressed: onToggle,
                        padding: EdgeInsets.zero,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF9DCE8),
                          foregroundColor: _pink,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 23,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  const _Metric(asset: AppAssets.heart, count: '15.6к'),
                  const SizedBox(width: 5),
                  const _Metric(asset: AppAssets.comment, count: '1200'),
                  const SizedBox(width: 5),
                  const _RoundAction(asset: AppAssets.share),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _LegendDetails extends StatelessWidget {
  const _LegendDetails();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppVisuals.of(context).reward,
            borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
            border: Border(left: BorderSide(color: _pink, width: 6)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              'Кузнецкая крепость — это жемчужина Новокузнецка, сохранившая дух прошлых эпох.',
              style: TextStyle(
                fontSize: 12,
                height: 1.2,
                color: AppVisuals.of(context).body,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        _LegendBullet(
          title: 'Исторические корни:',
          text:
              'Строили её в начале XIX века по приказу императора Александра I — не столько ради реальных боевых действий, сколько для укрепления южных рубежей империи. Крепость должна была внушать уважение, и со своей задачей справилась на ура.',
        ),
        SizedBox(height: 4),
        _LegendBullet(
          title: 'Главные экспонаты:',
          text:
              'На территории сохранился единственный в Кузбассе памятник военно-инженерного искусства того времени, а в самом отреставрированном здании штаб-офицерского дома сейчас работает музей с крутыми экспозициями об истории края.',
        ),
        SizedBox(height: 4),
        _LegendBullet(
          title: 'Видовые плюсы:',
          text:
              'Расположена она на Вознесенской горе, так что с высоты открывается шикарный панорамный вид на весь город и реку Томь. В ветреную погоду там особенно атмосферно — стоишь на бастионе, и ветер буквально выдувает все лишние мысли из головы.',
        ),
      ],
    ),
  );
}

class _LegendBullet extends StatelessWidget {
  const _LegendBullet({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•  ',
          style: TextStyle(
            fontSize: 12,
            height: 1.25,
            color: AppVisuals.of(context).body,
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 12,
                height: 1.25,
                color: AppVisuals.of(context).body,
              ),
              children: [
                TextSpan(text: '$title '),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.asset, required this.count});
  final String asset;
  final String count;
  @override
  Widget build(BuildContext context) => Container(
    height: 28,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: AppVisuals.of(context).dark
          ? _darkLegendSurface
          : AppVisuals.of(context).reward,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        SvgPicture.asset(asset, width: 15, height: 15),
        const SizedBox(width: 5),
        Text(
          count,
          style: TextStyle(
            fontSize: 9,
            color: AppVisuals.of(context).heading,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.asset});
  final String asset;
  @override
  Widget build(BuildContext context) => Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: AppVisuals.of(context).dark
          ? _darkLegendSurface
          : AppVisuals.of(context).reward,
      shape: BoxShape.circle,
    ),
    child: Center(child: SvgPicture.asset(asset, width: 16, height: 16)),
  );
}

class _ShareLegendBanner extends StatelessWidget {
  const _ShareLegendBanner();
  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: AppVisuals.of(context).dark
          ? _darkLegendSurface
          : AppVisuals.of(context).pill,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppVisuals.of(context).card,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              AppAssets.camera,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                AppVisuals.of(context).accentText,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Поделитесь своей легендой',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppVisuals.of(context).heading,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          decoration: BoxDecoration(
            color: AppVisuals.of(context).dark
                ? _darkAddLegend
                : const Color(0xFFE86A9A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Добавить легенду',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

class _EventsSection extends StatelessWidget {
  const _EventsSection({this.onShowAll});
  final VoidCallback? onShowAll;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              'АФИША',
              style: TextStyle(
                fontFamily: 'UNCAGE',
                fontSize: 18,
                color: AppVisuals.of(context).heading,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: onShowAll,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'Смотреть все ›',
                style: TextStyle(
                  color: _pink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .15,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 238,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _events.length,
          separatorBuilder: (_, _) => const SizedBox(width: 10),
          itemBuilder: (context, i) => _EventCard(event: _events[i]),
        ),
      ),
    ],
  );
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final EventData event;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 174,
    child: Container(
      decoration: BoxDecoration(
        color: AppVisuals.of(context).card,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: AppVisuals.of(context).shadow, blurRadius: 4),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                event.asset,
                width: 174,
                height: 132,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 8,
                top: 7,
                child: Container(
                  width: 42,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Column(
                    children: [
                      Text(
                        event.day,
                        style: const TextStyle(
                          color: _pink,
                          fontFamily: 'Russo One',
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        event.month,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                bottom: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9DCE8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    event.kind.toUpperCase(),
                    style: const TextStyle(
                      color: _pink,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 14, 8, 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.05,
                    fontWeight: FontWeight.w700,
                    color: AppVisuals.of(context).heading,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    SvgPicture.asset(AppAssets.mapPin, width: 13, height: 13),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        event.place,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 8,
                          color: AppVisuals.of(context).body,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

const _events = homeEvents;
