import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import '../eventPage.dart';
import 'eventModel.dart';

class AllEventsPage extends StatefulWidget {
  const AllEventsPage({Key? key}) : super(key: key);

  @override
  _AllEventsPageState createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    _fetchEventData();
  }

  void _fetchEventData() async {
    try {
      QuerySnapshot eventSnapshot = await _firestore.collection('events').get();
      if (eventSnapshot.docs.isNotEmpty) {
        setState(() {
          events = eventSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      } else {
        print("No event data found.");
      }
    } catch (e) {
      print("Failed to fetch event data: $e");
    }
  }

  Future<String?> _fetchOrganizationName(String eventName) async {
    try {
      QuerySnapshot shareholderSnapshot = await _firestore
          .collection('shareholders')
          .where('eventName', isEqualTo: eventName)
          .get();
      if (shareholderSnapshot.docs.isNotEmpty) {
        return shareholderSnapshot.docs.first.get('organization') as String?;
      }
    } catch (e) {
      print("Failed to fetch shareholder data: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'All Events',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final eventName = event['eventName'] ?? "No Event";
          final organizer = event['organizer'] ?? "No Organizer";
          final description = event['description'] ?? "No Description";
          final eventDate = event['eventDate'];
          DateTime? selectedDate;

          if (eventDate is Timestamp) {
            selectedDate = eventDate.toDate();
          }

          return FutureBuilder<String?>(
            future: _fetchOrganizationName(eventName),
            builder: (context, snapshot) {
              final organization = snapshot.data ?? "No Organization";

              return GestureDetector(
                onTap: () {
                  final eventModel = EventModel(
                    eventId: event['eventId'] as String,
                    eventName: eventName,
                    organizer: organizer,
                    description: description,
                    eventDate: eventDate,
                    timestamp: event['timestamp'] as Timestamp,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EventPage(event: eventModel),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.bgGreen1,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 119, 119, 119),
                        spreadRadius: -4,
                        blurRadius: 25,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF8F8F9E),
                          ),
                        ),
                        if (selectedDate != null)
                          Text(
                            DateFormat('dd/MM/yyyy').format(selectedDate),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8F8F9E),
                            ),
                          ),
                        if (organizer.isNotEmpty)
                          Text(
                            'Organizer: $organizer',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8F8F9E),
                            ),
                          ),
                        if (organization.isNotEmpty)
                          Text(
                            'Donation from: $organization',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8F8F9E),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
