import 'package:flutter/material.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import 'package:tf_pdpppms/pages/event/event/widget/addEvent.dart';
import 'package:tf_pdpppms/pages/event/event/widget/calendar.dart';
import 'package:tf_pdpppms/pages/event/event/widget/eventList.dart';

class EventMainPage extends StatefulWidget {
  const EventMainPage({super.key});

  @override
  _EventMainPageState createState() => _EventMainPageState();
}

class _EventMainPageState extends State<EventMainPage> {
  void _onAddEvent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEventDetails(),
      ),
    );
    if (result != null) {
      setState(() {
        // Trigger rebuild or any action you want on return from AddEventDetails
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  CalendarWidget(
                    primaryColor: AppColor.bgGreen1,
                  ),
                  const SizedBox(height: 20),
                  const EventList(), // Use the EventList widget here
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 30,
            child: FloatingActionButton(
              onPressed: _onAddEvent,
              backgroundColor: AppColor.bgGreen1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 6.0,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
