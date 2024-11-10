import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import 'package:tf_pdpppms/common/appFonts.dart';

class CustomTextFieldNew extends StatelessWidget {
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
  final bool showIncrementDecrement;
  final void Function()? onIncrement;
  final void Function()? onDecrement;

  const CustomTextFieldNew({
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
    this.showIncrementDecrement = false,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(
                prefixIcon,
                color: Colors.grey,
              ),
              suffixIcon: showIncrementDecrement
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.grey),
                          onPressed: onDecrement ?? () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.grey),
                          onPressed: onIncrement ?? () {},
                        ),
                      ],
                    )
                  : null,
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
              suffixText: suffixText,
            ),
            style: AppFonts.text16(AppColor.black),
            onChanged: onChanged,
            validator: (value) {
              final errorText = validator?.call(value);
              if (errorText != null) {
                return errorText;
              }
              return isValid ? null : 'Invalid input';
            },
            inputFormatters: inputFormatters,
            minLines: minLines,
            maxLines: maxLines,
          ),
        ],
      ),
    );
  }
}
