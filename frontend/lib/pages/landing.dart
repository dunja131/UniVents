import 'package:flutter/material.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/services/event_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/pages/event.dart';
import 'package:google_fonts/google_fonts.dart';

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
      0; // variable to keep track of the list category positions
  final List<String> _filters = [
    'All',
    'Academic',
    'Social',
    'Sports',
    'Music',
    'Tech',
    'Arts',
    'Health',
    'Career',
    'Free',
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final fetched = await EventService(widget.userService).getEvents();
      debugPrint('Fetched ${fetched?.length} events');
      if (fetched != null) {
        setState(() {
          _allEvents = fetched;
          events = fetched;
          isLoaded = true;
        });
      } else {
        setState(() {
          _allEvents = [];
          events = [];
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
        // goes through the entire list of events
        final selectedFilter =
            _filters[_selectedFilter]; // this fetches what category the user has selected
        return selectedFilter == 'All' ||
            (selectedFilter == 'Free' && event.price == 0) ||
            event.category?.toLowerCase() ==
                selectedFilter
                    .toLowerCase(); // checks if the event category matches the selected chip, case-insensitive so "Sports" and "sports" both match
      }).toList(); // turns the filtered category of events into a list that flutter can rebuild and re-present it to the user on the landing page
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Discover Events header ──────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover Events',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Find what\'s happening on campus',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // ── Search bar ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(15),
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

        //  Filter chips ────────────────────────────────────────
        ShaderMask(
  shaderCallback: (bounds) => LinearGradient(
    colors: [
      Colors.transparent,
      Colors.white,
      Colors.white,
      Colors.transparent,
    ],
    stops: const [0.0, 0.05, 0.95, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ).createShader(bounds),
  blendMode: BlendMode.dstIn,
  child: SizedBox(
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
        ),
        // ── Event list ──────────────────────────────────────────
        Expanded(
          child: isLoaded
              ? ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
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

// ── Event card ─────────────────────────────────────────────
class _EventCard extends StatelessWidget {
  final Event event;
  final UserService userService;

  const _EventCard({required this.event, required this.userService});
  

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isFree =
        event.price == null || event.price == 0 || event.price == 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image placeholder with category icon ──
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  color: cs.primaryContainer,
                  child: Center(
                    child: Icon(
                      _categoryIcon(event.category), // category-specific icon
                      size: 52,
                      color: cs.onPrimaryContainer.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ),

              // ── Date badge — bottom left ──
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _monthAbbr(event.startTime),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        _day(event.startTime),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Event details ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title + category pill ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        event.title ?? 'Untitled Event',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (event.category != null) ...[
                      const SizedBox(width: 8),
                      _CategoryPill(category: event.category!),
                    ],
                  ],
                ),

                // ── Description preview ──
                if (event.description != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    event.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 12),

                // ── Meta row — location · time · price ──
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // ── Price badge ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isFree
                            ? cs.primaryContainer
                            : const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isFree
                            ? 'Free'
                            : '\$${event.price?.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isFree
                              ? cs.onPrimaryContainer
                              : const Color(0xFF856404),
                        ),
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

  // ── Category-specific icon — matches organiser dashboard ──
  IconData _categoryIcon(String? cat) {
    switch (cat?.toLowerCase()) {
      case 'sports':
        return Icons.sports_basketball_rounded;
      case 'music':
        return Icons.music_note_rounded;
      case 'academic':
        return Icons.school_rounded;
      case 'tech':
        return Icons.computer_rounded;
      case 'arts':
        return Icons.palette_rounded;
      case 'social':
        return Icons.people_rounded;
      case 'health':
        return Icons.favorite_rounded;
      case 'career':
        return Icons.work_rounded;
      default:
        return Icons.event_rounded;
    }
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

  String _day(DateTime date) => date.day.toString();
}

// ── Category pill
class _CategoryPill extends StatelessWidget {
  final String category;
  const _CategoryPill({required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = _colors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors['bg'],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.toLowerCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colors['text'],
        ),
      ),
    );
  }

  Map<String, Color> _colors() {
    switch (category.toLowerCase()) {
      case 'sports':
        return {'bg': const Color(0xFFFFF3E0), 'text': const Color(0xFFE65100)};
      case 'social':
        return {'bg': const Color(0xFFF3E5F5), 'text': const Color(0xFF6A1B9A)};
      case 'academic':
        return {'bg': const Color(0xFFE3F2FD), 'text': const Color(0xFF1565C0)};
      case 'music':
        return {'bg': const Color(0xFFFCE4EC), 'text': const Color(0xFFC62828)};
      case 'tech':
        return {'bg': const Color(0xFFE8F5E9), 'text': const Color(0xFF2E7D32)};
      case 'arts':
        return {'bg': const Color(0xFFFFF8E1), 'text': const Color(0xFFF57F17)};
      case 'health':
        return {'bg': const Color(0xFFE0F2F1), 'text': const Color(0xFF00695C)};
      case 'career':
        return {'bg': const Color(0xFFEDE7F6), 'text': const Color(0xFF4527A0)};
      default:
        return {'bg': const Color(0xFFF5F5F5), 'text': const Color(0xFF616161)};
    }
  }
}
