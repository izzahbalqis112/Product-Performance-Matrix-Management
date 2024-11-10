import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../common/appColors.dart';
import '../../../../common/appFonts.dart';

class CustomLeadTimeField extends StatefulWidget {
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController leadTimeController;
  final bool isValid;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String hintText; // New parameter for hint text

  CustomLeadTimeField({
    required this.startDateController,
    required this.endDateController,
    required this.leadTimeController,
    required this.isValid,
    this.onChanged,
    this.validator,
    required this.hintText, // Initialize new parameter
  });

  @override
  _CustomLeadTimeFieldState createState() => _CustomLeadTimeFieldState();
}

class _CustomLeadTimeFieldState extends State<CustomLeadTimeField> {
  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    widget.startDateController.addListener(_updateLeadTime);
    widget.endDateController.addListener(_updateLeadTime);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.startDateController.removeListener(_updateLeadTime);
    widget.endDateController.removeListener(_updateLeadTime);
    super.dispose();
  }

  void _updateLeadTime() {
    final startDate = widget.startDateController.text;
    final endDate = widget.endDateController.text;

    if (startDate.isNotEmpty && endDate.isNotEmpty) {
      try {
        final start = DateFormat('dd-MM-yyyy').parse(startDate);
        final end = DateFormat('dd-MM-yyyy').parse(endDate);

        if (end.isAfter(start)) {
          final leadTime = end.difference(start).inDays;
          widget.leadTimeController.text = leadTime.toString();
        } else {
          widget.leadTimeController.text = '0'; // Or any other default value
        }
      } catch (e) {
        widget.leadTimeController.text = '0'; // Or any other default value
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.leadTimeController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  hintText: widget.hintText, // Use hintText parameter
                  prefixIcon: Icon(
                    Icons.timelapse,
                    color: _isFocused ? AppColor.deepGreen : Colors.grey,
                  ),
                  errorText: widget.isValid ? null : 'Invalid input',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: AppColor.deepGreen, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                style: AppFonts.text16(AppColor.black),
                onChanged: widget.onChanged,
                validator: widget.validator,
                readOnly: true,
              ),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColor.deepGreen,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: 'days', // Always display 'days'
                  onChanged: null, // Disable interaction
                  items: <String>['days']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: AppFonts.text16(AppColor.white),
                      ),
                    );
                  }).toList(),
                  icon: SizedBox.shrink(), // Remove the dropdown icon
                ),
              ),
            ),
          ],
        ),
        if (!widget.isValid)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              'Invalid input',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
