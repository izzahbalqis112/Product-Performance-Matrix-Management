import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventId;
  final String eventName;
  final String organizer;
  final String description;
  final Timestamp eventDate; // Firestore Timestamp
  final Timestamp timestamp; // Firestore Timestamp

  EventModel({
    required this.eventId,
    required this.eventName,
    required this.organizer,
    required this.description,
    required this.eventDate,
    required this.timestamp,
  });

  // Create an instance from Firestore document
  factory EventModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data()!;
    return EventModel(
      eventId: doc.id,
      eventName: data['eventName'] as String,
      organizer: data['organizer'] as String,
      description: data['description'] as String,
      eventDate: data['eventDate'] as Timestamp,
      timestamp: data['timestamp'] as Timestamp,
    );
  }

  // Create an instance from JSON map
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['eventId'] as String,
      eventName: json['eventName'] as String,
      organizer: json['organizer'] as String,
      description: json['description'] as String,
      eventDate: json['eventDate'] is Timestamp
          ? json['eventDate'] as Timestamp
          : Timestamp.fromDate(DateTime.parse(json['eventDate'] as String)),
      timestamp: json['timestamp'] is Timestamp
          ? json['timestamp'] as Timestamp
          : Timestamp.fromDate(DateTime.parse(json['timestamp'] as String)),
    );
  }

  // Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'organizer': organizer,
      'description': description,
      'eventDate': eventDate, // Firestore Timestamp
      'timestamp': timestamp, // Firestore Timestamp
    };
  }

  // Convert to Map<String, dynamic> for passing to other widgets
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'organizer': organizer,
      'description': description,
      'eventDate': eventDate, // Firestore Timestamp
      'timestamp': timestamp, // Firestore Timestamp
    };
  }

  // Utility method to get DateTime from Firestore Timestamp
  DateTime getEventDate() {
    return eventDate.toDate();
  }

  DateTime getTimestampDate() {
    return timestamp.toDate();
  }
}
