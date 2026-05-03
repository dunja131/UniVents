import 'package:flutter/material.dart';
import 'package:frontend/pages/event.dart';
import 'package:frontend/services/rsvp_service.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/theme/app_colours.dart';

class EventTile extends StatefulWidget {
  final Event event;
  final UserService userService;

  const EventTile({super.key, required this.event, required this.userService});

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  bool _hasRsvped = false; //tracks if the logged in user has RSVPd to an event on landing page

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
        _hasRsvped = rsvpId != null; // true if RSVP exists and green!, false if not = blue!
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        // navigate to event page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(event: widget.event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        width: 280,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 150,
                width: 400,
                child: Image.asset(widget.event.imagePath, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3, top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.title,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColours.primary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.event.price == 0.0
                            ? "Free"
                            : "\$${widget.event.price.toStringAsFixed(2)}",
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColours.primary,
                        ),
                      ),
                    ],
                  ),

                  //RSVP Button - blue + or green tick for going
                  GestureDetector(
                    onTap: _onAddPressed,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _hasRsvped ? Colors.green : AppColours.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          _hasRsvped //if else statement so when user presses + to rsvp, it changes blue box to green tick with going
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  "Going",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}