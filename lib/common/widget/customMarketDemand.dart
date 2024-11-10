import 'package:flutter/material.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import '../appFonts.dart';

// Define the enum for market demands
enum MarketDemand { high, medium, low }

// Extension to get a string representation of the enum values
extension MarketDemandExtension on MarketDemand {
  String get name {
    switch (this) {
      case MarketDemand.high:
        return 'High';
      case MarketDemand.medium:
        return 'Medium';
      case MarketDemand.low:
        return 'Low';
    }
  }
}

// Custom Market Demand Field
class CustomMarketDemandField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool showError; // Property to control error message visibility
  final void Function(String)? onChanged;
  final String? Function(MarketDemand?)? validator;

  CustomMarketDemandField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.showError, // Initialize showError
    this.onChanged,
    this.validator,
  });

  @override
  _CustomMarketDemandFieldState createState() => _CustomMarketDemandFieldState();
}

class _CustomMarketDemandFieldState extends State<CustomMarketDemandField> {
  MarketDemand _selectedStatus = MarketDemand.medium; // Default to a valid value
  bool _hasInteracted = false; // Flag to track user interaction
  String? _errorText; // Variable to manage error text

  @override
  void initState() {
    super.initState();
    // Initialize _selectedStatus based on controller's initial value
    _selectedStatus = MarketDemand.values.firstWhere(
          (status) => status.name == widget.controller.text,
      orElse: () => MarketDemand.medium, // Provide a default value
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<MarketDemand>(
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
          onChanged: (MarketDemand? newValue) {
            setState(() {
              _hasInteracted = true; // Set flag to true on user interaction
              _selectedStatus = newValue ?? MarketDemand.medium; // Ensure _selectedStatus is never null
              widget.controller.text = _selectedStatus.name;
              if (widget.onChanged != null) {
                widget.onChanged!(_selectedStatus.name);
              }

              // Perform validation here and set error state if necessary
              final validationResult = widget.validator?.call(_selectedStatus);
              _errorText = validationResult;
            });
          },
          items: MarketDemand.values
              .map<DropdownMenuItem<MarketDemand>>((MarketDemand value) {
            return DropdownMenuItem<MarketDemand>(
              value: value,
              child: Text(
                value.name,
                style:  AppFonts.text16(AppColor.black),
              ),
            );
          }).toList(),
          dropdownColor: AppColor.white, // Set dropdown background color
          style:  AppFonts.text12(AppColor.black),
          validator: (value) {
            // Apply validator here if needed
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            if (value == null) {
              return 'Please select a market demand';
            }
            return null;
          },
        ),
      ],
    );
  }
}
