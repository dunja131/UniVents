import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:frontend/services/event_service.dart';
import 'package:frontend/models/calender_data_source.dart';
import '../models/event_model.dart';
import '../pages/event.dart';



class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  List<Event>? events;
  var isLoaded = false;
  var hasError = false;

  @override
  void initState() {
    super.initState();
    // fetch data from api
    getData();
  }

  Future<void> getData() async {
    try {
      events = await EventService().getEvents();
      if (events != null) {
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading events: $e');
      setState(() {
        hasError = true;   // triggers UI update
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: hasError
      ? const Center(child: Text('Failed to load events'))
      : !isLoaded
        ? const Center(child: CircularProgressIndicator())
        : SfCalendar(
            view: CalendarView.schedule,
            dataSource: CalenderDataSource(events!),
            showCurrentTimeIndicator: true,
            showDatePickerButton: true,
            showNavigationArrow: true,
            showTodayButton: true,
            onTap: (CalendarTapDetails details) {
              // navigate to event page
              if (details.appointments != null && details.appointments!.isNotEmpty) {
                final event = details.appointments!.first as Event;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventPage(event: event),
                  ),
                );
              }
            },
          ),
    );
  }
}