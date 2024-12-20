import 'package:cloud_firestore/cloud_firestore.dart';

class ShareholderModel {
  final String shareholderId;
  final String organization;
  final String contact;
  final String representative;
  final double donation;
  final Timestamp timestamp; 
  final String? eventName;

  ShareholderModel({
    required this.shareholderId,
    required this.organization,
    required this.contact,
    required this.representative,
    required this.donation,
    required this.timestamp, 
    this.eventName,
  });

  factory ShareholderModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data()!;
    return ShareholderModel(
      shareholderId: doc.id,
      organization: data['organization'] as String,
      contact: data['contact'] as String,
      representative: data['representative'] as String,
      donation: (data['donation'] ?? 0.0) as double,
      timestamp: data['timestamp'] as Timestamp, 
      eventName: data['eventName'] as String?,
    );
  }

  factory ShareholderModel.fromJson(Map<String, dynamic> json) {
    return ShareholderModel(
      shareholderId: json['shareholderId'] as String,
      organization: json['organization'] as String,
      contact: json['contact'] as String,
      representative: json['representative'] as String,
      donation: (json['donation'] ?? 0.0) as double,
      timestamp: json['timestamp'] is Timestamp
          ? json['timestamp'] as Timestamp
          : Timestamp.fromDate(DateTime.parse(
              json['timestamp'] as String)), 
      eventName: json['eventName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shareholderId': shareholderId,
      'organization': organization,
      'contact': contact,
      'representative': representative,
      'donation': donation,
      'timestamp': timestamp, 
      'eventName': eventName,
    };
  }

  DateTime getTimestampDate() {
    return timestamp.toDate();
  }
}
