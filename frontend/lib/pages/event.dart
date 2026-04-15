import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'package:google_fonts/google_fonts.dart';


class EventPage extends StatelessWidget {
  final Event event;
  const EventPage({super.key, required this.event});
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Hyde Street 2026",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,


          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,

      ),
      body: Column(
          children: [
            ClipRRect(
                //borderRadius: BorderRadius.circular(20),
                
                child: SizedBox(
                  //height: 220,
                  //width: 410,
        
                  child: Image.asset(
                    event.imagePath,
                    fit: BoxFit.cover,
                  )
                )
            ),
      
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
              child: Column(
                children: [
                  // price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
      
                      Text(
                        event.price,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
      
                      Text(
                        event.date,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
      
      
      
                    ],
                  ),
      
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
      
                      Text(
                        event.location,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
      
                      Text(
                        event.time,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
      
      
      
                    ],
                  ),
            
                  Text(
                    event.description,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
                ],
              
              ),
            ),
      
            
          ],
        ),
    );
  }
}