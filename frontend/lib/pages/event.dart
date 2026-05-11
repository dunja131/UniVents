import 'package:flutter/material.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/theme/app_colours.dart';
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
    await _rsvpService.createRsvp(
      eventId: widget.event.eventId,
      status: "GOING",
    );
    setState(() => _hasRsvped = true);
    _showSnackBar("RSVP successful!");
  }

  Future<void> _removeRsvp() async {
    final int? rsvpId = await _rsvpService.getRsvpId(
      eventId: widget.event.eventId,
    );
    if (rsvpId != null) {
      await _rsvpService.deleteRsvp(rsvpId: rsvpId);
      setState(() => _hasRsvped = false);
      _showSnackBar("RSVP removed!");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final formattedDate =
        "${widget.event.startTime.day}/${widget.event.startTime.month}/${widget.event.startTime.year}";
    final formattedTime =
        "${widget.event.startTime.hour.toString().padLeft(2, '0')}:${widget.event.startTime.minute.toString().padLeft(2, '0')}";
    final formattedEnd =
        "${widget.event.endTime.hour.toString().padLeft(2, '0')}:${widget.event.endTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.event.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColours.primary,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: ElevatedButton(
          onPressed: _onRsvpPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _hasRsvped ? Colors.green : AppColours.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _hasRsvped ? 'Cancel RSVP' : 'RSVP',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

 body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // banner image
            SizedBox(
              height: 220,
              width: double.infinity,
              child: widget.event.imagePath.isNotEmpty
                  ? Image.asset(
                      widget.event.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imageFallback(),
                    )
                  : _imageFallback(),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Text(
                    widget.event.title,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColours.primary,
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // info rows
                  _infoRow(Icons.calendar_today, formattedDate),
                  _infoRow(Icons.access_time, "$formattedTime – $formattedEnd"),
                  _infoRow(Icons.location_on, widget.event.location),
                  _infoRow(
                    Icons.attach_money,
                    widget.event.price == 0.0
                        ? 'Free'
                        : '\$${widget.event.price.toStringAsFixed(2)}',
                  ),

                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 12),

                  // description
                  Text(
                    'About this event',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.event.description.isNotEmpty
                        ? widget.event.description
                        : 'No description provided.',
                    style: textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColours.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.event, size: 60, color: Colors.grey),
      ),
    );
  }
}
 