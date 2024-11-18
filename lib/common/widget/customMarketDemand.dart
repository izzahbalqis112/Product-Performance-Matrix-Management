import 'package:flutter/material.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import '../appFonts.dart';

enum MarketDemand { high, medium, low }
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

class CustomMarketDemandField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool showError; 
  final void Function(String)? onChanged;
  final String? Function(MarketDemand?)? validator;

  CustomMarketDemandField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.showError, 
    this.onChanged,
    this.validator,
  });

  @override
  _CustomMarketDemandFieldState createState() => _CustomMarketDemandFieldState();
}

class _CustomMarketDemandFieldState extends State<CustomMarketDemandField> {
  MarketDemand _selectedStatus = MarketDemand.medium;
  bool _hasInteracted = false; 
  String? _errorText; 

  @override
  void initState() {
    super.initState();
    _selectedStatus = MarketDemand.values.firstWhere(
          (status) => status.name == widget.controller.text,
      orElse: () => MarketDemand.medium, 
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
              _hasInteracted = true;
              _selectedStatus = newValue ?? MarketDemand.medium; 
              widget.controller.text = _selectedStatus.name;
              if (widget.onChanged != null) {
                widget.onChanged!(_selectedStatus.name);
              }
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
          dropdownColor: AppColor.white, 
          style:  AppFonts.text12(AppColor.black),
          validator: (value) {
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
