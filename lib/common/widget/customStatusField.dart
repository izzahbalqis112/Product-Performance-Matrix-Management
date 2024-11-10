import 'package:flutter/material.dart';
import 'package:tf_pdpppms/common/appColors.dart';

import '../appFonts.dart';

// Define the enum for project statuses
enum ProjectStatus { notStarted, inProgress, onHold }

// Extension to get a string representation of the enum values
extension ProjectStatusExtension on ProjectStatus {
  String get name {
    switch (this) {
      case ProjectStatus.notStarted:
        return 'Not Started';
      case ProjectStatus.inProgress:
        return 'In Progress';
      case ProjectStatus.onHold:
        return 'On Hold';
    }
  }
}

class CustomProjectStatusField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool showError;
  final void Function(String)? onChanged;
  final FormFieldValidator<ProjectStatus>? validator;

  CustomProjectStatusField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.showError,
    this.onChanged,
    this.validator,
  });

  @override
  _CustomProjectStatusFieldState createState() => _CustomProjectStatusFieldState();
}

class _CustomProjectStatusFieldState extends State<CustomProjectStatusField> {
  ProjectStatus? _selectedStatus;
  bool _hasInteracted = false; // Flag to track user interaction
  String? _errorText; // Variable to manage error text

  @override
  void initState() {
    super.initState();
    // Initialize _selectedStatus using a safe approach
    _selectedStatus = ProjectStatus.values.firstWhere(
          (status) => status.name == widget.controller.text,
      orElse: () => ProjectStatus.notStarted, // Use a default value if not found
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<ProjectStatus>(
          value: _selectedStatus,
          hint: Text(widget.hintText),
          icon: Icon(Icons.arrow_drop_down, color: AppColor.grey),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            prefixIcon: Icon(widget.prefixIcon, color: AppColor.grey),
            errorText: _hasInteracted ? _errorText : null,
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
          onChanged: (ProjectStatus? newValue) {
            setState(() {
              _hasInteracted = true; // Set interaction flag when user changes value
              _selectedStatus = newValue;
              widget.controller.text = newValue?.name ?? '';
              if (widget.onChanged != null) {
                widget.onChanged!(newValue?.name ?? '');
              }

              // Perform validation here and set error state if necessary
              final validationResult = widget.validator?.call(newValue);
              _errorText = validationResult;
            });
          },
          items: ProjectStatus.values.map<DropdownMenuItem<ProjectStatus>>((ProjectStatus value) {
            return DropdownMenuItem<ProjectStatus>(
              value: value,
              child: Text(
                value.name,
                style:  AppFonts.text16(AppColor.black),
              ),
            );
          }).toList(),
          dropdownColor: AppColor.white, // Set dropdown background color
          style:  AppFonts.text12(AppColor.black), // Smaller font size for selected value
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            // Default validation logic if validator is not provided
            if (value == null) {
              return 'Please select a project status';
            }
            return null;
          },
        ),
      ],
    );
  }
}
