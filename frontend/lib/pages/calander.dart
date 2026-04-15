import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/event_model.dart';
import '../models/meeting_data_source.dart';



class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfCalendar(
          view: CalendarView.schedule,
          //dataSource: MeetingDataSource(_getDataSource()),
          //monthViewSettings: MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          showCurrentTimeIndicator: true,
          showDatePickerButton: true,
          showNavigationArrow: true,
          showTodayButton: true,
        )
    );
  }
}


// List of meetings/events, where api call needs to go
List<Event> _getDataSource() {
  final List<Event> events = <Event>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, 18, 11, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 7));
  events.add(Event(
    title: "Hyde Street 2026",
    price: "60.00",
    startTime: DateTime(2026, 4, 18, 11, 0, 0),
    endTime: DateTime(2026, 4, 18, 18, 0, 0),
    description: "Hyde Street Party is locked in for April 18th! OUSA has partnered with the local residents of Hyde Street to work closely and ensure that everybody has the best day, making it a safe and fun time for all.",
    location: "Hyde Street",
    imagePath: "lib/images/HydeStreet.jpg",
    color: const Color(0xFF0F8644),
    isAllDay: false,
    createdAt: DateTime(2026, 3, 18, 11, 0, 0),
    organiserId: 1
  ));
  return events;
}