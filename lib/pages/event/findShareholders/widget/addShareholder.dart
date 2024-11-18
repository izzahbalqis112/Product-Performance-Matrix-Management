import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:tf_pdpppms/pages/event/findShareholders/widget/shareholderModel.dart';
import 'package:uuid/uuid.dart';
import '../../../../common/appColors.dart';
import '../../event/customtextfield.dart';

class AddShareholderDetails extends StatefulWidget {
  final VoidCallback onDataSubmitted;

  const AddShareholderDetails({super.key, required this.onDataSubmitted});

  @override
  _AddShareholderDetailsState createState() => _AddShareholderDetailsState();
}

class _AddShareholderDetailsState extends State<AddShareholderDetails> {
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _donationsController = TextEditingController();
  final TextEditingController _representativeController =
      TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  String? _selectedEvent;
  List<String> _eventOptions = [];

  @override
  void initState() {
    super.initState();
    _fetchEventNames();
  }

  void _fetchEventNames() async {
    QuerySnapshot snapshot = await _firestore.collection('events').get();
    List<String> options =
        snapshot.docs.map((doc) => doc['eventName'] as String).toList();

    setState(() {
      _eventOptions = options;
    });
  }

  void _submitData() async {
    try {
      final String organization = _organizationController.text;
      final String contact = _contactController.text;
      final String representative = _representativeController.text;
      final double donation = double.tryParse(_donationsController.text) ?? 0.0;

      final String shareholderId = Uuid().v4();

      ShareholderModel shareholderModel = ShareholderModel(
        shareholderId: shareholderId,
        organization: organization,
        contact: contact,
        representative: representative,
        donation: donation,
        timestamp: Timestamp.now(),
        eventName:
            _selectedEvent ?? 'No event selected',
      );

      await _firestore
          .collection('shareholders')
          .doc(shareholderId)
          .set(shareholderModel.toJson());

      widget.onDataSubmitted();
      Navigator.pop(context, shareholderModel);
    } catch (e) {
      _showErrorMessage('Failed to save shareholder entry: $e');
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
          "Add New Shareholder",
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFieldNew(
                        controller: _organizationController,
                        hintText: "Enter your organization",
                        prefixIcon: Icons.business,
                        isValid: true,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an organization name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextFieldNew(
                        controller: _contactController,
                        hintText: "Enter your contact",
                        prefixIcon: Icons.phone,
                        isValid: true,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a contact number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextFieldNew(
                        controller: _donationsController,
                        hintText: "Enter your donation amount",
                        prefixIcon: Icons.monetization_on,
                        isValid: true,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a donation amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFieldNew(
                        controller: _representativeController,
                        hintText: "Enter your representative",
                        prefixIcon: Icons.person,
                        isValid: true,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a representative name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            value: _selectedEvent,
                            hint: Text('Select Event'),
                            items: _eventOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedEvent = newValue;
                              });
                            },
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: 50,
                              width: double.infinity,
                            ),
                            iconStyleData: IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
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
                SizedBox(width: 10),
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
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
    );
  }
}
