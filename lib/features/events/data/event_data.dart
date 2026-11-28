class EventData {
  const EventData(
    this.asset,
    this.day,
    this.month,
    this.kind,
    this.title,
    this.place,
    this.description,
  );

  final String asset;
  final String day;
  final String month;
  final String kind;
  final String title;
  final String place;
  final String description;
}

const homeEvents = <EventData>[
  EventData(
    'assets/images/home/event_2.png',
    '24',
    'мая',
    'лекция',
    'История Сибири в деталях',
    'Краеведческий музей',
    'Исторические корни: Строили её в начале XIX века по приказу императора Александра I — не столько ради реальных боевых действий, сколько для укрепления южных рубежей империи. Крепость должна была внушать уважение, и со своей задачей справилась на ура.',
  ),
  EventData(
    'assets/images/home/event_1.png',
    '10',
    'апреля',
    'экскурсия',
    'Прогулка по Кузнецкой крепости',
    'Советская улица',
    'Прогулка по Кузнецкой крепости знакомит с историей города. На территории сохранился памятник военно-инженерного искусства, а с Вознесенской горы открывается вид на Новокузнецк и реку Томь.',
  ),
  EventData(
    'assets/images/home/event_2.png',
    '13',
    'января',
    'лекция',
    'История Сибири в деталях',
    'Краеведческий музей',
    'Исторические корни: Строили её в начале XIX века по приказу императора Александра I — не столько ради реальных боевых действий, сколько для укрепления южных рубежей империи. Крепость должна была внушать уважение, и со своей задачей справилась на ура.',
  ),
];

// The reference screen repeats its three current event cards in the list.
const allEvents = <EventData>[...homeEvents, ...homeEvents];
