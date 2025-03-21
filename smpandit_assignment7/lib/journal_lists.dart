import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_storage.dart';
import 'journal_detail.dart';

class JournalListScreen extends StatelessWidget {
  JournalListScreen({super.key});

  final CFStorage _firestoreService = CFStorage();

  String getFormattedDay(DateTime date) {
    List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return days[date.weekday % 7]; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gratitude Journal"), 
        backgroundColor: Color(0xFFe3aa99),
        foregroundColor: Colors.white,
      ),

      backgroundColor: Color(0xFFfef9ed),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getJournalEntries(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var entries = snapshot.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              var entry = entries[index];
              Timestamp timestamp = entry['timestamp'];
              DateTime dateTime = timestamp.toDate();

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0), 
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JournalDetailScreen(entry),
                      ),
                    );
                  },

                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      border: Border.all(color: Color(0xFFf5ebdb), width: 2),
                      borderRadius: BorderRadius.circular(40), 
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${getFormattedDay(dateTime)}, ${dateTime.day}-${dateTime.month}-${dateTime.year}",
                          style: TextStyle(fontSize: 18, color: Color(0xFFa88a7e), fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}", 
                          style: TextStyle(fontSize: 18, color: Color(0xFFa88a7e), fontWeight: FontWeight.bold),
                        ),
                      ]
              
                    ),
                  ),
                ),  
              );
 
            },
          );
        },
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: SizedBox(
          width: 170,  
          height: 60, 
          child: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/new-entry'),
            backgroundColor: Color(0xFFe3aa99),
            foregroundColor: Color(0xFFFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit_note_rounded, size: 32, color: Colors.white), 
                SizedBox(height: 17),
                Text(
                  "New Entry",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
  
}
