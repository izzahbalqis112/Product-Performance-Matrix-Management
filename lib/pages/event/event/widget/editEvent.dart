import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/widget/customTextFieldNew.dart';

class EditEvent extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EditEvent({Key? key, required this.eventData}) : super(key: key);

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _eventNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _organizerController;
  late DateTime _eventDate;
  late String _organization;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _eventNameController =
        TextEditingController(text: widget.eventData['eventName']);
    _descriptionController =
        TextEditingController(text: widget.eventData['description']);
    _organizerController =
        TextEditingController(text: widget.eventData['organizer']);
    _eventDate = (widget.eventData['eventDate'] as Timestamp?)?.toDate() ??
        DateTime.now();
    _organization = widget.eventData['organization'] ?? '';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
      });
    }
  }

  void _updateEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        await _firestore
            .collection('events')
            .doc(widget.eventData['eventId']) 
            .update({
          'eventName': _eventNameController.text,
          'description': _descriptionController.text,
          'organizer': _organizerController.text,
          'eventDate': Timestamp.fromDate(_eventDate),
          'organization': _organization,
        });
        Navigator.pop(context, {
          'eventName': _eventNameController.text,
          'description': _descriptionController.text,
          'organizer': _organizerController.text,
          'eventDate': _eventDate,
          'organization': _organization,
        });
      } catch (e) {
        print("Failed to update event: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Event",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.black, 
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Colors.white), 
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor:
          Colors.black, 
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 27.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFieldNew(
                      controller: _eventNameController,
                      hintText: "Event Name",
                      prefixIcon: Icons.event,
                      onChanged: (value) => _eventNameController.text = value,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFieldNew(
                      controller: _descriptionController,
                      hintText: "Description",
                      prefixIcon: Icons.description,
                      minLines: 3,
                      maxLines: 5,
                      onChanged: (value) => _descriptionController.text = value,
                    ),
                    const SizedBox(height: 20),
                    CustomTextFieldNew(
                      controller: _organizerController,
                      hintText: "Organizer",
                      prefixIcon: Icons.person,
                      onChanged: (value) => _organizerController.text = value,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Event Date: ${_eventDate.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors
                                      .black), 
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.calendar_today,
                                color: Colors.black),
                            onPressed: _selectDate,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _updateEvent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                          ),
                          child: Text('Update Event'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
