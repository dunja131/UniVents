import 'package:flutter/material.dart';
import 'package:frontend/pages/event.dart';
import 'package:frontend/services/rsvp_service.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/services/user_service.dart';

class EventTile extends StatefulWidget {
  final Event event;
  final UserService userService;

  const EventTile({super.key, required this.event, required this.userService});

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  bool _hasRsvped =
      false; //tracks if the logged in user has RSVPd to an event on landing page

  //getter to avoid repeating RsvpService(widget.userService)
  RsvpService get _rsvpService => RsvpService(widget.userService);

  @override
  void initState() {
    super.initState();
    _checkRsvpStatus(); // check database when tile first loads
  }

  //Private Methods

  //Checks the database to see if the logged in user already has an RSVP to events on landing page
  //Runs on the load so button shows correct state even when clicking off landing page
  Future<void> _checkRsvpStatus() async {
    try {
      // ask backend if this user already has an RSVP for this event
      int? rsvpId = await RsvpService(
        widget.userService,
      ).getRsvpId(eventId: widget.event.eventId);
      setState(() {
        _hasRsvped =
            rsvpId !=
            null; // true if RSVP exists and green!, false if not = blue!
      });
    } catch (e) {
      debugPrint('Error checking RSVP status: $e');
    }
  }

  // just decides which method to call
  Future<void> _onAddPressed() async {
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

  // only handles creating the RSVP and setting it to GOING status
  Future<void> _createRsvp() async {
    await _rsvpService.createRsvp(
      eventId: widget.event.eventId,
      status: "GOING",
    );
    setState(() => _hasRsvped = true);
    _showSnackBar("RSVP successful!");
  }

  // only handles deleting
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

  // shows a snackbar message at the bottom of the screen
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final day = widget.event.startTime.day.toString();
    final month = _monthAbbr(widget.event.startTime.month);
    final formattedTime =
        "${widget.event.startTime.hour.toString().padLeft(2, '0')}:${widget.event.startTime.minute.toString().padLeft(2, '0')}";

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EventPage(event: widget.event, userService: widget.userService),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── image with overlays ──
            Stack(
              children: [
                // banner image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Image.asset(
                      widget.event.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.event,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // date badge — bottom left
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          month,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          day,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // ── text content ──
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Text(
                    widget.event.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // description preview
                  Text(
                    widget.event.description,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // bottom info row — location · time · price
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 13,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          widget.event.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time,
                        size: 13,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 3),
                      Text(
                        formattedTime,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.attach_money,
                        size: 13,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 3),
                      Text(
                        widget.event.price == 0.0
                            ? 'Free'
                            : '\$${widget.event.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ], 
              ),
            ), 
          ], 
        ),
      ),
    );
  }

  // helper to convert month int to abbreviation (looks pretty)
  String _monthAbbr(int month) {
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
    return months[month - 1];
  }
}
