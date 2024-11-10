import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/widget/customTextFieldNew.dart';

class AddEventDetails extends StatefulWidget {
  const AddEventDetails({super.key});

  @override
  _AddEventDetailsState createState() => _AddEventDetailsState();
}

class _AddEventDetailsState extends State<AddEventDetails> {
  DateTime? _selectedDate; // Single selected date
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _dateFormat.format(pickedDate);
      });
    }
  }

  void _submitData() async {
    try {
      final String eventName = _eventNameController.text;
      final String organizer = _organizerController.text;
      final String description = _descriptionController.text;

      final String eventId = Uuid().v4();

      Map<String, dynamic> eventData = {
        'eventId': eventId,
        'eventName': eventName,
        'organizer': organizer,
        'description': description,
        'eventDate':
            _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
        'timestamp': Timestamp.now(),
      };

      await _firestore.collection('events').doc(eventId).set(eventData);

      Navigator.pop(context);
    } catch (e) {
      _showErrorMessage('Failed to save event entry: $e');
    }
  }

  void _showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leadingWidth: 75,
        title: const Text(
          "Add New Event",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        color: Colors.black,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(right: 27, bottom: 59, left: 27),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: CustomTextFieldNew(
                          controller: _eventNameController,
                          hintText: "Event Name",
                          prefixIcon: Icons.event,
                          isValid: true,
                          onChanged: (value) {
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an event name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: SizedBox(
                            child: CustomTextFieldNew(
                              controller: _dateController,
                              hintText: _selectedDate == null
                                  ? "Date"
                                  : _dateFormat.format(_selectedDate!),
                              prefixIcon: Icons.calendar_today,
                              isValid: true,
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (_selectedDate == null) {
                                  return 'Please select a date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        child: CustomTextFieldNew(
                          controller: _organizerController,
                          hintText: "Organizer",
                          prefixIcon: Icons.person,
                          isValid: true,
                          onChanged: (value) {
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the organizer';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextFieldNew(
                        controller: _descriptionController,
                        hintText: "Description",
                        prefixIcon: Icons.description,
                        isValid: true,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const Spacer(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel',
                                style: TextStyle(color: AppColor.bgGreen1)),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _submitData();
                              }
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.bgGreen1,
                              foregroundColor:
                                  const Color.fromARGB(255, 0, 0, 0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
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
      ),
    );
  }
}
