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
  List<Event>? events; //this is the displayed list where a filter is applied
  List<Event> _allEvents =
      []; //this would be the never filtered full list of events
  var isLoaded = false;
  var hasError = false;

  //Event filter categories for user to select if they want to filter events to specific category i.e. music/sports/free

  int _selectedFilter = 0;
  final List<String> _filters = [
    'All',
    'Music',
    'Sports',
    'Social',
    'Free',
  ]; //can add more to this, just what is easy & we will be mocking data anyway so can add events according to filters we want :)

  @override
  void initState() {
    super.initState();

    // fetch data from api
    getData();
  }

  Future<void> getData() async {
    try {
      final fetched = await EventService(widget.userService).getEvents();
      if (fetched != null) {
        setState(() {
          _allEvents = fetched; // master copy
          events = fetched; // displayed list depending on filter
          isLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading events: $e');
      setState(() {
        hasError = true;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      events = _allEvents.where((event) {
        final selectedFilter = _filters[_selectedFilter];
        return selectedFilter == 'All' ||
            (selectedFilter == 'Free' && event.price == 0) ||
            event.category?.toLowerCase() == selectedFilter.toLowerCase();
      }).toList();
    });
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

        SizedBox(
          //filter UI chips
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedFilter == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_filters[index]),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedFilter = index);
                    _applyFilters();
                  },
                  selectedColor: AppColours.primary,
                  backgroundColor: AppColours.primary.withOpacity(0.1),
                  side: BorderSide(color: AppColours.primary, width: 1),
                  shape: StadiumBorder(),
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColours.primary,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            },
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
                      userService: widget
                          .userService, // pass userService down so can send token + userId to Springboot
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
