import 'package:flutter/material.dart';
import '../models/event.dart';

class EventTile extends StatelessWidget {
  Event event;
  EventTile({super.key, required this.event});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      width: 280,
      //height: 290,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12)
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
                event.imagePath,
                fit: BoxFit.cover,
              )
            )
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
                    event.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent
                
                    ),
                  ),
            
                  const SizedBox(height: 5),
            
            
                  Text(
                    "\$${event.price}",
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blueAccent
                
                    ),
                  ),
                  ],
                ),
            
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)
                    )
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    )
                  )
              ],
            ),
          )





        ]
      ),
    );

  }
}