import 'package:flutter/material.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/services/rsvp_service.dart';
import 'package:frontend/services/user_service.dart';

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
      _showSnackBar("Failed: $e");
    }
  }

  Future<void> _createRsvp() async {
    await _rsvpService.createRsvp(eventId: widget.event.eventId, status: "GOING");
    setState(() => _hasRsvped = true);
    _showSnackBar("RSVP successful!");
  }

  Future<void> _removeRsvp() async {
    final int? rsvpId = await _rsvpService.getRsvpId(eventId: widget.event.eventId);
    if (rsvpId != null) {
      await _rsvpService.deleteRsvp(rsvpId: rsvpId);
      setState(() => _hasRsvped = false);
      _showSnackBar("RSVP removed!");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final formattedDate =
        "${widget.event.startTime.day}/${widget.event.startTime.month}/${widget.event.startTime.year}";
    final formattedTime =
        "${widget.event.startTime.hour.toString().padLeft(2, '0')}:${widget.event.startTime.minute.toString().padLeft(2, '0')}";
    final formattedEnd =
        "${widget.event.endTime.hour.toString().padLeft(2, '0')}:${widget.event.endTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // ── RSVP button ──
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: ElevatedButton(
          onPressed: _onRsvpPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasRsvped
                ? colorScheme.errorContainer
                : colorScheme.primary,
            foregroundColor: _hasRsvped
                ? colorScheme.onErrorContainer
                : colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            _hasRsvped ? 'Cancel RSVP' : 'RSVP to this event',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      body: CustomScrollView(
        slivers: [
          // ── Collapsing app bar with image ──
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: colorScheme.primary,
            iconTheme: IconThemeData(color: colorScheme.onPrimary),
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(
              //   widget.event.title,
              //   style: TextStyle(
              //     color: colorScheme.onPrimary,
              //     fontWeight: FontWeight.bold,
              //     fontSize: 16,
              //   ),
              // ),
              
              background: widget.event.imagePath.isNotEmpty
                  ? Image.asset(
                      widget.event.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imageFallback(colorScheme),
                    )
                  : _imageFallback(colorScheme),
            ),
          ),

          // ── Content ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // category chip
                  if (widget.event.category != null) ...[
                    Chip(
                      label: Text(widget.event.category!),
                      backgroundColor: colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // title
                  Text(
                    widget.event.title,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Info card ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _infoRow(context, Icons.calendar_today, formattedDate),
                        _infoRow(context, Icons.access_time, "$formattedTime – $formattedEnd"),
                        _infoRow(context, Icons.location_on, widget.event.location),
                        _infoRow(
                          context,
                          Icons.attach_money,
                          widget.event.price == 0.0
                              ? 'Free'
                              : widget.event.price.toStringAsFixed(2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── About section ──
                  Text(
                    'About this event',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.event.description.isNotEmpty
                        ? widget.event.description
                        : 'No description provided.',
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(Icons.event, size: 80, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}