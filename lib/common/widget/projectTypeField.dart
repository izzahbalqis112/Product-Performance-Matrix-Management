import 'package:flutter/material.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import '../appFonts.dart';

// Define the enum for project types
enum ProjectType { oldProject, newProject, ongoingProject }

// Extension to get a string representation of the enum values
extension ProjectTypeExtension on ProjectType {
  String get name {
    switch (this) {
      case ProjectType.oldProject:
        return 'Old Project';
      case ProjectType.newProject:
        return 'New Project';
      case ProjectType.ongoingProject:
        return 'Ongoing Project';
    }
  }
}

// Custom Project Type Field
class CustomProjectTypeField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool showError; // Property to control error message visibility
  final void Function(String)? onChanged;
  final FormFieldValidator<ProjectType>? validator; // Adjusted type to ProjectType?

  CustomProjectTypeField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.showError, // Initialize showError
    this.onChanged,
    this.validator, // Adjusted type to ProjectType?
  });

  @override
  _CustomProjectTypeFieldState createState() => _CustomProjectTypeFieldState();
}

class _CustomProjectTypeFieldState extends State<CustomProjectTypeField> {
  ProjectType _selectedType = ProjectType.oldProject; // Default to a valid value
  bool _hasInteracted = false; // Flag to track user interaction
  String? _errorText; // Variable to manage error text

  @override
  void initState() {
    super.initState();
    // Initialize _selectedType based on controller's initial value
    _selectedType = ProjectType.values.firstWhere(
          (type) => type.name == widget.controller.text,
      orElse: () => ProjectType.oldProject, // Provide a default value
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<ProjectType>(
          value: _selectedType,
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
          onChanged: (ProjectType? newValue) {
            setState(() {
              _hasInteracted = true; // Set flag to true on user interaction
              _selectedType = newValue ?? ProjectType.oldProject; // Ensure _selectedType is never null
              widget.controller.text = _selectedType.name;
              if (widget.onChanged != null) {
                widget.onChanged!(_selectedType.name);
              }

              // Perform validation here and set error state if necessary
              final validationResult = widget.validator?.call(_selectedType);
              _errorText = validationResult;
            });
          },
          items: ProjectType.values
              .map<DropdownMenuItem<ProjectType>>((ProjectType value) {
            return DropdownMenuItem<ProjectType>(
              value: value,
              child: Text(
                value.name,
                style:  AppFonts.text16(AppColor.black),
              ),
            );
          }).toList(),
          dropdownColor: AppColor.white, // Set dropdown background color
          style: AppFonts.text12(AppColor.black),
          validator: (value) {
            // Apply validator here if needed
            if (widget.validator != null) {
              return widget.validator!(_selectedType);
            }
            return null;
          },
        ),
      ],
    );
  }
}
