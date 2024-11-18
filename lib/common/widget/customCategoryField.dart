import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import '../appFonts.dart';

class CustomCategoryField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool showError; 
  final void Function(String)? onChanged;
  final List<String> categories;
  final FormFieldValidator<String>? validator; 

  CustomCategoryField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.showError, 
    this.onChanged,
    required this.categories,
    this.validator, 
  });

  @override
  _CustomCategoryFieldState createState() => _CustomCategoryFieldState();
}

class _CustomCategoryFieldState extends State<CustomCategoryField> {
  String? _selectedCategory;
  bool _hasInteracted = false; 
  String? _errorText; 

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.controller.text.isNotEmpty
        ? widget.controller.text
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          hint: Text(widget.hintText),
          icon: Icon(Icons.arrow_drop_down, color: AppColor.grey),
          decoration: InputDecoration(
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
          onChanged: (String? newValue) {
            setState(() {
              _hasInteracted = true; 
              _selectedCategory = newValue;
              widget.controller.text = newValue ?? '';
              if (widget.onChanged != null) {
                widget.onChanged!(newValue ?? '');
              }
              final validationResult = widget.validator?.call(newValue);
              _errorText = validationResult;
            });
          },
          items: widget.categories
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
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
            return null;
          },
        ),
        SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () => _showAddCategoryDialog(context),
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('Add New Category', style: AppFonts.text12(AppColor.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.deepGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    final TextEditingController _newCategoryController = TextEditingController();
    bool _isCategoryValid = true;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Add New Category',
                  style: AppFonts.text12(AppColor.black),
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _newCategoryController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    hintText: 'Category Name',
                    hintStyle: AppFonts.text16(Colors.grey),
                    errorText: _isCategoryValid ? null : 'Invalid input',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: AppColor.deepGreen, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(255),
                    FilteringTextInputFormatter.singleLineFormatter,
                  ],
                  onChanged: (value) {
                    setState(() {
                      _isCategoryValid = value.isNotEmpty;
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: AppFonts.text14(AppColor.deepGreen)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_newCategoryController.text.isNotEmpty) {
                      setState(() {
                        widget.categories.add(_newCategoryController.text);
                        _selectedCategory = _newCategoryController.text;
                        widget.controller.text = _newCategoryController.text;
                        if (widget.onChanged != null) {
                          widget.onChanged!(_newCategoryController.text);
                        }
                      });
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        _isCategoryValid = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.deepGreen1,
                  ),
                  child: Text('Add', style: AppFonts.text16Bold(AppColor.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
