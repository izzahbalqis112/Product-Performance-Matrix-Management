import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import 'package:tf_pdpppms/pages/event/findShareholders/widget/shareholderModel.dart';

import '../../event/eventPage.dart';
import '../../event/widget/eventModel.dart';

class ShareholderList extends StatelessWidget {
  final ShareholderModel shareholder;
  final EventModel? event;

  const ShareholderList({super.key, required this.shareholder, this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Fetch the event associated with this shareholder
        if (shareholder.eventName != null) {
          // Fetch the document as a DocumentSnapshot<Map<String, dynamic>>
          DocumentSnapshot<Map<String, dynamic>> eventDoc =
              await FirebaseFirestore.instance
                  .collection('events')
                  .doc(shareholder.eventName)
                  .get();

          if (eventDoc.exists) {
            // Pass the document to the EventModel
            EventModel event = EventModel.fromDocument(eventDoc);

            // Navigate to the EventPage with the event details
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EventPage(event: event),
              ),
            );
          } else {
            // Handle the case where the event document doesn't exist
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Event not found for this shareholder'),
              ),
            );
          }
        } else {
          // Handle the case where no event is associated with the shareholder
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No event associated with this shareholder'),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.bgGreen1,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: -4,
              blurRadius: 25,
              offset: Offset(0, 4),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 11, horizontal: 27),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  shareholder.organization,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191720),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      shareholder.contact,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8F8F9E),
                      ),
                    ),
                    Text(
                      '\RM${shareholder.donation.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8F8F9E),
                      ),
                    ),
                    Text(
                      shareholder.representative,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8F8F9E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
