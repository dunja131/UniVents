import 'package:flutter/material.dart';
import 'package:frontend/models/event_model.dart';
import '../../components/event_tile.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
          child: ListView.builder(
            itemCount: 12,
            itemBuilder: (context, index) {
              Event event = Event(
                title: "Hyde Street 2026",
                price: "60.00",
                startTime: DateTime(2026, 4, 18, 11, 0, 0),
                endTime: DateTime(2026, 4, 18, 18, 0, 0),
                description: "Hyde Street Party is locked in for April 18th! OUSA has partnered with the local residents of Hyde Street to work closely and ensure that everybody has the best day, making it a safe and fun time for all.",
                location: "Hyde Street",
                imagePath: "lib/images/HydeStreet.jpg",
                color: const Color(0xFF0F8644),
                isAllDay: false,
              );
              return EventTile(
                event: event,
              );
            }
          ),
        )
            
        
      ],
    );
  }
}
      