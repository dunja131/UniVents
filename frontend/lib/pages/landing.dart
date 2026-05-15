import 'package:flutter/material.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/services/event_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:frontend/pages/event.dart';

class LandingPage extends StatefulWidget {
  final UserService userService;
  const LandingPage({super.key, required this.userService});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Event>? events;
  List<Event> _allEvents = [];
  var isLoaded = false;
  var hasError = false;

  int _selectedFilter =
      0; //variable to keep track of the list category positions
  final List<String> _filters = ['All', 'Music', 'Sports', 'Social', 'Free'];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final fetched = await EventService(widget.userService).getEvents();
      if (fetched != null) {
        setState(() {
          _allEvents = fetched;
          events = fetched;
          isLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading events: $e');
      setState(() => hasError = true);
    }
  }

  void _applyFilters() {
    setState(() {
      // it redraws the screen
      events = _allEvents.where((event) {
        //goes through the entire list of events
        final selectedFilter =
            _filters[_selectedFilter]; // this fetches what category the user has selected
        return selectedFilter == 'All' ||
            (selectedFilter == 'Free' && event.price == 0) ||
            event.category?.toLowerCase() ==
                selectedFilter
                    .toLowerCase(); // checks if the event category matches the selected chip, case-insensitive so "Sports" and "sports" both match
      }).toList(); //turns the filtered category of events into a list that flutter that can rebuild and re-present it to the user on the landing page
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Search bar ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) async {
                if (value.isEmpty) {
                  setState(() => events = _allEvents);
                } else {
                  final results = await EventService(
                    widget.userService,
                  ).searchEvents(value);
                  setState(() => events = results ?? []);
                }
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                hintText: 'Search events...',
                hintStyle: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 15,
                ),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),

        // ── Filter chips ────────────────────────────────────────
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedFilter == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedFilter = index);
                    _applyFilters();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Upcoming Events header ──────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              // Text(
              //   'See all',
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w600,
              //     color: Colors.grey.shade400,
              //   ),
              // ),
            ],
          ),
        ),

        // ── Event list ──────────────────────────────────────────
        Expanded(
          child: isLoaded
              ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: events!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventPage(
                            event: events![index],
                            userService: widget.userService,
                          ),
                        ),
                      ),
                      child: _EventCard(
                        event: events![index],
                        userService: widget.userService,
                      ),
                    );
                  },
                )
              : hasError
              ? const Center(child: Text('Failed to fetch events :('))
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

// ── Event card with plain banner + icon ────────────────────
class _EventCard extends StatelessWidget {
  final Event event;
  final UserService userService;

  const _EventCard({required this.event, required this.userService});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: Icon(
                    Icons.event_rounded, //event icon for all events
                    size: 64,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                  ),
                ),
              ),
              // date badge
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _monthAbbr(event.startTime),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        _day(event.startTime),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // event details
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title ?? 'Untitled Event',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (event.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    event.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                     color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.attach_money_rounded,
                      size: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    Text(
                      event.price == 0
                          ? 'Free'
                          : '${event.price?.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _monthAbbr(DateTime date) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[date.month - 1];
  }

  String _day(DateTime date) {
    return date.day.toString();
  }
}
