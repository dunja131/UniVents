import 'package:flutter/material.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/services/rsvp_service.dart';
import 'package:frontend/services/user_service.dart';

// ── Top-level helpers ──

String _weekdayFull(int w) => [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
][w - 1];

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

Map<String, Color> _categoryColors(String? category) {
  switch (category?.toLowerCase()) {
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

// ─────────────────────────────────────────────
// Event Page
// ─────────────────────────────────────────────

class EventPage extends StatefulWidget {
  final Event event;
  final UserService userService;
  const EventPage({super.key, required this.event, required this.userService});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _hasRsvped = false;

  RsvpService get _rsvpService => RsvpService(widget.userService);

  @override
  void initState() {
    super.initState();
    _checkRsvpStatus();
  }

  Future<void> _checkRsvpStatus() async {
    try {
      int? rsvpId = await _rsvpService.getRsvpId(eventId: widget.event.eventId);
      setState(() => _hasRsvped = rsvpId != null);
    } catch (e) {
      debugPrint('Error checking RSVP status: $e');
    }
  }

  Future<void> _onRsvpPressed() async {
    try {
      if (_hasRsvped) {
        await _removeRsvp();
      } else {
        await _createRsvp();
      }
    } catch (e) {
      _showSnackBar('Failed: $e');
    }
  }

  Future<void> _createRsvp() async {
    await _rsvpService.createRsvp(
      eventId: widget.event.eventId,
      status: 'GOING',
    );
    setState(() => _hasRsvped = true);
    _showSnackBar('RSVP successful!');
  }

  Future<void> _removeRsvp() async {
    final int? rsvpId = await _rsvpService.getRsvpId(
      eventId: widget.event.eventId,
    );
    if (rsvpId != null) {
      await _rsvpService.deleteRsvp(rsvpId: rsvpId);
      setState(() => _hasRsvped = false);
      _showSnackBar('RSVP removed!');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // ── Formatted strings ──
    final formattedDate =
        '${_weekdayFull(widget.event.startTime.weekday)}, ${_monthFull(widget.event.startTime.month)} ${widget.event.startTime.day}, ${widget.event.startTime.year}';
    final formattedTime =
        '${widget.event.startTime.hour.toString().padLeft(2, '0')}:${widget.event.startTime.minute.toString().padLeft(2, '0')}';
    final formattedEnd =
        '${widget.event.endTime.hour.toString().padLeft(2, '0')}:${widget.event.endTime.minute.toString().padLeft(2, '0')}';
    final isFree = widget.event.price == 0.0 || widget.event.price == 0;
    final catColors = _categoryColors(widget.event.category);

    return Scaffold(
      backgroundColor: cs.surface,

      // ── RSVP button fixed at bottom ──
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: ElevatedButton(
          onPressed: _onRsvpPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasRsvped ? cs.errorContainer : cs.primary,
            foregroundColor: _hasRsvped ? cs.onErrorContainer : cs.onPrimary,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: Text(
            _hasRsvped ? 'Cancel RSVP' : 'RSVP Now',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),

      body: CustomScrollView(
        slivers: [
          // back button and image
          SliverAppBar(
            pinned: true,
            backgroundColor: cs.surface,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_back_rounded, size: 16, color: cs.onSurface),
                  const SizedBox(width: 4),
                  Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            leadingWidth: 90,
          ),
          // Small contained image
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: widget.event.imagePath.isNotEmpty
                      ? Image.asset(
                          widget.event.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: cs.primaryContainer,
                            child: Center(
                              child: Icon(
                                _categoryIcon(widget.event.category),
                                size: 64,
                                color: cs.onPrimaryContainer.withOpacity(0.3),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: cs.primaryContainer,
                          child: Center(
                            child: Icon(
                              _categoryIcon(widget.event.category),
                              size: 64,
                              color: cs.onPrimaryContainer.withOpacity(0.3),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),

          // ── Content ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title + category pill ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.event.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                            height: 1.2,
                          ),
                        ),
                      ),
                      if (widget.event.category != null) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: catColors['bg'],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: catColors['text']!.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            widget.event.category!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: catColors['text'],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Info rows ──
                  _InfoRow(
                    icon: Icons.calendar_today_rounded,
                    text: formattedDate,
                    cs: cs,
                  ),
                  _InfoRow(
                    icon: Icons.access_time_rounded,
                    text: '$formattedTime – $formattedEnd',
                    cs: cs,
                  ),
                  _InfoRow(
                    icon: Icons.location_on_rounded,
                    text: widget.event.location,
                    cs: cs,
                  ),

                  // if (widget.event.organiserName != null)
                  //   _InfoRow(
                  //     icon: Icons.person_outline_rounded,
                  //     text: 'Organised by',
                  //     boldSuffix: widget.event.organiserName!,
                  //     cs: cs,
                  //   ), --commenting this out atm to decide if we want the organiser name in the event detail
                  const SizedBox(height: 20),

                  Divider(color: cs.outlineVariant),

                  const SizedBox(height: 20),

                  // ── Price badge ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isFree
                          ? cs.primaryContainer
                          : const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isFree
                          ? 'Free entry'
                          : '\$${widget.event.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isFree
                            ? cs.onPrimaryContainer
                            : const Color(0xFF856404),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── About section ──
                  Text(
                    'About this event',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.event.description.isNotEmpty
                        ? widget.event.description
                        : 'No description provided.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Reusable info row
// ─────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? boldSuffix;
  final ColorScheme cs;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.cs,
    this.boldSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: boldSuffix != null
                ? RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: cs.onSurfaceVariant,
                      ),
                      children: [
                        TextSpan(text: '$text '),
                        TextSpan(
                          text: boldSuffix,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                  ),
          ),
        ],
      ),
    );
  }
}
