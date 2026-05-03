import 'package:flutter/material.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/theme/app_colours.dart';

class EventPage extends StatelessWidget {
  final Event event;
  const EventPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          event.title, // was hardcoded "Hyde Street 2026" - now uses actual event title
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColours.primary,
      ),
      body: Column(
        children: [
          // event banner image
          ClipRRect(
            child: SizedBox(
              child: Image.asset(
                event.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
            child: Column(
              children: [
                // price and date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.price == 0.0
                          ? 'Free'
                          : '\$${event.price.toStringAsFixed(2)}',
                      style: textTheme.bodyLarge,
                    ),
                    Text(
                      'date', // TODO: replace with event.date when available
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),

                // location and time row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.location,
                      style: textTheme.bodyLarge,
                    ),
                    Text(
                      'Time', // TODO: replace with event.startTime when available
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),

                // event description
                Text(
                  event.description,
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}