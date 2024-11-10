import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tf_pdpppms/common/appFonts.dart';
import '../appColors.dart';

class CostEfficiencyField extends StatefulWidget {
  final TextEditingController resourceTypeController;
  final TextEditingController resourceNameController;
  final TextEditingController costController;
  final TextEditingController quantityController;
  final TextEditingController totalCostController;
  final TextEditingController usagePeriodController;

  final TextEditingController hourlyRateController;
  final TextEditingController hoursWorkedController;
  final TextEditingController totalLaborCostController;

  final TextEditingController unitCostController;
  final TextEditingController quantityPurchasedController;
  final TextEditingController totalMaterialCostController;

  final TextEditingController totalResourceCostController;
  final TextEditingController grandTotalCostController;

  final TextEditingController totalRevenueController;
  final TextEditingController costEfficiencyRatioController;
  final TextEditingController costPerUnitController;
  final TextEditingController breakEvenPointController;

  final TextEditingController dateRecordedController;
  final TextEditingController expenseTypeController;

  final bool isValid;
  final void Function(String)? onChanged;

  CostEfficiencyField({
    required this.resourceTypeController,
    required this.resourceNameController,
    required this.costController,
    required this.quantityController,
    required this.totalCostController,
    required this.usagePeriodController,

    required this.hourlyRateController,
    required this.hoursWorkedController,
    required this.totalLaborCostController,

    required this.unitCostController,
    required this.quantityPurchasedController,
    required this.totalMaterialCostController,

    required this.totalResourceCostController,
    required this.grandTotalCostController,

    required this.totalRevenueController,
    required this.costEfficiencyRatioController,
    required this.costPerUnitController,
    required this.breakEvenPointController,

    required this.dateRecordedController,
    required this.expenseTypeController,

    required this.isValid,
    this.onChanged,
  });

  @override
  _CostEfficiencyFieldState createState() => _CostEfficiencyFieldState();
}

class _CostEfficiencyFieldState extends State<CostEfficiencyField> {
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  DateTime? _usagePeriodDate;

  @override
  void initState() {
    super.initState();

    widget.costController.addListener(_updateTotalCost);
    widget.quantityController.addListener(_updateTotalCost);
  }

  @override
  void dispose() {
    widget.costController.removeListener(_updateTotalCost);
    widget.quantityController.removeListener(_updateTotalCost);
    super.dispose();
  }

  void _updateTotalCost() {
    final cost = double.tryParse(widget.costController.text) ?? 0.0;
    final quantity = double.tryParse(widget.quantityController.text) ?? 0.0;
    final totalCost = cost * quantity;
    widget.totalCostController.text = totalCost.toStringAsFixed(2);
  }

  void _selectUsagePeriodDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _usagePeriodDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != _usagePeriodDate) {
      setState(() {
        _usagePeriodDate = selectedDate;
        widget.usagePeriodController.text = _dateFormat.format(_usagePeriodDate!);
      });
    }
  }

  void _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        widget.dateRecordedController.text = _dateFormat.format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        _buildTextField(
          controller: widget.resourceTypeController,
          hintText: 'Resource Type',
          prefixIcon: Icons.build,
        ),
        SizedBox(height: 10),
        _buildTextField(
          controller: widget.resourceNameController,
          hintText: 'Resource Name',
          prefixIcon: Icons.storage,
        ),
        SizedBox(height: 10),
        _buildTextField(
          controller: widget.costController,
          hintText: 'Cost',
          prefixIcon: Icons.attach_money,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        _buildTextField(
          controller: widget.quantityController,
          hintText: 'Quantity',
          prefixIcon: Icons.numbers,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        _buildTextField(
          controller: widget.totalCostController,
          hintText: 'Total Cost',
          prefixIcon: Icons.money_off,
          keyboardType: TextInputType.number,
          readOnly: true, // Make total cost read-only
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: _selectUsagePeriodDate,
          child: AbsorbPointer(
            child: _buildTextField(
              controller: widget.usagePeriodController,
              hintText: 'Usage Period',
              prefixIcon: Icons.calendar_today,
              readOnly: true,
            ),
          ),
        ),
        SizedBox(height: 15),
        _buildTextField(
          controller: widget.hourlyRateController,
          hintText: 'Hourly Rate',
          prefixIcon: Icons.attach_money,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        _buildTextField(
          controller: widget.hoursWorkedController,
          hintText: 'Hours Worked',
          prefixIcon: Icons.access_time,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        _buildTextField(
          controller: widget.totalLaborCostController,
          hintText: 'Total Labor Cost',
          prefixIcon: Icons.money_off,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 15),
        _buildTextField(
          controller: widget.unitCostController,
          hintText: 'Unit Cost',
          prefixIcon: Icons.attach_money,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        _buildTextField(
          controller: widget.quantityPurchasedController,
          hintText: 'Quantity Purchased',
          prefixIcon: Icons.numbers,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        _buildTextField(
          controller: widget.totalMaterialCostController,
          hintText: 'Total Material Cost',
          prefixIcon: Icons.money_off,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 15),
        _buildTextField(
          controller: widget.totalResourceCostController,
          hintText: 'Total Resource Cost',
          prefixIcon: Icons.money_off,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        _buildTextField(
          controller: widget.grandTotalCostController,
          hintText: 'Grand Total Cost',
          prefixIcon: Icons.money,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 15),
        GestureDetector(
          onTap: _selectDate,
          child: AbsorbPointer(
            child: _buildTextField(
              controller: widget.dateRecordedController,
              hintText: 'Date Recorded',
              prefixIcon: Icons.calendar_today,
              readOnly: true,
            ),
          ),
        ),
        SizedBox(height: 10),
        _buildTextField(
          controller: widget.expenseTypeController,
          hintText: 'Expense Type',
          prefixIcon: Icons.label,
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, color: AppColor.deepGreen),
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
      ),
    );
  }
}
