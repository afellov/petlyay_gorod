class EventData {
  const EventData(
    this.asset,
    this.day,
    this.month,
    this.kind,
    this.title,
    this.place,
  );

  final String asset;
  final String day;
  final String month;
  final String kind;
  final String title;
  final String place;
}

const homeEvents = <EventData>[
  EventData(
    'assets/images/home/event_2.png',
    '24',
    'мая',
    'лекция',
    'История Сибири в деталях',
    'Краеведческий музей',
  ),
  EventData(
    'assets/images/home/event_1.png',
    '10',
    'апреля',
    'экскурсия',
    'Прогулка по Кузнецкой крепости',
    'Советская улица',
  ),
  EventData(
    'assets/images/home/event_2.png',
    '13',
    'января',
    'лекция',
    'История Сибири в деталях',
    'Краеведческий музей',
  ),
];

// The reference screen repeats its three current event cards in the list.
const allEvents = <EventData>[...homeEvents, ...homeEvents];
