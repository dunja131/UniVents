import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/services/event_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/pages/event.dart';

// ── Top-level helpers — accessible by all classes in this file ──

String _weekday(int w) =>
    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][w - 1];

String _monthAbbr(int m) => [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
][m - 1];

String _monthFull(int m) => [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
][m - 1];

// ── Category colours — shared by pill and accent bar ──
Map<String, Color> _categoryColors(String? category) {
  switch (category?.toLowerCase()) {
    case 'sports':
      return {
        'bg': const Color(0xFFFFF3E0),
        'text': const Color(0xFFE65100),
        'accent': const Color(0xFFE65100),
      };
    case 'social':
      return {
        'bg': const Color(0xFFF3E5F5),
        'text': const Color(0xFF6A1B9A),
        'accent': const Color(0xFF6A1B9A),
      };
    case 'academic':
      return {
        'bg': const Color(0xFFE3F2FD),
        'text': const Color(0xFF1565C0),
        'accent': const Color(0xFF1565C0),
      };
    case 'music':
      return {
        'bg': const Color(0xFFFCE4EC),
        'text': const Color(0xFFC62828),
        'accent': const Color(0xFFC62828),
      };
    case 'tech':
      return {
        'bg': const Color(0xFFE8F5E9),
        'text': const Color(0xFF2E7D32),
        'accent': const Color(0xFF2E7D32),
      };
    case 'arts':
      return {
        'bg': const Color(0xFFFFF8E1),
        'text': const Color(0xFFF57F17),
        'accent': const Color(0xFFF57F17),
      };
    case 'health':
      return {
        'bg': const Color(0xFFE0F2F1),
        'text': const Color(0xFF00695C),
        'accent': const Color(0xFF00695C),
      };
    case 'career':
      return {
        'bg': const Color(0xFFEDE7F6),
        'text': const Color(0xFF4527A0),
        'accent': const Color(0xFF4527A0),
      };
    default:
      return {
        'bg': const Color(0xFFF5F5F5),
        'text': const Color(0xFF616161),
        'accent': const Color(0xFF616161),
      };
  }
}

// ─────────────────────────────────────────────
// Calendar Page
// ─────────────────────────────────────────────

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
  DateTime?
  _selectedDay; // null = show all month events, non-null = filter to that day
  var isLoaded = false;
  var hasError = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      // Only loads events the user has RSVPd to
      final fetched = await EventService(widget.userService).getEventsByUser();
      setState(() {
        _allEvents = fetched;
        _eventsByDay = _groupEventsByDay(fetched);
        isLoaded = true;
      });
    } catch (e) {
      debugPrint('Error loading events: $e');
      setState(() => hasError = true);
    }
  }

  // Groups events by day so table_calendar can show dots
  Map<DateTime, List<Event>> _groupEventsByDay(List<Event> events) {
    Map<DateTime, List<Event>> data = {};
    for (final event in events) {
      // Loop through each day the event spans
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

  // Returns events for the currently focused month
  // If a day is selected, filters to just that day
  List<Event> get _visibleEvents {
    if (_selectedDay != null) {
      // Show only events for the selected day
      return _getEventsForDay(_selectedDay!);
    }
    // Show all user's RSVPd events in the focused month
    return _allEvents.where((event) {
        return event.startTime.year == _focusedDay.year &&
            event.startTime.month == _focusedDay.month;
      }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime)); // sort by date
  }

  // Label shown above the event list
  String get _listLabel {
    if (_selectedDay != null) {
      final d = _selectedDay!;
      return '${_weekday(d.weekday)}, ${d.day} ${_monthAbbr(d.month)}';
    }
    return '${_monthFull(_focusedDay.month)} ${_focusedDay.year}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: hasError
          ? const Center(child: Text('Failed to load events'))
          : !isLoaded
          ? Center(child: CircularProgressIndicator(color: cs.primary))
          : Column(
              children: [
                // ── Table Calendar ──
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cs.outlineVariant),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: TableCalendar<Event>(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      eventLoader: _getEventsForDay,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          // Tap same day again to deselect and show all month
                          if (isSameDay(_selectedDay, selectedDay)) {
                            _selectedDay = null;
                          } else {
                            _selectedDay = selectedDay;
                          }
                          _focusedDay = focusedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        // When month changes, clear selection and show new month
                        setState(() {
                          _focusedDay = focusedDay;
                          _selectedDay = null;
                        });
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        markersMaxCount: 0,
                        outsideDaysVisible: false,
                        markerSize: 6,
                        markersOffset: const PositionedOffset(bottom: 5),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          // Don't show dot on selected day because it clashes with the circle highlighting date
                          if (isSameDay(day, _selectedDay)) return null;
                          if (events.isEmpty) return null;
                          return Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: cs.primary,
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // ── Section label + show all button ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Row(
                    children: [
                      Text(
                        _listLabel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const Spacer(),
                      if (_selectedDay != null)
                        GestureDetector(
                          onTap: () => setState(() => _selectedDay = null),
                          child: Text(
                            'Show all',
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ── Event list ──
                Expanded(
                  child: _visibleEvents.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.event_outlined,
                                size: 48,
                                color: cs.onSurfaceVariant.withOpacity(0.4),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _selectedDay != null
                                    ? 'No events on this day'
                                    : 'No events this month',
                                style: TextStyle(
                                  color: cs.onSurfaceVariant,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: _visibleEvents.length,
                          itemBuilder: (context, index) {
                            final event = _visibleEvents[index];
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
                                // Refresh after returning in case user cancelled RSVP
                                getData();
                              },
                              child: _CalendarEventCard(event: event, cs: cs),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

// ─────────────────────────────────────────────
// Calendar event card
// ─────────────────────────────────────────────

class _CalendarEventCard extends StatelessWidget {
  final Event event;
  final ColorScheme cs;

  const _CalendarEventCard({required this.event, required this.cs});

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}';
    final dateStr =
        '${_weekday(event.startTime.weekday)}, ${event.startTime.day} ${_monthAbbr(event.startTime.month)}';

    // ── Use category colour for both the accent bar and the pill ──
    final colors = _categoryColors(event.category);
    final accentColor = colors['accent']!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Category-coloured left accent bar ──
          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              color: accentColor, // matches category pill colour
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // ── Event info ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + category pill
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (event.category != null) ...[
                        const SizedBox(width: 8),
                        // Category pill uses same colours as accent bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colors['bg'],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            event.category!.toLowerCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: colors['text'],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Date + time
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Location
                  if (event.location.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // ── Chevron ──
          Icon(
            Icons.chevron_right_rounded,
            color: cs.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
