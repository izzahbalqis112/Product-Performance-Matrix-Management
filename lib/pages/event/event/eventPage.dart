import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import 'package:tf_pdpppms/pages/event/event/widget/editEvent.dart';
import 'package:tf_pdpppms/pages/event/event/widget/eventModel.dart';
import '../findShareholders/widget/shareholderModel.dart';

class EventPage extends StatefulWidget {
  final EventModel event;

  EventPage({required this.event});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<ShareholderModel?> _shareholderFuture;

  @override
  void initState() {
    super.initState();
    _shareholderFuture = _fetchShareholder();
  }

  Future<ShareholderModel?> _fetchShareholder() async {
    try {
      var querySnapshot = await _firestore
          .collection('shareholders')
          .where('organization',
              isEqualTo: widget.event
                  .organizer)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return ShareholderModel.fromDocument(querySnapshot.docs.first);
      }
    } catch (e) {
      print('Error fetching shareholder: $e');
    }
    return null;
  }

  Future<void> _deleteEvent() async {
    try {
      await _firestore.collection('events').doc(widget.event.eventId).delete();
      Navigator.pop(context); 
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black, 
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0.0, 2.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Hero(
                    tag: widget.event.eventId,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image(
                        image: AssetImage('assets/img/TF-logo1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        iconSize: 30.0,
                        color: Colors
                            .white, 
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 20.0,
                  bottom: 20.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.event.eventName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            FutureBuilder<ShareholderModel?>(
              future: _shareholderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
        
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
        
                final shareholder = snapshot.data;
        
                return Container(
                  margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                  height: 350.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        Colors.grey[850],
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Organizer: ${widget.event.organizer}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Event Date: ${widget.event.getEventDate().toLocal().toString().split(' ')[0]}', 
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, 
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Donor Organization: ${shareholder?.organization ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, 
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Event Description:',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, 
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          widget.event.description,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _deleteEvent, 
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: AppColor.color2,
                    padding: EdgeInsets.all(15.0),
                    fixedSize: Size(60, 60),
                    elevation: 5.0,
                  ),
                  child: Icon(Icons.delete_outline, color: Colors.white),
                ),
                SizedBox(width: 10.0),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEvent(
                          eventData: widget.event.toMap(), 
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit_outlined,
                      color: Colors.white), 
                  label: Text('Edit',
                      style: TextStyle(
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    backgroundColor: AppColor.color3,
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
                    minimumSize: Size(150, 50),
                    elevation: 5.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
