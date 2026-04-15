import 'package:flutter/material.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/services/event_service.dart';
import '../../components/event_tile.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Event>? events;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    // fetch data from api
    getData();
  }

  getData() async {
    try {
      events = await EventService().getEvents();
      if (events != null) {
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading events: $e');
    }
  }
 




















  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // search bar
        Container(
          padding: EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search',
                style: TextStyle(color: Colors.white),
              ),
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
            children: const [
              Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent
                ),
              ),
              Text(
                'See all',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent
                ),
              )
            ],
          
          ),
        ),

        const SizedBox(height: 10),

        Expanded(
          child: isLoaded
              ? ListView.builder(
                  itemCount: events!.length,
                  itemBuilder: (context, index) {
                    return EventTile(event: events![index]);
                  },
                )
              : const Center(child: CircularProgressIndicator()),
        )
            
        
      ],
    );
  }
}
      