import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:tf_pdpppms/common/appColors.dart';
import 'package:tf_pdpppms/pages/event/findShareholders/widget/shareholderModel.dart';
import '../../event/customtextfield.dart';

class EditShareholder extends StatefulWidget {
  const EditShareholder({super.key});

  @override
  _EditShareholderState createState() => _EditShareholderState();
}

class _EditShareholderState extends State<EditShareholder> {
  String? selectedShareholder;
  List<String> shareholderOptions = [];
  List<ShareholderModel> shareholders = [];
  String? selectedEventName;
  List<String> eventOptions = []; 
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController donationAmountController = TextEditingController();
  final TextEditingController representativeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchShareholders();
    fetchEvents();
  }

  void fetchShareholders() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('shareholders').get();
      final List<ShareholderModel> fetchedShareholders = snapshot.docs
          .map((doc) => ShareholderModel.fromDocument(doc))
          .toList();
      setState(() {
        shareholders = fetchedShareholders;
        shareholderOptions = shareholders
            .map((sh) => sh
                .organization) 
            .toList();
      });
    } catch (e) {
      print('Error fetching shareholders: $e');
    }
  }

  void fetchEvents() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('events').get();
      final List<String> fetchedEvents = snapshot.docs
          .map((doc) => doc['eventName']
              as String) 
          .toList();
      setState(() {
        eventOptions = fetchedEvents;
      });
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  void updateFields(String organizationName) {
    final selectedShareholder = shareholders.firstWhere(
      (sh) => sh.organization == organizationName,
      orElse: () => ShareholderModel(
        shareholderId: '',
        organization: '',
        contact: '',
        representative: '',
        donation: 0.0,
        timestamp: Timestamp.now(),
        eventName: '', 
      ),
    );

    organizationController.text = selectedShareholder.organization;
    contactController.text = selectedShareholder.contact;
    donationAmountController.text = selectedShareholder.donation.toString();
    representativeController.text = selectedShareholder.representative;
    selectedEventName = selectedShareholder.eventName;
  }

  void updateShareholder() async {
    if (selectedShareholder == null) {
      return;
    }

    final selectedShareholderDoc = shareholders.firstWhere(
      (sh) => sh.organization == selectedShareholder,
      orElse: () => ShareholderModel(
        shareholderId: '',
        organization: '',
        contact: '',
        representative: '',
        donation: 0.0,
        timestamp: Timestamp.now(),
        eventName: '',
      ),
    );

    try {
      await FirebaseFirestore.instance
          .collection('shareholders')
          .doc(selectedShareholderDoc.shareholderId)
          .update({
        'organization': organizationController.text,
        'contact': contactController.text,
        'donation': double.tryParse(donationAmountController.text) ?? 0.0,
        'representative': representativeController.text,
        'eventName': selectedEventName,
        'timestamp': Timestamp.now(),
      });
      Navigator.pop(context);
    } catch (e) {
      print('Error updating shareholder: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, 
        iconTheme: IconThemeData(
            color: Colors.white), 
        title: const Text(
          "Edit Shareholder",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leadingWidth: 75,
      ),
      body: Container(
        color: AppColor.black,
        padding: const EdgeInsets.only(right: 27, bottom: 59, left: 27),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.grey), 
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
                        value: selectedShareholder,
                        hint: Text('Select Shareholder'),
                        items: shareholderOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedShareholder = newValue;
                            if (newValue != null) {
                              updateFields(newValue);
                            }
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
                          height:
                              50,
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
                        value: selectedEventName,
                        hint: Text('Select Event'), 
                        items: eventOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedEventName = newValue;
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
                          height:
                              50, 
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
                  const SizedBox(height: 20),
                  CustomTextFieldNew(
                    controller: organizationController,
                    hintText: "Organization Name",
                    prefixIcon: Icons.business,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldNew(
                    controller: contactController,
                    hintText: "Contact",
                    prefixIcon: Icons.phone,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldNew(
                    controller: donationAmountController,
                    hintText: "Donation Amount",
                    prefixIcon: Icons.monetization_on,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFieldNew(
                    controller: representativeController,
                    hintText: "Representative Name",
                    prefixIcon: Icons.person,
                  ),
                  const Spacer(),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: AppColor.bgGreen1),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          updateShareholder();
                        },
                        child: const Text(
                          'Update Shareholder',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.bgGreen1,
                          foregroundColor: Colors.grey[1],
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
          ],
        ),
      ),
    );
  }
}
