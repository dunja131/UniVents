import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/pages/createEvent.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/home_page.dart';

class OrganiserDashboardScreen extends StatefulWidget {
  final UserService userService;

  const OrganiserDashboardScreen({super.key, required this.userService});

  @override
  State<OrganiserDashboardScreen> createState() =>
      _OrganiserDashboardScreenState();
}

class _OrganiserDashboardScreenState extends State<OrganiserDashboardScreen> {
  static const String _baseUrl = 'http://localhost:8080';

  List<dynamic> _events = [];
  bool _isLoading = true;
  String? _error;
  bool _showUpcoming = true;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadMyEvents();
  }

  Future<void> _loadMyEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/events/my'),
        headers: {'Authorization': widget.userService.authHeader},
      );
      debugPrint('Events status: ${response.statusCode}');
      debugPrint('Events body: ${response.body}');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          _events = decoded is List ? decoded : [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load events (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEvent(int eventId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/events/$eventId'),
        headers: {'Authorization': widget.userService.authHeader},
      );
      if (response.statusCode == 204) {
        _loadMyEvents();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Event deleted.')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }

  List<dynamic> get _upcomingEvents {
    final now = DateTime.now();
    return _events.where((e) {
      final start = DateTime.tryParse(e['startTime'] ?? '');
      return start != null && start.isAfter(now);
    }).toList();
  }

  List<dynamic> get _pastEvents {
    final now = DateTime.now();
    return _events.where((e) {
      final start = DateTime.tryParse(e['startTime'] ?? '');
      return start != null && start.isBefore(now);
    }).toList();
  }

  int get _totalRsvps =>
      _events.fold(0, (sum, e) => sum + ((e['rsvpCount'] ?? 0) as int));

  List<dynamic> get _tabEvents => _showUpcoming ? _upcomingEvents : _pastEvents;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: cs.surface,

      // Bottom navigation bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0, // always 0, Dashboard is always the active tab
        onDestinationSelected: (index) {
          if (index == 1) {
            _openCreateEvent(); // just opens the screen, don't change index
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            label: 'Create Event',
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Simplified top header
            _buildTopHeader(cs),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadMyEvents,
                color: cs.primary,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: cs.primary),
                      )
                    : _error != null
                    ? _buildError(cs)
                    : _buildBody(cs, theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(bottom: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(Icons.school_rounded, color: cs.onPrimary, size: 18),
          ),
          const SizedBox(width: 8),
          Text(
            'UniVents',
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          // Organiser badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cs.primary.withOpacity(0.3)),
            ),
            child: Text(
              'Organiser',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: cs.onPrimaryContainer,
              ),
            ),
          ),
          const Spacer(),
          // Logout
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: cs.onSurfaceVariant,
              size: 20,
            ),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Theme.of(ctx).colorScheme.surface,
                  title: const Text('Log Out'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Log Out'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && mounted) {
                widget.userService.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
              }
            },
            tooltip: 'Log out',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme cs, ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      children: [
        // Page header
        Text(
          'Dashboard',
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Manage your events',
          style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
        ),

        const SizedBox(height: 28),

        // Stat cards
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth > 500 ? 4 : 2;
            return GridView.count(
              crossAxisCount: cols,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _StatCard(
                  icon: Icons.event_rounded,
                  label: 'Total Events',
                  value: '${_events.length}',
                  cs: cs,
                ),
                _StatCard(
                  icon: Icons.trending_up_rounded,
                  label: 'Upcoming',
                  value: '${_upcomingEvents.length}',
                  cs: cs,
                ),
                _StatCard(
                  icon: Icons.people_outline_rounded,
                  label: 'Total RSVPs',
                  value: '$_totalRsvps',
                  cs: cs,
                ),
                _StatCard(
                  icon: Icons.history_rounded,
                  label: 'Past Events',
                  value: '${_pastEvents.length}',
                  cs: cs,
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 28),

        // ── Tab switcher ──
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: cs.outlineVariant),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _TabPill(
                label: 'Upcoming (${_upcomingEvents.length})',
                active: _showUpcoming,
                cs: cs,
                onTap: () => setState(() => _showUpcoming = true),
              ),
              _TabPill(
                label: 'Past (${_pastEvents.length})',
                active: !_showUpcoming,
                cs: cs,
                onTap: () => setState(() => _showUpcoming = false),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Event list
        if (_tabEvents.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
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
                    _showUpcoming ? 'No upcoming events' : 'No past events',
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap Create Event below to get started.',
                    style: TextStyle(
                      color: cs.onSurfaceVariant.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...List.generate(_tabEvents.length, (i) {
            final event = _tabEvents[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _EventCard(
                event: event,
                cs: cs,
                theme: theme,
                onEdit: () => _openEditEvent(event),
                onDelete: () async {
                  final confirmed = await _confirmDelete(event['eventName']);
                  if (confirmed == true) _deleteEvent(event['eventId']);
                },
              ),
            );
          }),
      ],
    );
  }

  Widget _buildError(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 48, color: cs.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(_error!, style: TextStyle(color: cs.onSurfaceVariant)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _loadMyEvents,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
            style: OutlinedButton.styleFrom(foregroundColor: cs.primary),
          ),
        ],
      ),
    );
  }

  void _openCreateEvent() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateEventScreen(userService: widget.userService),
      ),
    );
    if (created == true) _loadMyEvents();
  }

  void _openEditEvent(dynamic event) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateEventScreen(
          userService: widget.userService,
          existingEvent: event,
        ),
      ),
    );
    if (updated == true) _loadMyEvents();
  }

  Future<bool?> _confirmDelete(String? name) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text(
          'Delete "${name ?? 'this event'}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Stat card
// ─────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: cs.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Tab pill
// ─────────────────────────────────────────────

class _TabPill extends StatelessWidget {
  final String label;
  final bool active;
  final ColorScheme cs;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.active,
    required this.cs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? cs.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Event card
// ─────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final dynamic event;
  final ColorScheme cs;
  final ThemeData theme;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EventCard({
    required this.event,
    required this.cs,
    required this.theme,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final startTime = DateTime.tryParse(event['startTime'] ?? '');
    final category = event['category'] as String?;
    final rsvpCount =
        event['rsvpCount'] ?? (event['rsvps'] as List?)?.length ?? 0;
    final price = event['price'];
    final isFree = price == null || price == 0 || price == 0.0;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image placeholder ──
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 130,
              width: double.infinity,
              color: cs.primaryContainer,
              child: Center(
                child: Icon(
                  _categoryIcon(category),
                  size: 44,
                  color: cs.onPrimaryContainer.withOpacity(0.4),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + category pill
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        event['eventName'] ?? 'Untitled',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    if (category != null) ...[
                      const SizedBox(width: 8),
                      _CategoryPill(category: category),
                    ],
                  ],
                ),

                if (event['description'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    event['description'],
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

                // Meta info
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    if (startTime != null) ...[
                      _Meta(
                        icon: Icons.calendar_today_rounded,
                        label:
                            '${_mon(startTime.month)} ${startTime.day}, ${startTime.year}',
                        cs: cs,
                      ),
                      _Meta(
                        icon: Icons.access_time_rounded,
                        label: _time(startTime),
                        cs: cs,
                      ),
                    ],
                    if (event['location'] != null)
                      _Meta(
                        icon: Icons.location_on_rounded,
                        label: event['location'],
                        cs: cs,
                      ),
                    _Meta(
                      icon: Icons.people_outline_rounded,
                      label: '$rsvpCount RSVPs',
                      cs: cs,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Price + action buttons
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isFree
                            ? cs.primaryContainer
                            : cs.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isFree ? 'Free' : '\$$price',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isFree
                              ? cs.onPrimaryContainer
                              : cs.onTertiaryContainer,
                        ),
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded, size: 14),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cs.primary,
                        side: BorderSide(color: cs.primary.withOpacity(0.4)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline_rounded, size: 14),
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cs.error,
                        side: BorderSide(color: cs.error.withOpacity(0.4)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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

  String _mon(int m) => [
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

  String _time(DateTime dt) {
    final h = dt.hour > 12
        ? dt.hour - 12
        : dt.hour == 0
        ? 12
        : dt.hour;
    return '$h:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'pm' : 'am'}';
  }
}

// ─────────────────────────────────────────────
// Category pill with per-category colours
// ─────────────────────────────────────────────

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

// ─────────────────────────────────────────────
// Meta info chip
// ─────────────────────────────────────────────

class _Meta extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme cs;

  const _Meta({required this.icon, required this.label, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
      ],
    );
  }
}
