import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tf_pdpppms/common/widget/customLeadTimeField.dart';
import 'package:tf_pdpppms/common/widget/customTextFieldNew.dart';
import '../../../../../../../../../common/appColors.dart';
import '../../../../../../../../../common/appFonts.dart';
import '../../../../../../../../../common/widget/datepicker.dart';
import '../../../selectedProjectID.dart';
import 'effectivenessFactors1.dart';

class EfficiencyFactors1Page extends StatefulWidget {
  final String projectId;
  final String productId;

  EfficiencyFactors1Page({required this.projectId, required this.productId});

  @override
  _EfficiencyFactors1PageState createState() => _EfficiencyFactors1PageState();
}

class _EfficiencyFactors1PageState extends State<EfficiencyFactors1Page> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  final _plannedStartDateController = TextEditingController();
  final _plannedEndDateController = TextEditingController();
  final _plannedDurationController = TextEditingController();
  DateTime? _startDate;
  final _plannedLaborCostController = TextEditingController();
  final _plannedMaterialCostController = TextEditingController();
  final _plannedOverheadCostController = TextEditingController();
  final _otherPlannedCostController = TextEditingController();
  final _plannedDevCostController = TextEditingController();
  final _plannedUnitSalesController = TextEditingController();
  final _plannedMarketShareController = TextEditingController();
  final _plannedRevenueController = TextEditingController();
  final _plannedProductPerformanceController = TextEditingController();
  final _maxPlannedUnitSalesController = TextEditingController();
  final _normalizedPlannedUnitSalesController = TextEditingController();
  final _maxPlannedRevenueController = TextEditingController();
  final _normalizedPlannedRevenueController = TextEditingController();
  final _plannedQualityGoalsController = TextEditingController();
  final _plannedWasteReductionTargetController = TextEditingController();
  final _plannedTotalProductionController = TextEditingController();
  final _plannedWasteReductionController = TextEditingController();
  double _defectRate = 0.0;
  double _customerSatisfaction = 0.0;
  double _complianceRate = 0.0;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  final _plannedLaunchDateController = TextEditingController();
  DateTime? _launchDate;
  final _plannedDevelopmentCostController = TextEditingController();
  final _plannedProductionCostController = TextEditingController();
  final _plannedOperationalCostController = TextEditingController();
  final _plannedCostEfficiencyMetricsController = TextEditingController();
  final _plannedUnitSalesYearlyController = TextEditingController();
  final _plannedHoursController = TextEditingController();
  final _plannedCostsController = TextEditingController();
  final _plannedMaterialUsageController = TextEditingController();
  final _plannedResourceUtilizationController = TextEditingController();
  final _plannedTimeToMarketController = TextEditingController();
  final _plannedValueController = TextEditingController();
  final _plannedAddedTimeController = TextEditingController();
  final _plannedTotalCycleTimeController = TextEditingController();
  final _plannedPCEController = TextEditingController();
  final _totalPlannedResourceAllocationController = TextEditingController();
  final _plannedTotalPrototypeIterationTimeController = TextEditingController();
  final _plannedTotalOutputController = TextEditingController();
  final _plannedTotalInputController = TextEditingController();
  final _plannedManufacturingEfficiencyController = TextEditingController();
  final _plannedCycleTimeController = TextEditingController();
  final _plannedTargetCycleTimeController = TextEditingController();
  final _plannedCycleTimeReductionController = TextEditingController();
  String _selectedFormat = 'HH';
  final List<String> _formats = ['HH', 'MM', 'SS', 'Days'];
  final _plannedDeliveryTimeController = TextEditingController();
  final _plannedBudgetCostsController = TextEditingController();
  final _plannedComplianceController = TextEditingController();
  final _plannedInnovationController = TextEditingController();
  final _plannedResponsivenessController = TextEditingController();
  final _plannedSustainabilityController = TextEditingController();
  final _plannedRiskManagementController = TextEditingController();
  final _plannedCollaborationController = TextEditingController();
  final _plannedServiceLevelsController = TextEditingController();
  final _plannedQualityStandardController = TextEditingController();
  final _plannedAccuracyController = TextEditingController();
  final _plannedLeadTimeController = TextEditingController();
  final _plannedFlexibilityController = TextEditingController();
  final _plannedCommunicationEfficiencyController = TextEditingController();
  final _plannedReliabilityController = TextEditingController();
  final _plannedSupplierEfficiencyController = TextEditingController();
  bool _showError = false;
  final _totalPlannedMilestoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _plannedStartDateController.addListener(_updatePlannedDuration);
    _plannedEndDateController.addListener(_updatePlannedDuration);
    _plannedLaborCostController.addListener(_updatePlannedDevCost);
    _plannedMaterialCostController.addListener(_updatePlannedDevCost);
    _plannedOverheadCostController.addListener(_updatePlannedDevCost);
    _otherPlannedCostController.addListener(_updatePlannedDevCost);
    _plannedUnitSalesController.addListener(_updateNormalizedPlannedUnitSales);
    _plannedMarketShareController.addListener(_updatePlannedProductPerformance);
    _plannedRevenueController.addListener(_updateNormalizedPlannedRevenue);
    _maxPlannedUnitSalesController.addListener(_updateNormalizedPlannedUnitSales);
    _maxPlannedRevenueController.addListener(_updateNormalizedPlannedRevenue);
    _plannedProductPerformanceController.addListener(_updatePlannedProductPerformance);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
    _plannedDevelopmentCostController.addListener(_updatePlannedCostEfficiencyMetrics);
    _plannedProductionCostController.addListener(_updatePlannedCostEfficiencyMetrics);
    _plannedOperationalCostController.addListener(_updatePlannedCostEfficiencyMetrics);
    _plannedHoursController.addListener(_updatePlannedResourceUtilization);
    _plannedCostsController.addListener(_updatePlannedResourceUtilization);
    _plannedMaterialUsageController.addListener(_updatePlannedResourceUtilization);
    _plannedStartDateController.addListener(_updateTimeToMarket);
    _plannedLaunchDateController.addListener(_updateTimeToMarket);
    _plannedValueController.addListener(_updatePlannedPCE);
    _plannedAddedTimeController.addListener(_updatePlannedPCE);
    _plannedTotalCycleTimeController.addListener(_updatePlannedPCE);
    _plannedWasteReductionTargetController.addListener(_updatePlannedWasteReduction);
    _plannedTotalProductionController.addListener(_updatePlannedWasteReduction);
    _plannedTotalOutputController.addListener(_updatePlannedManufacturingEfficiency);
    _plannedTotalInputController.addListener(_updatePlannedManufacturingEfficiency);
    _plannedCycleTimeController.addListener(_updatePCTR);
    _plannedTargetCycleTimeController.addListener(_updatePCTR);
    _plannedDeliveryTimeController.addListener(_calculateSupplierEfficiency);
    _plannedBudgetCostsController.addListener(_calculateSupplierEfficiency);
    _plannedComplianceController.addListener(_calculateSupplierEfficiency);
    _plannedInnovationController.addListener(_calculateSupplierEfficiency);
    _plannedResponsivenessController.addListener(_calculateSupplierEfficiency);
    _plannedSustainabilityController.addListener(_calculateSupplierEfficiency);
    _plannedRiskManagementController.addListener(_calculateSupplierEfficiency);
    _plannedCollaborationController.addListener(_calculateSupplierEfficiency);
    _plannedServiceLevelsController.addListener(_calculateSupplierEfficiency);
    _plannedQualityStandardController.addListener(_calculateSupplierEfficiency);
    _plannedAccuracyController.addListener(_calculateSupplierEfficiency);
    _plannedLeadTimeController.addListener(_calculateSupplierEfficiency);
    _plannedFlexibilityController.addListener(_calculateSupplierEfficiency);
    _plannedCommunicationEfficiencyController.addListener(_calculateSupplierEfficiency);
    _plannedReliabilityController.addListener(_calculateSupplierEfficiency);
  }

  @override
  void dispose() {
    _plannedStartDateController.removeListener(_updatePlannedDuration);
    _plannedEndDateController.removeListener(_updatePlannedDuration);
    _plannedLaborCostController.removeListener(_updatePlannedDevCost);
    _plannedMaterialCostController.removeListener(_updatePlannedDevCost);
    _plannedOverheadCostController.removeListener(_updatePlannedDevCost);
    _otherPlannedCostController.removeListener(_updatePlannedDevCost);
    _plannedUnitSalesController.removeListener(_updateNormalizedPlannedUnitSales);
    _plannedMarketShareController.removeListener(_updatePlannedProductPerformance);
    _plannedRevenueController.removeListener(_updateNormalizedPlannedRevenue);
    _maxPlannedUnitSalesController.removeListener(_updateNormalizedPlannedUnitSales);
    _maxPlannedRevenueController.removeListener(_updateNormalizedPlannedRevenue);
    _plannedProductPerformanceController.removeListener(_updatePlannedProductPerformance);
    _plannedDevelopmentCostController.removeListener(_updatePlannedCostEfficiencyMetrics);
    _plannedProductionCostController.removeListener(_updatePlannedCostEfficiencyMetrics);
    _plannedOperationalCostController.removeListener(_updatePlannedCostEfficiencyMetrics);
    _plannedStartDateController.removeListener(_updateTimeToMarket);
    _plannedLaunchDateController.removeListener(_updateTimeToMarket);
    _plannedStartDateController.dispose();
    _plannedEndDateController.dispose();
    _plannedDurationController.dispose();
    _plannedLaborCostController.dispose();
    _plannedMaterialCostController.dispose();
    _plannedOverheadCostController.dispose();
    _otherPlannedCostController.dispose();
    _plannedDevCostController.dispose();
    _plannedUnitSalesController.dispose();
    _maxPlannedUnitSalesController.dispose();
    _normalizedPlannedUnitSalesController.dispose();
    _plannedMarketShareController.dispose();
    _plannedRevenueController.dispose();
    _plannedProductPerformanceController.dispose();
    _maxPlannedRevenueController.dispose();
    _normalizedPlannedRevenueController.dispose();
    _animationController.dispose();
    _plannedQualityGoalsController.dispose();
    _plannedLaunchDateController.dispose();
    _plannedDevelopmentCostController.dispose();
    _plannedProductionCostController.dispose();
    _plannedOperationalCostController.dispose();
    _plannedCostEfficiencyMetricsController.dispose();
    _plannedUnitSalesYearlyController.dispose();
   _plannedHoursController.removeListener(_updatePlannedResourceUtilization);
    _plannedCostsController.removeListener(_updatePlannedResourceUtilization);
    _plannedMaterialUsageController.removeListener(_updatePlannedResourceUtilization);
    _plannedHoursController.dispose();
    _plannedCostsController.dispose();
    _plannedMaterialUsageController.dispose();
    _plannedResourceUtilizationController.dispose();
    _plannedTimeToMarketController.dispose();
    _plannedValueController.removeListener(_updatePlannedPCE);
    _plannedAddedTimeController.removeListener(_updatePlannedPCE);
    _plannedTotalCycleTimeController.removeListener(_updatePlannedPCE);
    _plannedValueController.dispose();
    _plannedAddedTimeController.dispose();
    _plannedTotalCycleTimeController.dispose();
    _plannedPCEController.dispose();
    _totalPlannedResourceAllocationController.dispose();
    _plannedTotalPrototypeIterationTimeController.dispose();
    _plannedWasteReductionTargetController.removeListener(_updatePlannedWasteReduction);
    _plannedTotalProductionController.removeListener(_updatePlannedWasteReduction);
    _plannedWasteReductionTargetController.dispose();
    _plannedTotalProductionController.dispose();
    _plannedWasteReductionController.dispose();
    _plannedTotalOutputController.removeListener(_updatePlannedManufacturingEfficiency);
    _plannedTotalInputController.removeListener(_updatePlannedManufacturingEfficiency);
    _plannedTotalOutputController.dispose();
    _plannedTotalInputController.dispose();
    _plannedCycleTimeController.removeListener(_updatePCTR);
    _plannedTargetCycleTimeController.removeListener(_updatePCTR);
    _plannedCycleTimeController.dispose();
    _plannedTargetCycleTimeController.dispose();
    _plannedCycleTimeReductionController.dispose();
    _plannedDeliveryTimeController.dispose();
    _plannedBudgetCostsController.dispose();
    _plannedComplianceController.dispose();
    _plannedInnovationController.dispose();
    _plannedResponsivenessController.dispose();
    _plannedSustainabilityController.dispose();
    _plannedRiskManagementController.dispose();
    _plannedCollaborationController.dispose();
    _plannedServiceLevelsController.dispose();
    _plannedQualityStandardController.dispose();
    _plannedAccuracyController.dispose();
    _plannedLeadTimeController.dispose();
    _plannedFlexibilityController.dispose();
    _plannedCommunicationEfficiencyController.dispose();
    _plannedReliabilityController.dispose();
    _plannedSupplierEfficiencyController.dispose();
    _plannedDeliveryTimeController.removeListener(_calculateSupplierEfficiency);
    _plannedBudgetCostsController.removeListener(_calculateSupplierEfficiency);
    _plannedComplianceController.removeListener(_calculateSupplierEfficiency);
    _plannedInnovationController.removeListener(_calculateSupplierEfficiency);
    _plannedResponsivenessController.removeListener(_calculateSupplierEfficiency);
    _plannedSustainabilityController.removeListener(_calculateSupplierEfficiency);
    _plannedRiskManagementController.removeListener(_calculateSupplierEfficiency);
    _plannedCollaborationController.removeListener(_calculateSupplierEfficiency);
    _plannedServiceLevelsController.removeListener(_calculateSupplierEfficiency);
    _plannedQualityStandardController.removeListener(_calculateSupplierEfficiency);
    _plannedAccuracyController.removeListener(_calculateSupplierEfficiency);
    _plannedLeadTimeController.removeListener(_calculateSupplierEfficiency);
    _plannedFlexibilityController.removeListener(_calculateSupplierEfficiency);
    _plannedCommunicationEfficiencyController.removeListener(_calculateSupplierEfficiency);
    _plannedReliabilityController.removeListener(_calculateSupplierEfficiency);
    _plannedDeliveryTimeController.dispose();
    _plannedBudgetCostsController.dispose();
    _plannedComplianceController.dispose();
    _plannedInnovationController.dispose();
    _plannedResponsivenessController.dispose();
    _plannedSustainabilityController.dispose();
    _plannedRiskManagementController.dispose();
    _plannedCollaborationController.dispose();
    _plannedServiceLevelsController.dispose();
    _plannedQualityStandardController.dispose();
    _plannedAccuracyController.dispose();
    _plannedLeadTimeController.dispose();
    _plannedFlexibilityController.dispose();
    _plannedCommunicationEfficiencyController.dispose();
    _plannedReliabilityController.dispose();
    _plannedSupplierEfficiencyController.dispose();
    _totalPlannedMilestoneController.dispose();
    super.dispose();
  }

  void _saveEfficiency() async {
    try {
      Map<String, dynamic> efficiencyData = {
        'productId': widget.productId,
        'projectId': widget.projectId,
        'StartDate': _plannedStartDateController.text,
        'EndDate': _plannedEndDateController.text,
        'LeadTime': '${_plannedDurationController.text} days',
        'LaborCost': 'RM ${_plannedLaborCostController.text}',
        'MaterialCost': 'RM ${_plannedMaterialCostController.text}',
        'OverheadCost': 'RM ${_plannedOverheadCostController.text}',
        'OtherPlannedCost': 'RM ${_otherPlannedCostController.text}',
        'DevCost': 'RM ${_plannedDevCostController.text}',
        'UnitSales': '${_plannedUnitSalesController.text} unit',
        'MarketShare': '${_plannedMarketShareController.text} %',
        'Revenue': 'RM ${_plannedRevenueController.text}',
        'ProductPerformance': '${_plannedProductPerformanceController.text} %',
        'MaxUnitSales': '${_maxPlannedUnitSalesController.text} unit',
        'NormalizedUnitSales': '${_normalizedPlannedUnitSalesController.text} %',
        'MaxRevenue': 'RM ${_maxPlannedRevenueController.text}',
        'NormalizedRevenue': '${_normalizedPlannedRevenueController.text} %',
        'QualityGoals': '${_plannedQualityGoalsController.text} %',
        'DefectRate': '${_defectRate} %',
        'CustomerSatisfaction': '${_customerSatisfaction} %',
        'ComplianceRate': '${_complianceRate} %',
        'LaunchDate': _plannedLaunchDateController.text,
        'DevelopmentCost': 'RM ${_plannedDevelopmentCostController.text}',
        'ProductionCost': 'RM ${_plannedProductionCostController.text}',
        'OperationalCost': 'RM ${_plannedOperationalCostController.text}',
        'CostEfficiencyMetrics': 'RM ${_plannedCostEfficiencyMetricsController.text}',
        'UnitSalesYearly': '${_plannedUnitSalesYearlyController.text} units',
        'Hours': '${_plannedHoursController.text} hours',
        'Costs': 'RM ${_plannedCostsController.text}',
        'MaterialUsage': 'RM ${_plannedMaterialUsageController.text}',
        'ResourceUtilization': 'RM ${_plannedResourceUtilizationController.text}',
        'WasteReductionTarget': _plannedWasteReductionTargetController.text,
        'TotalProduction': _plannedTotalProductionController.text,
        'WasteReduction': _plannedWasteReductionController.text,
        'TimeToMarket': '${_plannedTimeToMarketController.text} days',
        'Value': 'RM ${_plannedValueController.text}',
        'AddedTime': '${_plannedAddedTimeController.text} minute',
        'TotalCycleTime': '${_plannedTotalCycleTimeController.text} minute',
        'PCE': '${_plannedPCEController.text} %',
        'TotalResourceAllocation': 'RM ${_totalPlannedResourceAllocationController.text}',
        'PrototypeIterationTime': _plannedTotalPrototypeIterationTimeController.text,
        'TotalOutput': '${_plannedTotalOutputController.text} units',
        'TotalInput': 'RM ${_plannedTotalInputController.text}',
        'ManufacturingEfficiency': _plannedManufacturingEfficiencyController.text,
        'CycleTime': '${_plannedCycleTimeController.text} $_selectedFormat',
        'TargetCycleTime': '${_plannedTargetCycleTimeController.text} $_selectedFormat',
        'CycleTimeReduction': _plannedCycleTimeReductionController.text,
        'MileatonesAchievement': _totalPlannedMilestoneController.text,
        'DeliveryTime': '${_plannedDeliveryTimeController.text} $_selectedFormat',
        'BudgetCosts': 'RM ${_plannedBudgetCostsController.text}',
        'Compliance': _plannedComplianceController.text,
        'Innovation': _plannedInnovationController.text,
        'Responsiveness': _plannedResponsivenessController.text,
        'Sustainability': _plannedSustainabilityController.text,
        'RiskManagement': _plannedRiskManagementController.text,
        'Collaboration': _plannedCollaborationController.text,
        'ServiceLevels': _plannedServiceLevelsController.text,
        'TargetQualityStandard': '${_plannedQualityStandardController.text} %',
        'AccuracyOfOrdersPlaced': '${_plannedAccuracyController.text} %',
        'ExpectedLeadTime': '${_plannedLeadTimeController.text} days',
        'Flexibility': _plannedFlexibilityController.text,
        'CommunicationEfficiency': '${_plannedCommunicationEfficiencyController.text} %',
        'Reliability': '${_plannedReliabilityController.text} %',
        'SupplierEfficiency': _plannedSupplierEfficiencyController.text,
      };

      await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('products')
          .doc(widget.productId)
          .collection('actual')
          .doc('efficiency')
          .set(efficiencyData);

      _showSuccessMessage('Efficiency data saved successfully!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EffectivenessFactors1Page(projectId: widget.projectId, productId: widget.productId)),
      );
    } catch (e) {
      _showErrorMessage('Failed to save efficiency data: $e');
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green, 
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String? _validatePlannedLaborCost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the planned labor cost';
    }
    return null;
  }

  String? _validatePlannedMaterialCost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the planned material cost';
    }
    return null;
  }

  String? _validatePlannedOverheadCost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the planned overhead cost';
    }
    return null;
  }

  String? _validateOtherPlannedCost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the other planned cost';
    }
    return null;
  }

  void _updatePlannedDevCost() {
    final otherPlannedCost = int.tryParse(_otherPlannedCostController.text) ?? 0;
    final plannedOverheadCost = int.tryParse(_plannedOverheadCostController.text) ?? 0;
    final plannedMaterialCost = int.tryParse(_plannedMaterialCostController.text) ?? 0;
    final plannedLaborCost = int.tryParse(_plannedLaborCostController.text) ?? 0;

    final totalPlannedDevCost = otherPlannedCost + plannedOverheadCost + plannedMaterialCost + plannedLaborCost;
    _plannedDevCostController.text = totalPlannedDevCost.toString();
  }

  String? _validatePlannedUnitSales(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the planned unit sales';
    }
    return null;
  }

  String? _validatePlannedMarketShare(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter market share';
    }

    final regex = RegExp(r'^\d{1,3}(\.\d{1,2})?$');

    if (!regex.hasMatch(value)) {
      return 'Please enter a valid number in the format 0.00';
    }

    final marketShare = double.tryParse(value) ?? 0.0;
    if (marketShare < 0.0 || marketShare > 100.0) {
      return 'Please enter a value between 0.00 and 100.00';
    }

    return null; 
  }

  String? _validatePlannedRevenue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter planned revenue';
    }
    return null;
  }

  String? _validateMaxPlannedUnitSales(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the maximum planned unit sales';
    }
    return null;
  }

  String? _validateMaxPlannedRevenue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the maximum planned revenue';
    }
    return null;
  }

  void _updatePlannedProductPerformance() {
    final normalizeUnitSales = double.tryParse(_normalizedPlannedUnitSalesController.text) ?? 0.0;
    final plannedMarketShare = double.tryParse(_plannedMarketShareController.text) ?? 0.0;
    final normalizeRevenue = double.tryParse(_normalizedPlannedRevenueController.text) ?? 0.0;
    final totalPercentages = [normalizeUnitSales, plannedMarketShare, normalizeRevenue];
    final averagePerformance = totalPercentages.reduce((a, b) => a + b) / totalPercentages.length;
    final cappedPerformance = averagePerformance > 100.0 ? 100.0 : averagePerformance;
    _plannedProductPerformanceController.text = cappedPerformance.toStringAsFixed(2);
  }

  void _updateNormalizedPlannedUnitSales() {
    final plannedUnitSales = int.tryParse(_plannedUnitSalesController.text) ?? 0;
    final maxPlannedUnitSales = int.tryParse(_maxPlannedUnitSalesController.text) ?? 0;

    if (maxPlannedUnitSales > 0) {
      final normalizedPlannedUnitSales = (plannedUnitSales / maxPlannedUnitSales) * 100;
      _normalizedPlannedUnitSalesController.text = normalizedPlannedUnitSales.toStringAsFixed(2);
    } else {
      _normalizedPlannedUnitSalesController.text = '0.00';
    }
  }

  void _updateNormalizedPlannedRevenue() {
    final plannedRevenue = double.tryParse(_plannedRevenueController.text) ?? 0.0;
    final maxPlannedRevenue = double.tryParse(_maxPlannedRevenueController.text) ?? 0.0;

    if (maxPlannedRevenue > 0) {
      final normalizedPlannedRevenue = (plannedRevenue / maxPlannedRevenue) * 100;
      _normalizedPlannedRevenueController.text = normalizedPlannedRevenue.toStringAsFixed(2);
    } else {
      _normalizedPlannedRevenueController.text = '0.00';
    }
  }

  void _updatePlannedQualityGoals() {
    setState(() {
      final totalPlannedQualityGoals = (_defectRate + _customerSatisfaction + _complianceRate) * 100;
      _plannedQualityGoalsController.text = totalPlannedQualityGoals.toStringAsFixed(2);
    });
  }

  String? _validatePlannedDevelopmentCost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the planned development cost';
    }
    return null;
  }

  String? _validatePlannedProductionCost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the planned production cost';
    }
    return null;
  }

  String? _validatePlannedOperationalCost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the planned operational cost';
    }
    return null;
  }

  void _updatePlannedCostEfficiencyMetrics() {
    final plannedDevelopmentCost = int.tryParse(_plannedDevelopmentCostController.text) ?? 0;
    final plannedProductionCost = int.tryParse(_plannedProductionCostController.text) ?? 0;
    final plannedOperationalCost = int.tryParse(_plannedOperationalCostController.text) ?? 0;

    final totalPlannedCostEfficiency = plannedDevelopmentCost + plannedProductionCost + plannedOperationalCost;
    _plannedCostEfficiencyMetricsController.text = totalPlannedCostEfficiency.toString();
  }

  String? _validatePlannedUnitSalesYearly(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the planned development cost';
    }
    return null;
  }

  String? _validatePlannedHours(String? value) {
    final hours = int.tryParse(value ?? '');
    if (hours == null || hours < 0 || hours > 24) {
      return 'Please enter a valid number between 0 and 24';
    }
    return null;
  }

  String? _validatePlannedCosts(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the planned material cost';
    }
    return null;
  }

  void _updatePlannedResourceUtilization() {
    final plannedHours = int.tryParse(_plannedHoursController.text) ?? 0;
    final plannedCosts = double.tryParse(_plannedCostsController.text) ?? 0.0;
    final plannedMaterialUsage = double.tryParse(_plannedMaterialUsageController.text) ?? 0.0;
    final totalResourceUtilization = plannedHours + plannedCosts + plannedMaterialUsage;
    _plannedResourceUtilizationController.text = totalResourceUtilization.toStringAsFixed(2);
  }

  void _updateTimeToMarket() {
    final startDateText = _plannedStartDateController.text;
    final launchDateText = _plannedLaunchDateController.text;

    if (startDateText.isNotEmpty && launchDateText.isNotEmpty) {
      try {
        final start = DateFormat('dd-MM-yyyy').parse(startDateText);
        final launch = DateFormat('dd-MM-yyyy').parse(launchDateText);

        if (launch.isAfter(start)) {
          final timeToMarket = launch.difference(start).inDays;
          _plannedTimeToMarketController.text = timeToMarket.toString(); 
        } else {
          _plannedTimeToMarketController.text = '0'; 
        }
      } catch (e) {
        _plannedTimeToMarketController.text = '0'; 
      }
    } else {
      _plannedTimeToMarketController.text = '0'; 
    }
  }

  void _updatePlannedPCE() {
    final plannedValue = double.tryParse(_plannedValueController.text) ?? 0.0;
    final plannedAddedTime = double.tryParse(_plannedAddedTimeController.text) ?? 0.0;
    final plannedTotalCycleTime = double.tryParse(_plannedTotalCycleTimeController.text) ?? 0.0;

    if (plannedTotalCycleTime != 0) {
      final pce = ((plannedValue - plannedAddedTime) / plannedTotalCycleTime) * 100;
      _plannedPCEController.text = pce.toStringAsFixed(2);
    } else {
      _plannedPCEController.text = '0.00';
    }
  }

  String? _validateTotalPlannedResourceAllocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the planned resource allocation';
    }
    return null;
  }

  void _updatePlannedWasteReduction() {
    final totalProductionString = _plannedTotalProductionController.text;
    final wasteReductionTargetString = _plannedWasteReductionTargetController.text;
    final totalProduction = double.tryParse(totalProductionString);
    final wasteReductionTarget = double.tryParse(wasteReductionTargetString);
    double plannedWasteReduction;
    if (totalProduction != null && totalProduction > 0) {
      if (wasteReductionTarget != null) {
        plannedWasteReduction = wasteReductionTarget / totalProduction;
      } else {
        plannedWasteReduction = 0.0;
      }
    } else {
      plannedWasteReduction = 0.0;
    }
    _plannedWasteReductionController.text = plannedWasteReduction.toStringAsFixed(2); 
  }

  void _updatePCTR() {
    final plannedCycleTimeText = _plannedCycleTimeController.text;
    final plannedTargetCycleTimeText = _plannedTargetCycleTimeController.text;

    double plannedCycleTime = _convertToSeconds(plannedCycleTimeText, _selectedFormat);
    double plannedTargetCycleTime = _convertToSeconds(plannedTargetCycleTimeText, _selectedFormat);

    double plannedCTR = 0.0;
    if (plannedCycleTime != 0) {
      plannedCTR = (plannedCycleTime - plannedTargetCycleTime) / plannedCycleTime;
    }

    setState(() {
      _plannedCycleTimeReductionController.text = plannedCTR.toStringAsFixed(2);
    });
  }

  double _convertToSeconds(String timeText, String format) {
    double timeValue = double.tryParse(timeText) ?? 0.0;

    switch (format) {
      case 'HH':
        return timeValue * 3600;
      case 'MM':
        return timeValue * 60; 
      case 'SS':
        return timeValue; 
      case 'Days':
        return timeValue * 86400; 
      default:
        return 0.0;
    }
  }

  void _updatePlannedManufacturingEfficiency() {
    final plannedOutput = double.tryParse(_plannedTotalOutputController.text) ?? 0.0;
    final plannedInput = double.tryParse(_plannedTotalInputController.text) ?? 0.0;

    double plannedEfficiency = 0.0;
    if (plannedInput != 0) {
      plannedEfficiency = (plannedOutput / plannedInput) * 100;
    }

    setState(() {
      _plannedManufacturingEfficiencyController.text = plannedEfficiency.toStringAsFixed(2);
    });
  }

  void _calculateSupplierEfficiency() {
    double total = 0;

    double parseAndAddCurrency(String? text) {
      double value = double.tryParse(text?.replaceAll('RM', '').trim() ?? '') ?? 0;
      return value; 
    }

    double parseAndAddPercentage(String? text) {
      double value = double.tryParse(text?.replaceAll('%', '').trim() ?? '') ?? 0;
      return value / 100; 
    }

    double parseAndAddDays(String? text) {
      return double.tryParse(text?.trim() ?? '') ?? 0; 
    }

    double parseAndAddTime(String? text) {
      if (text == null || text.isEmpty) return 0;

      List<String> parts = text.split(':');
      double hours = double.tryParse(parts[0]) ?? 0;
      double minutes = parts.length > 1 ? double.tryParse(parts[1]) ?? 0 : 0;
      double seconds = parts.length > 2 ? double.tryParse(parts[2]) ?? 0 : 0;

      return hours + (minutes / 60) + (seconds / 3600); 
    }

    double parseAndAdd(String? text, {required String unit}) {
      switch (unit) {
        case 'currency':
          return parseAndAddCurrency(text);
        case 'percentage':
          return parseAndAddPercentage(text);
        case 'days':
          return parseAndAddDays(text);
        case 'time':
          return parseAndAddTime(text);
        default:
          return double.tryParse(text ?? '') ?? 0;
      }
    }

    total += parseAndAdd(_plannedDeliveryTimeController.text, unit: 'days');
    total += parseAndAdd(_plannedBudgetCostsController.text, unit: 'currency');
    total += parseAndAdd(_plannedComplianceController.text, unit: 'percentage');
    total += parseAndAdd(_plannedInnovationController.text, unit: 'percentage');
    total += parseAndAdd(_plannedResponsivenessController.text, unit: 'percentage');
    total += parseAndAdd(_plannedSustainabilityController.text, unit: 'percentage');
    total += parseAndAdd(_plannedRiskManagementController.text, unit: 'percentage');
    total += parseAndAdd(_plannedCollaborationController.text, unit: 'percentage');
    total += parseAndAdd(_plannedServiceLevelsController.text, unit: 'percentage');
    total += parseAndAdd(_plannedQualityStandardController.text, unit: 'percentage');
    total += parseAndAdd(_plannedAccuracyController.text, unit: 'percentage');
    total += parseAndAdd(_plannedLeadTimeController.text, unit: 'days');
    total += parseAndAdd(_plannedFlexibilityController.text, unit: 'percentage');
    total += parseAndAdd(_plannedCommunicationEfficiencyController.text, unit: 'percentage');
    total += parseAndAdd(_plannedReliabilityController.text, unit: 'percentage');

    _plannedSupplierEfficiencyController.text = total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Actual - Efficiency Factors',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: AppColor.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.deepGreen,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Development Lead Time :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            DatePicker(
                              controller: _plannedStartDateController,
                              hintText: "Select start date",
                              prefixIcon: Icons.calendar_today,
                              isValid: true,
                              onChanged: (value) {
                                setState(() {
                                  _startDate = DateFormat('dd-MM-yyyy').parse(value);
                                  _updatePlannedDuration();
                                  _updateTimeToMarket();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a planned start date';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'End Date :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            DatePicker(
                              controller: _plannedEndDateController,
                              hintText: "Select end date",
                              prefixIcon: Icons.calendar_today,
                              isValid: true,
                              minDate: _startDate, 
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedDuration(); 
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a planned end date';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Planned Dev. Lead Time :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomLeadTimeField(
                              startDateController: _plannedStartDateController,
                              endDateController: _plannedEndDateController,
                              leadTimeController: _plannedDurationController,
                              hintText: "Total Lead Time",
                              isValid: true,
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a planned duration';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Development Cost :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Labor Cost :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedLaborCostController,
                              hintText: 'Enter your labor costs',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedDevCost();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedLaborCostController.text) ?? 0;
                                _plannedLaborCostController.text = (currentValue + 1).toString();
                                _updatePlannedDevCost();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedLaborCostController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedLaborCostController.text = (currentValue - 1).toString();
                                  _updatePlannedDevCost();
                                }
                              },
                              validator: _validatePlannedLaborCost,
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Material Costs :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedMaterialCostController,
                              hintText: 'Enter your material costs',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedDevCost();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedMaterialCostController.text) ?? 0;
                                _plannedMaterialCostController.text = (currentValue + 1).toString();
                                _updatePlannedDevCost();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedMaterialCostController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedMaterialCostController.text = (currentValue - 1).toString();
                                  _updatePlannedDevCost();
                                }
                              },
                              validator: _validatePlannedMaterialCost,
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Overhead Costs :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedOverheadCostController,
                              hintText: 'Enter your overhead costs',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedDevCost();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedOverheadCostController.text) ?? 0;
                                _plannedOverheadCostController.text = (currentValue + 1).toString();
                                _updatePlannedDevCost();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedOverheadCostController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedOverheadCostController.text = (currentValue - 1).toString();
                                  _updatePlannedDevCost();
                                }
                              },
                              validator: _validatePlannedOverheadCost,
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Other Costs :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _otherPlannedCostController,
                              hintText: 'Enter your other costs',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedDevCost();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_otherPlannedCostController.text) ?? 0;
                                _otherPlannedCostController.text = (currentValue + 1).toString();
                                _updatePlannedDevCost();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_otherPlannedCostController.text) ?? 0;
                                if (currentValue > 0) {
                                  _otherPlannedCostController.text = (currentValue - 1).toString();
                                  _updatePlannedDevCost();
                                }
                              },
                              validator: _validateOtherPlannedCost,
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Development Cost :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedDevCostController,
                              hintText: 'Total Development Cost',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total cost should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Product Performance :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              'Unit Sales :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedUnitSalesController,
                              hintText: 'Enter your unit sales',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'unit',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedProductPerformance();
                                });
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedUnitSalesController.text) ?? 0;
                                _plannedUnitSalesController.text = (currentValue + 1).toString();
                                _updateNormalizedPlannedUnitSales();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedUnitSalesController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedUnitSalesController.text = (currentValue - 1).toString();
                                  _updateNormalizedPlannedUnitSales();
                                }
                              },
                              validator: _validatePlannedUnitSales,
                            ),

                            SizedBox(height: 20),
                            Text(
                              'Maximum Unit Sales :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _maxPlannedUnitSalesController,
                              hintText: 'Enter maximum unit sales',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'unit',
                              onChanged: (value) {
                                setState(() {
                                  _updateNormalizedPlannedUnitSales();
                                });
                              },
                              keyboardType: TextInputType.number, 
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_maxPlannedUnitSalesController.text) ?? 0;
                                _maxPlannedUnitSalesController.text = (currentValue + 1).toString();
                                _updateNormalizedPlannedUnitSales();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_maxPlannedUnitSalesController.text) ?? 0;
                                if (currentValue > 0) {
                                  _maxPlannedUnitSalesController.text = (currentValue - 1).toString();
                                  _updateNormalizedPlannedUnitSales();
                                }
                              },
                              validator: _validateMaxPlannedUnitSales,
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Normalized Unit Sales :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _normalizedPlannedUnitSalesController,
                              hintText: 'Normalized unit sales (%)',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: '%',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Normalized value should be calculated';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 10),

                            Divider(
                              thickness: 0.5,
                              color: Colors.black,
                            ),

                            SizedBox(height: 10),

                            Text(
                              'Planned Market Share :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedMarketShareController,
                              hintText: 'Enter your market share',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: '%',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedProductPerformance();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedMarketShareController.text) ?? 0;
                                _plannedMarketShareController.text = (currentValue + 1).toString();
                                _updatePlannedProductPerformance();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedMarketShareController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedMarketShareController.text = (currentValue - 1).toString();
                                  _updatePlannedProductPerformance();
                                }
                              },
                              validator: _validatePlannedMarketShare,
                            ),

                            SizedBox(height: 10),

                            Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 10),

                            Text(
                              'Planned Revenue :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedRevenueController,
                              hintText: 'Enter your revenue',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedProductPerformance();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedRevenueController.text) ?? 0;
                                _plannedRevenueController.text = (currentValue + 1).toString();
                                _updatePlannedProductPerformance();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedRevenueController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedRevenueController.text = (currentValue - 1).toString();
                                  _updatePlannedProductPerformance();
                                }
                              },
                              validator: _validatePlannedRevenue,
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Maximum Revenue :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _maxPlannedRevenueController,
                              hintText: 'Enter maximum revenue',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updateNormalizedPlannedRevenue();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_maxPlannedRevenueController.text) ?? 0;
                                _maxPlannedRevenueController.text = (currentValue + 1).toString();
                                _updateNormalizedPlannedRevenue();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_maxPlannedRevenueController.text) ?? 0;
                                if (currentValue > 0) {
                                  _maxPlannedRevenueController.text = (currentValue - 1).toString();
                                  _updateNormalizedPlannedRevenue();
                                }
                              },
                              validator: _validateMaxPlannedRevenue,
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Normalized Revenue :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _normalizedPlannedRevenueController,
                              hintText: 'Normalized Revenue',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: '%',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Normalized revenue should be calculated';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 10),

                            Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 10),
                            Text(
                              'Product Performance :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedProductPerformanceController,
                              hintText: 'Total Product Performance',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: '%',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total cost should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Quality Product :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Defect Rate :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            _buildProgressSlider('Planned Defect Rate', _defectRate, (newDefectRate) {
                              setState(() {
                                _defectRate = newDefectRate;
                                _updatePlannedQualityGoals();
                              });
                            }),
                            SizedBox(height: 20),
                            Text(
                              'Customer Satisfaction Rate :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            _buildProgressSlider('Planned Customer Satisfaction Score', _customerSatisfaction, (newCustomerSatisfaction) {
                              setState(() {
                                _customerSatisfaction = newCustomerSatisfaction;
                                _updatePlannedQualityGoals();
                              });
                            }),
                            SizedBox(height: 20),
                            Text(
                              ' Compliance Rate :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            _buildProgressSlider('Planned Compliance Rate', _complianceRate, (newComplianceRate) {
                              setState(() {
                                _complianceRate = newComplianceRate;
                                _updatePlannedQualityGoals();
                              });
                            }),
                            SizedBox(height: 20),
                            Text(
                              ' Quality Goals :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedQualityGoalsController,
                              hintText: 'Planned Quality Goals',
                              prefixIcon: Icons.assessment,
                              isValid: true,
                              suffixText: '%',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Planned Quality Goals should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Launched On Time :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Launch Date :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            DatePicker(
                              controller: _plannedLaunchDateController,
                              hintText: "Select scheduled launch date",
                              prefixIcon: Icons.calendar_today,
                              isValid: true,
                              onChanged: (value) {
                                setState(() {
                                  _launchDate = DateFormat('dd-MM-yyyy').parse(value);
                                  _updateTimeToMarket();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a planned launch date';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Cost Efficiency :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Development Cost :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedDevelopmentCostController,
                              hintText: 'Enter your development costs',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedCostEfficiencyMetrics();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedDevelopmentCostController.text) ?? 0;
                                _plannedDevelopmentCostController.text = (currentValue + 1).toString();
                                _updatePlannedCostEfficiencyMetrics();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedDevelopmentCostController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedDevelopmentCostController.text = (currentValue - 1).toString();
                                  _updatePlannedCostEfficiencyMetrics();
                                }
                              },
                              validator: _validatePlannedDevelopmentCost,
                            ),

                            SizedBox(height: 20),

                            Text(
                              ' Production Costs :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedProductionCostController,
                              hintText: 'Enter your production costs',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedCostEfficiencyMetrics();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedProductionCostController.text) ?? 0;
                                _plannedProductionCostController.text = (currentValue + 1).toString();
                                _updatePlannedCostEfficiencyMetrics();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedProductionCostController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedProductionCostController.text = (currentValue - 1).toString();
                                  _updatePlannedCostEfficiencyMetrics();
                                }
                              },
                              validator: _validatePlannedProductionCost,
                            ),

                            SizedBox(height: 20),

                            Text(
                              ' Operational Costs :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedOperationalCostController,
                              hintText: 'Enter your operational costs',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedCostEfficiencyMetrics();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedOperationalCostController.text) ?? 0;
                                _plannedOperationalCostController.text = (currentValue + 1).toString();
                                _updatePlannedCostEfficiencyMetrics();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedOperationalCostController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedOperationalCostController.text = (currentValue - 1).toString();
                                  _updatePlannedCostEfficiencyMetrics();
                                }
                              },
                              validator: _validatePlannedOperationalCost,
                            ),

                            SizedBox(height: 20),

                            Text(
                              ' Cost Efficiency Metrics :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedCostEfficiencyMetricsController,
                              hintText: 'Total Cost Efficiency Metrics',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total cost efficiency should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Yearly unit sales :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Unit Sales (Yearly) :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedUnitSalesYearlyController,
                              hintText: 'Enter your planned unit sales (yearly)',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'Units',
                              keyboardType: TextInputType.number, 
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly 
                              ],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedUnitSalesYearlyController.text) ?? 0;
                                _plannedUnitSalesYearlyController.text = (currentValue + 1).toString();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedUnitSalesYearlyController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedUnitSalesYearlyController.text = (currentValue - 1).toString();
                                }
                              },
                              validator: _validatePlannedUnitSalesYearly,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Resource utilization :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Hours :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedHoursController,
                              hintText: 'Enter your hours',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'Hours',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedResourceUtilization();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                LengthLimitingTextInputFormatter(2),
                              ],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedHoursController.text) ?? 0;
                                if (currentValue < 24) {
                                  _plannedHoursController.text = (currentValue + 1).toString();
                                  _updatePlannedResourceUtilization();
                                }
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedHoursController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedHoursController.text = (currentValue - 1).toString();
                                  _updatePlannedResourceUtilization();
                                }
                              },
                              validator: _validatePlannedHours,
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Costs :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedCostsController,
                              hintText: 'Enter your costs',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedResourceUtilization();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedCostsController.text) ?? 0;
                                _plannedCostsController.text = (currentValue + 1).toString();
                                _updatePlannedResourceUtilization();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedCostsController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedCostsController.text = (currentValue - 1).toString();
                                  _updatePlannedResourceUtilization();
                                }
                              },
                              validator: _validatePlannedCosts,
                            ),

                            SizedBox(height: 20),

                            Text(
                              ' Material Usage :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedMaterialUsageController,
                              hintText: 'Enter your material usage',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedResourceUtilization();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = double.tryParse(_plannedMaterialUsageController.text) ?? 0.0;
                                _plannedMaterialUsageController.text = (currentValue + 1).toStringAsFixed(2);
                                _updatePlannedResourceUtilization();
                              },
                              onDecrement: () {
                                final currentValue = double.tryParse(_plannedMaterialUsageController.text) ?? 0.0;
                                if (currentValue > 0) {
                                  _plannedMaterialUsageController.text = (currentValue - 1).toStringAsFixed(2);
                                  _updatePlannedResourceUtilization();
                                }
                              },
                              validator: (value) {
                                final materialUsage = double.tryParse(value ?? '');
                                if (materialUsage == null || materialUsage < 0) {
                                  return 'Please enter a valid number greater than or equal to 0';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            Text(
                              ' Resource Utilization :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedResourceUtilizationController,
                              hintText: 'Total Resource Utilization',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total cost should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Time To Market :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Time To Market :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedTimeToMarketController,
                              hintText: "Total Time To Market",
                              prefixIcon: Icons.timeline,
                              isValid: true,
                              suffixText: 'Days',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total time to market should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        ' Cycle Efficiency :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Value :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedValueController,
                              hintText: 'Enter your value',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedPCE();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = double.tryParse(_plannedValueController.text) ?? 0.0;
                                _plannedValueController.text = (currentValue + 1).toString();
                                _updatePlannedPCE();
                              },
                              onDecrement: () {
                                final currentValue = double.tryParse(_plannedValueController.text) ?? 0.0;
                                if (currentValue > 0) {
                                  _plannedValueController.text = (currentValue - 1).toString();
                                  _updatePlannedPCE();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Added Time :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedAddedTimeController,
                              hintText: 'Enter your added time (MM)',
                              prefixIcon: Icons.access_time,
                              isValid: true,
                              suffixText: 'minute',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedPCE();
                                });
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                final minutes = int.tryParse(value);
                                if (minutes == null || minutes < 0) {
                                  return 'Invalid input. Enter a positive number of minutes';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Total Cycle Time :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedTotalCycleTimeController,
                              hintText: 'Enter total cycle time (MM)',
                              prefixIcon: Icons.access_time,
                              isValid: true,
                              suffixText: 'minute',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedPCE();
                                });
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly, 
                              ],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                final minutes = int.tryParse(value);
                                if (minutes == null || minutes < 0) {
                                  return 'Invalid input. Enter a positive number of minutes';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Process Cycle Efficiency (PCE) :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedPCEController,
                              hintText: 'Total PCE',
                              prefixIcon: Icons.percent,
                              isValid: true,
                              suffixText: '%',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total PCE should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Resource Allocation Efficiency :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Resource Allocation :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _totalPlannedResourceAllocationController,
                              hintText: 'Enter total resource allocation',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_totalPlannedResourceAllocationController.text) ?? 0;
                                _totalPlannedResourceAllocationController.text = (currentValue + 1).toString();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_totalPlannedResourceAllocationController.text) ?? 0;
                                if (currentValue > 0) {
                                  _totalPlannedResourceAllocationController.text = (currentValue - 1).toString();
                                }
                              },
                              validator: _validateTotalPlannedResourceAllocation,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Prototype Iteration Time :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Prototype Iteration Time :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedTotalPrototypeIterationTimeController,
                              hintText: 'Enter your total prototype iteration time',
                              prefixIcon: Icons.access_time,
                              isValid: true,
                              suffixText: 'HH:MM',
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')), 
                              ],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                final timeRegExp = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
                                if (!timeRegExp.hasMatch(value)) {
                                  return 'Invalid format. Enter time in HH:MM format';
                                }
                                final parts = value.split(':');
                                final hours = int.tryParse(parts[0]);
                                final minutes = int.tryParse(parts[1]);
                                if (hours == null || minutes == null || hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
                                  return 'Invalid time. Ensure hours are between 00-23 and minutes are between 00-59';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Waste Reduction :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Waste Reduction Target :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedWasteReductionTargetController,
                              hintText: 'Enter your value',
                              prefixIcon: Icons.tab, 
                              isValid: true,
                              suffixText: '',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedWasteReduction();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                              ],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = double.tryParse(_plannedWasteReductionTargetController.text) ?? 0.0;
                                _plannedWasteReductionTargetController.text = (currentValue + 1).toStringAsFixed(2); 
                                _updatePlannedWasteReduction();
                              },
                              onDecrement: () {
                                final currentValue = double.tryParse(_plannedWasteReductionTargetController.text) ?? 0.0;
                                if (currentValue > 0) {
                                  _plannedWasteReductionTargetController.text = (currentValue - 1).toStringAsFixed(2); 
                                  _updatePlannedWasteReduction();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                final numericValue = double.tryParse(value);
                                if (numericValue == null || numericValue < 0) {
                                  return 'Please enter a valid positive number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Total Production :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedTotalProductionController,
                              hintText: 'Enter total production value',
                              prefixIcon: Icons.assessment, 
                              isValid: true,
                              suffixText: '',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedWasteReduction();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), 
                              ],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                final productionValue = double.tryParse(value);
                                if (productionValue == null || productionValue < 0) {
                                  return 'Invalid input. Enter a positive number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Waste Reduction :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedWasteReductionController,
                              hintText: 'Total Waste Reduction',
                              prefixIcon: Icons.pie_chart,
                              isValid: true,
                              suffixText: '',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total waste reduction should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        ' Manufacturing Efficiency :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Output :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedTotalOutputController,
                              hintText: 'Enter your total output',
                              prefixIcon: Icons.output,
                              isValid: true,
                              suffixText: 'units',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedManufacturingEfficiency();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                              ],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = double.tryParse(_plannedTotalOutputController.text) ?? 0.0;
                                _plannedTotalOutputController.text = (currentValue + 1).toStringAsFixed(2);
                                _updatePlannedManufacturingEfficiency();
                              },
                              onDecrement: () {
                                final currentValue = double.tryParse(_plannedTotalOutputController.text) ?? 0.0;
                                if (currentValue > 0) {
                                  _plannedTotalOutputController.text = (currentValue - 1).toStringAsFixed(2); 
                                  _updatePlannedManufacturingEfficiency();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter total output';
                                }
                                final numericValue = double.tryParse(value);
                                if (numericValue == null || numericValue < 0) {
                                  return 'Please enter a valid positive number for total output';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Input :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedTotalInputController,
                              hintText: 'Enter your total input',
                              prefixIcon: Icons.input,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedManufacturingEfficiency();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                              ],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = double.tryParse(_plannedTotalInputController.text) ?? 0.0;
                                _plannedTotalInputController.text = (currentValue + 1).toStringAsFixed(2); 
                                _updatePlannedManufacturingEfficiency();
                              },
                              onDecrement: () {
                                final currentValue = double.tryParse(_plannedTotalInputController.text) ?? 0.0;
                                if (currentValue > 0) {
                                  _plannedTotalInputController.text = (currentValue - 1).toStringAsFixed(2);
                                  _updatePlannedManufacturingEfficiency();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter total input';
                                }
                                final numericValue = double.tryParse(value);
                                if (numericValue == null || numericValue < 0) {
                                  return 'Please enter a valid positive number for total input';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Manufacturing Efficiency :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedManufacturingEfficiencyController,
                              hintText: 'Total Manufacturing Efficiency',
                              prefixIcon: Icons.pie_chart, 
                              isValid: true,
                              suffixText: '',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total manufacturing efficiency should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Cycle Time Reduction :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Cycle Time :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            DropdownButton<String>(
                              value: _selectedFormat,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedFormat = newValue!;
                                  _plannedCycleTimeController.clear();
                                });
                              },
                              items: _formats.map<DropdownMenuItem<String>>((String format) {
                                return DropdownMenuItem<String>(
                                  value: format,
                                  child: Text(format),
                                );
                              }).toList(),
                            ),
                            CustomTextFieldNew(
                              controller: _plannedCycleTimeController,
                              hintText: 'Enter your initial cycle time before reduction efforts',
                              prefixIcon: Icons.access_time,
                              isValid: true,
                              suffixText: _selectedFormat,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(_selectedFormat == 'Days' ? r'[0-9]' : r'[0-9]')
                                ), 
                              ],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }

                                if (_selectedFormat == 'HH') {
                                  final hours = int.tryParse(value);
                                  if (hours == null || hours < 0 || hours > 23) {
                                    return 'Invalid hours. Ensure it is between 00 and 23';
                                  }
                                } else if (_selectedFormat == 'MM') {
                                  final minutes = int.tryParse(value);
                                  if (minutes == null || minutes < 0 || minutes > 59) {
                                    return 'Invalid minutes. Ensure it is between 00 and 59';
                                  }
                                } else if (_selectedFormat == 'SS') {
                                  final seconds = int.tryParse(value);
                                  if (seconds == null || seconds < 0 || seconds > 59) {
                                    return 'Invalid seconds. Ensure it is between 00 and 59';
                                  }
                                } else if (_selectedFormat == 'Days') {
                                  final days = int.tryParse(value);
                                  if (days == null || days < 0) {
                                    return 'Invalid number of days';
                                  }
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Target Cycle Time :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            DropdownButton<String>(
                              value: _selectedFormat,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedFormat = newValue!;
                                  _plannedTargetCycleTimeController.clear();
                                });
                              },
                              items: _formats.map<DropdownMenuItem<String>>((String format) {
                                return DropdownMenuItem<String>(
                                  value: format,
                                  child: Text(format),
                                );
                              }).toList(),
                            ),
                            CustomTextFieldNew(
                              controller: _plannedTargetCycleTimeController,
                              hintText: 'Enter your cycle time that you aim to achieve after reduction efforts',
                              prefixIcon: Icons.access_time,
                              isValid: true,
                              suffixText: _selectedFormat,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(_selectedFormat == 'Days' ? r'[0-9]' : r'[0-9]')
                                ), 
                              ],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }

                                if (_selectedFormat == 'HH') {
                                  final hours = int.tryParse(value);
                                  if (hours == null || hours < 0 || hours > 23) {
                                    return 'Invalid hours. Ensure it is between 00 and 23';
                                  }
                                } else if (_selectedFormat == 'MM') {
                                  final minutes = int.tryParse(value);
                                  if (minutes == null || minutes < 0 || minutes > 59) {
                                    return 'Invalid minutes. Ensure it is between 00 and 59';
                                  }
                                } else if (_selectedFormat == 'SS') {
                                  final seconds = int.tryParse(value);
                                  if (seconds == null || seconds < 0 || seconds > 59) {
                                    return 'Invalid seconds. Ensure it is between 00 and 59';
                                  }
                                } else if (_selectedFormat == 'Days') {
                                  final days = int.tryParse(value);
                                  if (days == null || days < 0) {
                                    return 'Invalid number of days';
                                  }
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Cycle Time Reduction :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedCycleTimeReductionController,
                              hintText: 'Total Cycle Time Reduction',
                              prefixIcon: Icons.timeline, 
                              isValid: true,
                              suffixText: '',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total waste reduction should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Milestones Achievement :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Milestones Achievement:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _totalPlannedMilestoneController,
                              hintText: 'Enter total number of milestones set for the process',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: '',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                final intValue = int.tryParse(value);
                                if (intValue == null || intValue <= 0) {
                                  return 'Please enter a valid positive number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Supplier Efficiency :',
                        style: AppFonts.text16Bold(AppColor.white),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' Delivery Time:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            DropdownButton<String>(
                              value: _selectedFormat,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedFormat = newValue!;
                                  _plannedDeliveryTimeController.clear();
                                });
                              },
                              items: _formats.map<DropdownMenuItem<String>>((String format) {
                                return DropdownMenuItem<String>(
                                  value: format,
                                  child: Text(format),
                                );
                              }).toList(),
                            ),
                            CustomTextFieldNew(
                              controller: _plannedDeliveryTimeController,
                              hintText: 'Enter estimated delivery dates for material and services',
                              prefixIcon: Icons.access_time,
                              isValid: true,
                              suffixText: _selectedFormat,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(_selectedFormat == 'Days' ? r'[0-9]' : r'[0-9]')),
                              ], 
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }

                                if (_selectedFormat == 'HH') {
                                  final hours = int.tryParse(value);
                                  if (hours == null || hours < 0 || hours > 23) {
                                    return 'Invalid hours. Ensure it is between 00 and 23';
                                  }
                                } else if (_selectedFormat == 'MM') {
                                  final minutes = int.tryParse(value);
                                  if (minutes == null || minutes < 0 || minutes > 59) {
                                    return 'Invalid minutes. Ensure it is between 00 and 59';
                                  }
                                } else if (_selectedFormat == 'SS') {
                                  final seconds = int.tryParse(value);
                                  if (seconds == null || seconds < 0 || seconds > 59) {
                                    return 'Invalid seconds. Ensure it is between 00 and 59';
                                  }
                                } else if (_selectedFormat == 'Days') {
                                  final days = int.tryParse(value);
                                  if (days == null || days < 0) {
                                    return 'Invalid number of days';
                                  }
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Budget Costs:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedBudgetCostsController,
                              hintText: 'Enter your budget costs',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {});
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                              ],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue =
                                    double.tryParse(_plannedBudgetCostsController.text) ?? 0.0;
                                _plannedBudgetCostsController.text = (currentValue + 1).toString();
                              },
                              onDecrement: () {
                                final currentValue =
                                    double.tryParse(_plannedBudgetCostsController.text) ?? 0.0;
                                if (currentValue > 0) {
                                  _plannedBudgetCostsController.text = (currentValue - 1).toString();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your budget costs';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Compliance with Regulations:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedComplianceController,
                              hintText: 'Enter compliance requirements',
                              prefixIcon: Icons.rule,
                              isValid: true,
                              suffixText: '',
                              keyboardType: TextInputType.text,
                              inputFormatters: [],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter compliance requirements';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Innovation:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedInnovationController,
                              hintText: 'Enter innovation targets',
                              prefixIcon: Icons.lightbulb,
                              isValid: true,
                              suffixText: '',
                              keyboardType: TextInputType.text,
                              inputFormatters: [],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter innovation targets';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Responsiveness:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedResponsivenessController,
                              hintText: 'Enter responsiveness targets',
                              prefixIcon: Icons.speed,
                              isValid: true,
                              suffixText: '',
                              keyboardType: TextInputType.text,
                              inputFormatters: [],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter responsiveness targets';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Sustainability Practices:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedSustainabilityController,
                              hintText: 'Enter sustainability practices',
                              prefixIcon: Icons.eco,
                              isValid: true,
                              suffixText: '',
                              keyboardType: TextInputType.text,
                              inputFormatters: [],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a sustainability practices';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Risk Management:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedRiskManagementController,
                              hintText: 'Enter risk management strategies',
                              prefixIcon: Icons.warning,
                              isValid: true,
                              suffixText: '',
                              keyboardType: TextInputType.text,
                              inputFormatters: [],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a risk management strategies';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Collaboration and Partnership:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedCollaborationController,
                              hintText: 'Enter collaboration and partnership plans',
                              prefixIcon: Icons.group,
                              isValid: true,
                              suffixText: '',
                              keyboardType: TextInputType.text,
                              inputFormatters: [],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a collaboration and partnership plans';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Service Levels:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedServiceLevelsController,
                              hintText: 'Enter service level targets',
                              prefixIcon: Icons.local_shipping,
                              isValid: true,
                              suffixText: '',
                              keyboardType: TextInputType.text,
                              inputFormatters: [],
                              showIncrementDecrement: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a service level targets';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Target Quality Standard:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedQualityStandardController,
                              hintText: 'Enter your quality standards',
                              prefixIcon: Icons.verified,
                              isValid: true,
                              suffixText: '%',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a quality standards';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Accuracy of Orders Placed:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedAccuracyController,
                              hintText: 'Enter order accuracy',
                              prefixIcon: Icons.assignment_turned_in,
                              isValid: true,
                              suffixText: '%',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter accuracy';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Lead Time:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedLeadTimeController,
                              hintText: 'Enter expected lead time',
                              prefixIcon: Icons.timer,
                              isValid: true,
                              suffixText: 'Days',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+'))],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an expected lead time';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Flexibility:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedFlexibilityController,
                              hintText: 'Enter flexibility details',
                              prefixIcon: Icons.loop,
                              isValid: true,
                              suffixText: '',
                              keyboardType: TextInputType.text,
                              inputFormatters: [],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a flexibility details';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Communication Efficiency:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedCommunicationEfficiencyController,
                              hintText: 'Enter communication efficiency details',
                              prefixIcon: Icons.people,
                              isValid: true,
                              suffixText: '%',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a communication efficiency detail';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Reliability:',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedReliabilityController,
                              hintText: 'Enter reliability details',
                              prefixIcon: Icons.security,
                              isValid: true,
                              suffixText: '%',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a reliability details';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              ' Supplier Efficiency :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedSupplierEfficiencyController,
                              hintText: 'Total Supplier Efficiency',
                              prefixIcon: Icons.support, 
                              isValid: true,
                              suffixText: '',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total supplier efficiency should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewSelectedProjectID(projectId: widget.projectId)),
                    );
                  },
                  child: Text('Cancel', style: AppFonts.text16Bold(AppColor.deepGreen)),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveEfficiency();
                    } else{
                      setState(() {
                        _showError = true;
                      });
                    }
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColor.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.deepGreen,
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updatePlannedDuration() {
    final plannedStartDateText = _plannedStartDateController.text;
    final plannedEndDateText = _plannedEndDateController.text;

    if (plannedStartDateText.isNotEmpty && plannedEndDateText.isNotEmpty) {
      try {
        final start = DateFormat('dd-MM-yyyy').parse(plannedStartDateText);
        final end = DateFormat('dd-MM-yyyy').parse(plannedEndDateText);

        if (end.isAfter(start)) {
          final duration = end.difference(start).inDays;
          _plannedDurationController.text = duration.toString();
        } else {
          _plannedDurationController.text = '0';
        }
      } catch (e) {
        _plannedDurationController.text = '0'; 
      }
    } else {
      _plannedDurationController.text = '0'; 
    }
  }

  Widget _buildProgressSlider(String label, double value, ValueChanged<double> onChanged) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.deepGreen1),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$label: ${(value * 100).toInt()}%'),
            Slider(
              value: value,
              onChanged: onChanged,
              min: 0.0,
              max: 1.0,
              divisions: 100,
              label: '${(value * 100).toInt()}%',
            ),
          ],
        ),
      ),
    );
  }
}
