import 'package:flutter/material.dart';
import 'package:frontend/models/event.dart';
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
              Event event = Event(title: "Hyde Street 2026", price: 60.00  , date: "18/04/2026", time: "11:00am", description: "Pretty sendy time", location: "Hyde Street", imagePath: "lib/images/HydeStreet.jpg");
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
      