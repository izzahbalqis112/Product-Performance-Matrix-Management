import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import '../eventPage.dart';
import 'eventAll.dart';
import 'eventModel.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> events = [];
  bool showMore = false;

  @override
  void initState() {
    super.initState();
    _fetchEventData();
  }

  void _fetchEventData() {
    _firestore.collection('events').snapshots().listen((snapshot) {
      setState(() {
        events = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        showMore = events.length > 3;
      });
    });
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
    final displayedEvents = events.take(3).toList();

    return SizedBox(
      height: 400, 
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 2 / 3, 
        ),
        itemCount: showMore ? displayedEvents.length + 1 : displayedEvents.length,
        itemBuilder: (context, index) {
          if (showMore && index == displayedEvents.length) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AllEventsPage(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
                child: const Center(
                  child: Text(
                    "More",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }

          final event = displayedEvents[index];
          final eventId = event['eventId'] as String;
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
                    eventId: eventId,
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
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
