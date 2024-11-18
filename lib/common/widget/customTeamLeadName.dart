import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import 'package:tf_pdpppms/common/appFonts.dart';

class CustomTeamLeadNameField extends StatefulWidget {
  final TextEditingController controller;
  final bool isValid;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  CustomTeamLeadNameField({
    required this.controller,
    required this.isValid,
    this.onChanged,
    this.validator,
  });

  @override
  _CustomTeamLeadNameFieldState createState() => _CustomTeamLeadNameFieldState();
}

class _CustomTeamLeadNameFieldState extends State<CustomTeamLeadNameField> {
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
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            hintText: 'Enter your leader name',
            prefixIcon: Icon(
              Icons.person, 
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
          inputFormatters: [
            LengthLimitingTextInputFormatter(255), 
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
