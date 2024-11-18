import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventId;
  final String eventName;
  final String organizer;
  final String description;
  final Timestamp eventDate; 
  final Timestamp timestamp; 

  EventModel({
    required this.eventId,
    required this.eventName,
    required this.organizer,
    required this.description,
    required this.eventDate,
    required this.timestamp,
  });

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

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'organizer': organizer,
      'description': description,
      'eventDate': eventDate, 
      'timestamp': timestamp, 
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'organizer': organizer,
      'description': description,
      'eventDate': eventDate, 
      'timestamp': timestamp, 
    };
  }

  DateTime getEventDate() {
    return eventDate.toDate();
  }

  DateTime getTimestampDate() {
    return timestamp.toDate();
  }
}
