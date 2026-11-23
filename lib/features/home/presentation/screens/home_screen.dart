import 'package:flutter/material.dart';

const _pink = Color(0xFFE5367A);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _legendExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Positioned.fill(child: IgnorePointer(child: Opacity(opacity: .22, child: Image.asset('assets/images/auth/bg_avatar.png', fit: BoxFit.cover)))),
        SafeArea(child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _HomeHeader()),
            SliverPadding(padding: const EdgeInsets.fromLTRB(14, 24, 14, 118), sliver: SliverList.list(children: [
              _LegendSection(expanded: _legendExpanded, onToggle: () => setState(() => _legendExpanded = !_legendExpanded)),
              SizedBox(height: 12),
              _ShareLegendBanner(),
              SizedBox(height: 20),
              _EventsSection(),
            ])),
          ],
        )),
      ]),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    height: 56,
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    child: Row(children: [
      IconButton(onPressed: null, padding: EdgeInsets.zero, constraints: const BoxConstraints.tightFor(width: 40, height: 44), icon: const Icon(Icons.dark_mode_outlined, color: Colors.black, size: 26)),
      const Expanded(child: Center(child: Text('ГЛАВНАЯ', style: TextStyle(fontFamily: 'UNCAGE', color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700)))),
      SizedBox(width: 40, height: 44, child: Stack(alignment: Alignment.center, children: [const Icon(Icons.notifications_none_outlined, color: Colors.black, size: 28), Positioned(top: 6, right: 6, child: Container(width: 9, height: 9, decoration: const BoxDecoration(color: _pink, shape: BoxShape.circle)))])),
    ]),
  );
}

class _LegendSection extends StatelessWidget {
  const _LegendSection({required this.expanded, required this.onToggle});
  final bool expanded;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(children: [
      const Expanded(child: Text('ЛЕГЕНДА ДНЯ', style: TextStyle(fontFamily: 'UNCAGE', fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700))),
      Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFF9DCE8), borderRadius: BorderRadius.circular(18)), child: const Text('Сменится через: 12ч. 32мин.', style: TextStyle(color: _pink, fontSize: 9, fontWeight: FontWeight.w700))),
    ]),
    const SizedBox(height: 10),
    _LegendCard(expanded: expanded, onToggle: onToggle),
  ]);
}

class _LegendCard extends StatelessWidget {
  const _LegendCard({required this.expanded, required this.onToggle});
  final bool expanded;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 2))]),
    clipBehavior: Clip.antiAlias,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Stack(children: [
        Image.asset('assets/images/home/event_1.png', width: double.infinity, height: 172, fit: BoxFit.cover, alignment: const Alignment(0, -.35)),
        Positioned(left: 12, bottom: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: const Text('@USERNAME', style: TextStyle(fontFamily: 'UNCAGE', fontSize: 8, fontWeight: FontWeight.w700)))),
      ]),
      Padding(padding: const EdgeInsets.fromLTRB(13, 9, 13, 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Кузнецкая крепость', style: TextStyle(fontFamily: 'Arial', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
        const SizedBox(height: 4),
        AnimatedSize(
          duration: const Duration(milliseconds: 360),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: expanded
              ? const _LegendDetails()
              : const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text('Рассказываем, как деревянный острог превратился в каменный бастион и почему его пушки так и остались мирными...', maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9, height: 1.28, color: Color(0xFF555555))),
                ),
        ),
        const SizedBox(height: 10),
        Row(children: [
          if (!expanded)
            Expanded(child: SizedBox(height: 28, child: ElevatedButton(onPressed: onToggle, style: ElevatedButton.styleFrom(backgroundColor: _pink, foregroundColor: Colors.white, padding: EdgeInsets.zero, elevation: 2), child: const Text('ЧИТАТЬ', style: TextStyle(fontFamily: 'Russo One', fontSize: 11)))))
          else
            SizedBox(width: 30, height: 30, child: IconButton(onPressed: onToggle, padding: EdgeInsets.zero, style: IconButton.styleFrom(backgroundColor: const Color(0xFFF9DCE8), foregroundColor: _pink), icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 23))),
          const SizedBox(width: 8),
          const _Metric(icon: Icons.favorite, count: '15.6к'), const SizedBox(width: 5),
          const _Metric(icon: Icons.chat_bubble, count: '1200'), const SizedBox(width: 5),
          _RoundAction(icon: Icons.reply_rounded),
        ]),
      ])),
    ]),
  );
}

class _LegendDetails extends StatelessWidget {
  const _LegendDetails();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(top: 8),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DecoratedBox(
        decoration: BoxDecoration(color: Color(0xFFF9DCE8), borderRadius: BorderRadius.horizontal(right: Radius.circular(10)), border: Border(left: BorderSide(color: _pink, width: 6))),
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Text('Кузнецкая крепость — это жемчужина Новокузнецка, сохранившая дух прошлых эпох.', style: TextStyle(fontSize: 12, height: 1.2, color: Color(0xFF444444)))),
      ),
      SizedBox(height: 12),
      _LegendBullet(title: 'Исторические корни:', text: 'Строили её в начале XIX века по приказу императора Александра I — не столько ради реальных боевых действий, сколько для укрепления южных рубежей империи. Крепость должна была внушать уважение, и со своей задачей справилась на ура.'),
      SizedBox(height: 4),
      _LegendBullet(title: 'Главные экспонаты:', text: 'На территории сохранился единственный в Кузбассе памятник военно-инженерного искусства того времени, а в самом отреставрированном здании штаб-офицерского дома сейчас работает музей с крутыми экспозициями об истории края.'),
      SizedBox(height: 4),
      _LegendBullet(title: 'Видовые плюсы:', text: 'Расположена она на Вознесенской горе, так что с высоты открывается шикарный панорамный вид на весь город и реку Томь. В ветреную погоду там особенно атмосферно — стоишь на бастионе, и ветер буквально выдувает все лишние мысли из головы.'),
    ]),
  );
}

class _LegendBullet extends StatelessWidget {
  const _LegendBullet({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('•  ', style: TextStyle(fontSize: 12, height: 1.25, color: Color(0xFF555555))),
      Expanded(child: Text.rich(TextSpan(style: const TextStyle(fontSize: 12, height: 1.25, color: Color(0xFF555555)), children: [TextSpan(text: '$title '), TextSpan(text: text)]))),
    ]),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.count});
  final IconData icon; final String count;
  @override
  Widget build(BuildContext context) => Container(height: 28, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(color: const Color(0xFFF9DCE8), borderRadius: BorderRadius.circular(18)), child: Row(children: [Icon(icon, color: _pink, size: 15), const SizedBox(width: 5), Text(count, style: const TextStyle(fontSize: 9, color: Color(0xFF39313A), fontWeight: FontWeight.w700))]));
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon}); final IconData icon;
  @override
  Widget build(BuildContext context) => Container(width: 28, height: 28, decoration: const BoxDecoration(color: Color(0xFFF9DCE8), shape: BoxShape.circle), child: Icon(icon, color: _pink, size: 16));
}

class _ShareLegendBanner extends StatelessWidget {
  const _ShareLegendBanner();
  @override
  Widget build(BuildContext context) => Container(height: 48, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(color: const Color(0xFFF9E4EC), borderRadius: BorderRadius.circular(28)), child: Row(children: [
    Container(width: 34, height: 34, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.camera_alt_outlined, color: _pink, size: 19)),
    const SizedBox(width: 10), const Expanded(child: Text('Поделитесь своей легендой', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF54464D)))),
    Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7), decoration: BoxDecoration(color: const Color(0xFFE86A9A), borderRadius: BorderRadius.circular(20)), child: const Text('Добавить легенду', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700))),
  ]));
}

class _EventsSection extends StatelessWidget {
  const _EventsSection();
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(children: [const Expanded(child: Text('АФИША', style: TextStyle(fontFamily: 'UNCAGE', fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700))), const Text('Смотреть все ›', style: TextStyle(color: _pink, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: .15))]),
    const SizedBox(height: 10),
    SizedBox(height: 238, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: _events.length, separatorBuilder: (_, _) => const SizedBox(width: 10), itemBuilder: (context, i) => _EventCard(event: _events[i]))),
  ]);
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final _Event event;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 174,
    child: Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 5, offset: Offset(0, 1))]),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(clipBehavior: Clip.none, children: [
          Image.asset(event.asset, width: 174, height: 132, fit: BoxFit.cover),
          Positioned(left: 8, top: 7, child: Container(width: 42, padding: const EdgeInsets.symmetric(vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9)), child: Column(children: [Text(event.day, style: const TextStyle(color: _pink, fontFamily: 'Russo One', fontSize: 18)), Text(event.month, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700))]))),
          Positioned(left: 10, bottom: -10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFF9DCE8), borderRadius: BorderRadius.circular(12)), child: Text(event.kind.toUpperCase(), style: const TextStyle(color: _pink, fontSize: 8, fontWeight: FontWeight.w700)))),
        ]),
        Padding(padding: const EdgeInsets.fromLTRB(10, 14, 8, 7), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, height: 1.05, fontWeight: FontWeight.w700, color: Colors.black)),
          const SizedBox(height: 5),
          Row(children: [const Icon(Icons.location_on, size: 13, color: _pink), const SizedBox(width: 3), Expanded(child: Text(event.place, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8, color: Colors.black)))]),
        ])),
      ]),
    ),
  );
}

class _Event { const _Event(this.asset, this.day, this.month, this.kind, this.title, this.place); final String asset, day, month, kind, title, place; }
const _events = <_Event>[
  _Event('assets/images/home/event_2.png', '24', 'мая', 'лекция', 'История Сибири в деталях', 'Краеведческий музей'),
  _Event('assets/images/home/event_1.png', '10', 'апреля', 'экскурсия', 'Прогулка по Кузнецкой крепости', 'Советская улица'),
  _Event('assets/images/home/event_2.png', '13', 'января', 'лекция', 'История Сибири в деталях', 'Краеведческий музей'),
];
