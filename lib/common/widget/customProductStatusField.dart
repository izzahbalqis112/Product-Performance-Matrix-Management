import 'package:flutter/material.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import '../appFonts.dart';

// Define the enum for product statuses
enum ProductStatus {
  development,
  testing,
  preLaunch,
  launched,
  active,
  discontinued,
  outOfStock,
  backOrder,
  underReview,
  obsolete,
}

// Extension to get a string representation of the enum values
extension ProductStatusExtension on ProductStatus {
  String get name {
    switch (this) {
      case ProductStatus.development:
        return 'Development';
      case ProductStatus.testing:
        return 'Testing';
      case ProductStatus.preLaunch:
        return 'Pre-Launch';
      case ProductStatus.launched:
        return 'Launched';
      case ProductStatus.active:
        return 'Active';
      case ProductStatus.discontinued:
        return 'Discontinued';
      case ProductStatus.outOfStock:
        return 'Out of Stock';
      case ProductStatus.backOrder:
        return 'Backorder';
      case ProductStatus.underReview:
        return 'Under Review';
      case ProductStatus.obsolete:
        return 'Obsolete';
    }
  }
}

class CustomProductStatusField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool showError;
  final void Function(String)? onChanged;
  final String? Function(ProductStatus?)? validator;

  CustomProductStatusField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.showError,
    this.onChanged,
    this.validator,
  });

  @override
  _CustomProductStatusFieldState createState() => _CustomProductStatusFieldState();
}

class _CustomProductStatusFieldState extends State<CustomProductStatusField> {
  ProductStatus? _selectedStatus;
  bool _hasInteracted = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedStatus = ProductStatus.values.firstWhere(
          (status) => status.name == widget.controller.text,
      orElse: () => ProductStatus.development, // Use a valid default value
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<ProductStatus>(
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
          onChanged: (ProductStatus? newValue) {
            setState(() {
              _hasInteracted = true;
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
          items: ProductStatus.values
              .map<DropdownMenuItem<ProductStatus>>((ProductStatus value) {
            return DropdownMenuItem<ProductStatus>(
              value: value,
              child: Text(
                value.name,
                style:  AppFonts.text16(AppColor.black),
              ),
            );
          }).toList(),
          dropdownColor: AppColor.white,
          style: AppFonts.text12(AppColor.black),
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            if (value == null) {
              return 'Please select a product status';
            }
            return null;
          },
        ),
      ],
    );
  }
}
