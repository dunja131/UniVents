import 'package:flutter/material.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/services/event_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/components/event_tile.dart';
import 'package:frontend/theme/app_colours.dart';

class LandingPage extends StatefulWidget {
  final UserService userService;
  const LandingPage({super.key, required this.userService});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Event>? events;
  var isLoaded = false;
  var hasError = false;

  @override
  void initState() {
    super.initState();

    // fetch data from api
    getData();
  }

  Future<void> getData() async {
    try {
      events = await EventService(widget.userService).getEvents();
      if (events != null) {
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading events: $e');
      setState(() {
        hasError = true;   // triggers UI update
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // search bar
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColours.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Search', style: TextStyle(color: Colors.white)),
              Icon(Icons.search, color: Colors.white),
            ],
          ),
        ),

        // upcoming events
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Upcoming Events',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColours.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'See all',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColours.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Expanded(
          child: isLoaded
              ? ListView.builder(
                  itemCount: events!.length,
                  itemBuilder: (context, index) {
                    return EventTile(
                      event: events![index],
                      userService: widget.userService, // pass userService down so can send token + userId to Springboot
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