class Event {
  final String title;
  final DateTime date;
  final Duration time;
  final String description;
  final String location;
  final List<String> attendees;
  Event({
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.location,
    required this.attendees,
  });
}