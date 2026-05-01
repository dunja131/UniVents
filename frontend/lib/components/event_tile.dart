import 'package:flutter/material.dart';
import 'package:frontend/pages/event.dart';
import 'package:frontend/services/rsvp_service.dart';
import '../models/event_model.dart';
import 'package:frontend/services/user_service.dart';

class EventTile extends StatefulWidget {
  final Event event;
  final UserService userService;
  const EventTile({super.key, required this.event, required this.userService});

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  bool _hasRsvped = false; //tracks if the user has RSVPd


  void _onAddPressed() async {
    // TODO: implement add/remove logic here and buttton change
    try{
      await RsvpService(widget.userService).createRsvp(
        eventId: widget.event.eventId,
        status: "GOING", 
      );
        setState(() {
          _hasRsvped = true; //the animation changes? - i assume this changes blue box to green
     });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("RSVP successful!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("RSVP failed: $e")),
      );
    }
  }
    
    

  @override
  Widget build(BuildContext context) {
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
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        width: 280,
        //height: 290,
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
                child: Image.asset(
                  widget.event.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3, top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.event.price == 0.0 
                          ? "Free" 
                          : "\$${widget.event.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _onAddPressed,
                
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _hasRsvped ? Colors.green : Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: _hasRsvped //if else statement so when user presses + to rsvp, it changes blue box to green tick with going 
                      ? Row(mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.check, color: Colors.white, size:16),
                      SizedBox(width: 4),
                                Text(
                                  "Going",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                ),
                              ],
                            )


                      : const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
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
