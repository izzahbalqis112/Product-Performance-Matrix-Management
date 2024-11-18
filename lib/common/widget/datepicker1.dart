import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../appColors.dart';
import '../appFonts.dart';

class DatePicker1 extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isValid;
  final Function(String) onChanged;
  final String? Function(String?)? validator; 

  DatePicker1({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.isValid,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            hintText: hintText,
            prefixIcon: Icon(
              prefixIcon,
              color: isValid ? AppColor.deepGreen : Colors.grey,
            ),
            errorText: isValid ? null : 'Invalid date',
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
          onTap: () async {
            DateTime now = DateTime.now();
            DateTime initialDate = now;
            DateTime firstDate = DateTime(2000);
            DateTime lastDate = DateTime(2101); 

            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: firstDate,
              lastDate: lastDate,
            );

            if (selectedDate != null) {
              String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
              controller.text = formattedDate;
              onChanged(formattedDate);
            }
          },
          validator: (value) {
            final errorText = validator?.call(value);
            if (errorText != null) {
              return errorText;
            }
            return isValid ? null : 'Invalid date';
          },
        ),
      ],
    );
  }
}
