import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/services/event_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/pages/event.dart';

class CalendarPage extends StatefulWidget {
  final UserService userService;
  const CalendarPage({super.key, required this.userService});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Event> _allEvents = [];
  Map<DateTime, List<Event>> _eventsByDay = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  var isLoaded = false;
  var hasError = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    getData();
  }

  Future<void> getData() async {
    try {
      final fetched = await EventService(widget.userService).getEventsByUser();
      if (fetched != null) {
        setState(() {
          _allEvents = fetched;
          _eventsByDay = _groupEventsByDay(fetched);
          isLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading events: $e');
      setState(() => hasError = true);
    }
  }

  // groups events by day so table_calendar can show dots
  Map<DateTime, List<Event>> _groupEventsByDay(List<Event> events) {
    Map<DateTime, List<Event>> data = {};
    for (final event in events) {
      // loop through each day the event spans
      DateTime day = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      final endDay = DateTime(
        event.endTime.year,
        event.endTime.month,
        event.endTime.day,
      );
      while (!day.isAfter(endDay)) {
        data[day] = [...(data[day] ?? []), event];
        day = day.add(const Duration(days: 1));
      }
    }
    return data;
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _eventsByDay[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: hasError
          ? const Center(child: Text('Failed to load events'))
          : !isLoaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ── Table Calendar wrapped in white card ──
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    // clips the calendar to match rounded corners
                    borderRadius: BorderRadius.circular(20),
                    // ── Table Calendar ──
                    child: TableCalendar<Event>(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      eventLoader: _getEventsForDay,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),

                        todayTextStyle: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),

                        selectedDecoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),

                        markersOffset: const PositionedOffset(bottom: 5),

                        markerDecoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        markersMaxCount: 3,
                        outsideDaysVisible: false,
                        markersAutoAligned: true,
                        markerSize: 6,
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),

                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          if (isSameDay(day, _selectedDay))
                            return const SizedBox.shrink();
                          if (events.isEmpty) return const SizedBox.shrink();
                          return Positioned(
                            bottom: 4,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // ── Event list for selected day ──
                Expanded(
                  child: _getEventsForDay(_selectedDay!).isEmpty
                      ? Center(
                          child: Text(
                            'No events for this day',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _getEventsForDay(_selectedDay!).length,
                          itemBuilder: (context, index) {
                            final event = _getEventsForDay(
                              _selectedDay!,
                            )[index];
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventPage(
                                      event: event,
                                      userService: widget.userService,
                                    ),
                                  ),
                                );
                                getData(); //to refresh calendar if user cancels rsvp - it can refresh
                              },

                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.title,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: colorScheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')} · ${event.location}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
