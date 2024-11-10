import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../appColors.dart';
import '../appFonts.dart';

class CustomScaleTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool readOnly;
  final TextInputType? keyboardType;
  final String? suffixText;
  final bool isValid;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int minLines;
  final int maxLines;

  const CustomScaleTextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.readOnly = false,
    this.keyboardType,
    this.suffixText,
    this.isValid = true,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  _CustomScaleTextFieldState createState() => _CustomScaleTextFieldState();
}

class _CustomScaleTextFieldState extends State<CustomScaleTextField> {
  double _selectedScale = 1;

  @override
  void initState() {
    super.initState();
    _selectedScale = double.tryParse(widget.controller.text) ?? 1;
  }

  void _updateScale(double newScale) {
    setState(() {
      _selectedScale = newScale;
      widget.controller.text = _selectedScale.toStringAsFixed(0);
      if (widget.onChanged != null) {
        widget.onChanged!(_selectedScale.toStringAsFixed(0));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              hintText: widget.hintText,
              prefixIcon: Icon(
                widget.prefixIcon,
                color: AppColor.deepGreen,
              ),
              suffixText: widget.suffixText,
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
            validator: (value) {
              final errorText = widget.validator?.call(value);
              if (errorText != null) {
                return errorText;
              }
              return widget.isValid ? null : 'Invalid input';
            },
            inputFormatters: widget.inputFormatters,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
          ),
          SizedBox(height: 10),
          Slider(
            value: _selectedScale,
            min: 1,
            max: 10,
            divisions: 9,
            label: _selectedScale.toStringAsFixed(0),
            onChanged: (value) {
              _updateScale(value);
            },
            activeColor: AppColor.deepGreen,
            inactiveColor: Colors.grey[300],
          ),
          SizedBox(height: 5),
          Text(
            'Scale: ${_selectedScale.toStringAsFixed(0)}',
            style: AppFonts.text16(AppColor.black),
          ),
        ],
      ),
    );
  }
}
