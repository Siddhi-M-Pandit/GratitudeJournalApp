import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JournalDetailScreen extends StatelessWidget {
  final QueryDocumentSnapshot entry;

  const JournalDetailScreen(this.entry, {super.key});

  String getFormattedDay(DateTime date) {
    List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return days[date.weekday % 7]; 
  }

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = entry['timestamp'];
    DateTime dateTime = timestamp.toDate();

    return Scaffold(
      appBar: AppBar(
        title: Text("Journal Details"),
        backgroundColor: Color(0xFFe3aa99),
        foregroundColor: Colors.white,
      ),

      backgroundColor: Color(0xFFfef9ed),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Text(
                    "${getFormattedDay(dateTime)}, ${dateTime.day}-${dateTime.month}-${dateTime.year}",
                    style: TextStyle(fontSize: 14, color: Color(0xFFa88a7e), fontStyle: FontStyle.italic ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}", 
                    style: TextStyle(fontSize: 12, color: Color(0xFFa88a7e), fontStyle: FontStyle.italic),
                  ),
                ],
              ),

              Divider(
                color: Color(0xFFd6bbaa), 
                thickness: 1.5,
              ),

              SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return Icon(
                    index < entry['rating'] ? Icons.star : Icons.star_border, 
                    color: index < entry['rating'] ? Colors.amber : Colors.grey,
                    size: 28,
                  );
                }),
              ),

              SizedBox(height: 10),

              Text(
                entry['text'], 
                style: TextStyle(fontSize: 16,  color: Color(0xFFa88a7e), fontWeight: FontWeight.bold)
              ),
              
              SizedBox(height: 15),

              entry['imageUrl'] != null
                  ? Image.network(entry['imageUrl'])
                  : SizedBox(), 
            ],
          ),
        ),
      ),
    );
  }
}
