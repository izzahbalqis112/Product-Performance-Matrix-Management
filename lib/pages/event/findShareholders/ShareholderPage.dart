import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tf_pdpppms/pages/event/findShareholders/widget/ShareholderList.dart';
import 'package:tf_pdpppms/pages/event/findShareholders/widget/addShareholder.dart';
import 'package:tf_pdpppms/pages/event/findShareholders/widget/fab.dart';
import 'package:tf_pdpppms/pages/event/findShareholders/widget/shareholderModel.dart';

import '../event/widget/eventModel.dart';

class ShareholdersPage extends StatefulWidget {
  const ShareholdersPage({super.key});

  @override
  _ShareholdersPageState createState() => _ShareholdersPageState();
}

class _ShareholdersPageState extends State<ShareholdersPage> {
  bool _showText = true;

  void _onAddShareholder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddShareholderDetails(
          onDataSubmitted: () {
            setState(() {
              _showText = false;
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _showText = false;
      });
    }
  }

  Future<EventModel?> _getEventForShareholder(String? eventName) async {
    if (eventName == null) return null;

    try {
      final eventDoc = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventName)
          .get();

      if (eventDoc.exists) {
        return EventModel.fromDocument(
            eventDoc as DocumentSnapshot<Map<String, dynamic>>);
      }
    } catch (e) {
      // Handle any errors here
      print('Error fetching event: $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('shareholders')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final shareholderDocs = snapshot.data?.docs ?? [];

              if (shareholderDocs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 300),
                    child: _showText
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Add Shareholder',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: shareholderDocs.length,
                  itemBuilder: (context, index) {
                    final shareholderDoc = shareholderDocs[index];
                    final shareholder = ShareholderModel.fromDocument(
                        shareholderDoc
                            as DocumentSnapshot<Map<String, dynamic>>);

                    return FutureBuilder<EventModel?>(
                      future: _getEventForShareholder(shareholder.eventName),
                      builder: (context, eventSnapshot) {
                        if (eventSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final event = eventSnapshot.data;

                        return ShareholderList(
                          shareholder: shareholder,
                          event: event, // Pass the event here
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
          Positioned(
            bottom: 80,
            right: 30,
            child: SpeedDialButton(),
          ),
        ],
      ),
    );
  }
}
