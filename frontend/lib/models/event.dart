
class Event {
  final String title;
  final double price;
  final String date;
  final String time;
  final String description;
  final String location;
  final String imagePath;
  //final List<String> attendees;
  Event({
    required this.title,
    required this.price,
    required this.date,
    required this.time,
    required this.description,
    required this.location,
    required this.imagePath,
    //required this.attendees,
  });
}