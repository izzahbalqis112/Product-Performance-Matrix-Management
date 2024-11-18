import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../common/appColors.dart';
import '../../../controller/navbar.dart';
import '../mainPage.dart';

class CompletionDialog extends StatefulWidget {
  final String projectId;

  CompletionDialog({required this.projectId});

  @override
  _CompletionDialogState createState() => _CompletionDialogState();
}

class _CompletionDialogState extends State<CompletionDialog> {
  final _actualDateController = TextEditingController();
  final _actualEndDateController = TextEditingController();
  final _actualLeadTimeController = TextEditingController();

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColor.deepGreen1,
            focusColor: AppColor.deepGreen1, 
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(), 
            ),
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(primary: AppColor.deepGreen1),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(selectedDate);
        _calculateLeadTime(); 
      });
    }
  }

  void _calculateLeadTime() {
    try {
      if (_actualDateController.text.isNotEmpty && _actualEndDateController.text.isNotEmpty) {
        final actualDate = DateFormat('dd-MM-yyyy').parse(_actualDateController.text);
        final actualEndDate = DateFormat('dd-MM-yyyy').parse(_actualEndDateController.text);
        final leadTime = actualEndDate.difference(actualDate).inDays;

        _actualLeadTimeController.text = leadTime.toString();
      }
    } catch (e) {
      _actualLeadTimeController.text = 'Error';
    }
  }

  Future<void> _submitData() async {
    try {
      final actualDate = DateFormat('dd-MM-yyyy').parse(_actualDateController.text);
      final actualEndDate = DateFormat('dd-MM-yyyy').parse(_actualEndDateController.text);
      final actualLeadTime = int.parse(_actualLeadTimeController.text);

      await FirebaseFirestore.instance.collection('projects').doc(widget.projectId).update({
        'actualDate': actualDate,
        'actualEndDate': actualEndDate,
        'actualLeadTime': '$actualLeadTime days',
        'projectStatus': 'Completed',
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ButtomNavBar(),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating project: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Complete Project'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _selectDate(_actualDateController),
            child: AbsorbPointer(
              child: TextField(
                controller: _actualDateController,
                decoration: InputDecoration(labelText: 'Actual Start Date'),
                keyboardType: TextInputType.datetime,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _selectDate(_actualEndDateController),
            child: AbsorbPointer(
              child: TextField(
                controller: _actualEndDateController,
                decoration: InputDecoration(labelText: 'Actual End Date'),
                keyboardType: TextInputType.datetime,
              ),
            ),
          ),
          TextField(
            controller: _actualLeadTimeController,
            decoration: InputDecoration(labelText: 'Actual Lead Time (days)'),
            keyboardType: TextInputType.number,
            readOnly: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitData,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
