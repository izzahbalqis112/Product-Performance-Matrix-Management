import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../../../../../../common/appColors.dart';
import '../../../../../../../../../common/appFonts.dart';
import '../../../../../../../../../common/widget/customScalePrecentage.dart';
import '../../../../../../../../../common/widget/customScaleTextField.dart';
import '../../../../../../../../../common/widget/customTextFieldNew.dart';
import 'package:file_picker/file_picker.dart';
import '../../../selectedProjectID.dart';

class EffectivenessFactorsPage extends StatefulWidget {
  final String projectId;
  final String productId;

  EffectivenessFactorsPage({required this.projectId, required this.productId});

  @override
  _EffectivenessFactorsPageState createState() => _EffectivenessFactorsPageState();
}

class _EffectivenessFactorsPageState extends State<EffectivenessFactorsPage>{
  final _formKey = GlobalKey<FormState>();
  final _plannedUnitSalesController = TextEditingController();
  final _plannedMarketSharePercentageController = TextEditingController();
  final _plannnedCustomerAcceptanceRateController = TextEditingController();
  final _plannedCustomerSatisfactionController = TextEditingController();
  final _plannedNetProfitController = TextEditingController();
  final _plannedSalesRevenueController = TextEditingController();
  final _plannedROSController = TextEditingController();
  final plannedFixedCostsController = TextEditingController();
  final plannedSellingPerUnitController = TextEditingController();
  final plannedVariableCostPerUnitController = TextEditingController();
  final _plannedBreakevenPointController = TextEditingController();
  final _plannedBreakevenPointRevenueController = TextEditingController();
  final plannedVariableCostsController = TextEditingController();
  final _plannedProfitController = TextEditingController();
  final salesVolumeController = TextEditingController();
  final customerSatisfactionController = TextEditingController();
  final productDefectRateController = TextEditingController();
  final _plannedProductPerformanceController = TextEditingController();
  final salesVolumeMaxController = TextEditingController();
  final numberOfAdoptersController = TextEditingController();
  final totalMarketSizeController = TextEditingController();
  final customerAdoptionRateController = TextEditingController();
  final qualityTargetController = TextEditingController();
  final totalUnitsController = TextEditingController();
  final qualityMetricsController = TextEditingController();
  final numberOfInnovationsController = TextEditingController();
  final timePeriodController = TextEditingController();
  final innovationRateController = TextEditingController();
  DateTime? selectedDate;
  final _scaleController = TextEditingController();
  final numberOfCopiesController = TextEditingController();
  final numberOfRewardsController = TextEditingController();
  final totalRevenue = TextEditingController();
  final totalCost = TextEditingController();
  final totalGrossProfit = TextEditingController();
  final totalGrossMargin = TextEditingController();
  final totalContributionMargin = TextEditingController();
  final totalROI = TextEditingController();
  final totalMP = TextEditingController();
  final _plannedTotalTAM = TextEditingController();
  final totalCompetitivePenetration = TextEditingController();
  final _plannedTotalMarketDemand = TextEditingController();
  final _cfsController = TextEditingController();
  final resolvedTicketsController = TextEditingController();
  final totalTicketsController = TextEditingController();
  final resolutionTimesController = TextEditingController();
  final numberOfTicketsController = TextEditingController();
  final totalPLSEController = TextEditingController();
  final totalARTController = TextEditingController();
  double plse = 0.0;
  double art = 0.0;
  final numberOfFeaturesAlignedController = TextEditingController();
  final totalPlannedFeaturesController = TextEditingController();
  final mdaController = TextEditingController();
  bool _showError = false;
  List<PlatformFile> _files = [];
  List<PlatformFile> _files1 = [];

  @override
  void initState() {
    super.initState();
    _plannedSalesRevenueController.addListener(_updatePlannedProfit);
    plannedFixedCostsController.addListener(_updatePlannedProfit);
    plannedVariableCostsController.addListener(_updatePlannedProfit);
    _plannedNetProfitController.addListener(_updatePlannedROS);
    _plannedSalesRevenueController.addListener(_updatePlannedROS);
    plannedFixedCostsController.addListener(_updatePlannedBreakevenPoint);
    plannedSellingPerUnitController.addListener(_updatePlannedBreakevenPoint);
    plannedVariableCostPerUnitController.addListener(_updatePlannedBreakevenPoint);
    _plannedMarketSharePercentageController.addListener(_updatePlannedProductPerformance);
    salesVolumeController.addListener(_updatePlannedProductPerformance);
    customerSatisfactionController.addListener(_updatePlannedProductPerformance);
    productDefectRateController.addListener(_updatePlannedProductPerformance);
    salesVolumeMaxController.addListener(_updatePlannedProductPerformance);
    numberOfAdoptersController.addListener(_updateCustomerAdoptionRate);
    totalMarketSizeController.addListener(_updateCustomerAdoptionRate);
    qualityTargetController.addListener(_updateQualityMetrics);
    totalUnitsController.addListener(_updateQualityMetrics);
    numberOfInnovationsController.addListener(_updateIR);
    timePeriodController.addListener(_updateIR);
    plannedSellingPerUnitController.addListener(_updateTotalRevenue);
    _plannedUnitSalesController.addListener(_updateTotalRevenue);
    plannedFixedCostsController.addListener(_updateTotalCost);
    plannedVariableCostPerUnitController.addListener(_updateTotalCost);
    _plannedUnitSalesController.addListener(_updateTotalCost);
    totalRevenue.addListener(_updateGrossProfit);
    totalCost.addListener(_updateGrossProfit);
    totalGrossProfit.addListener(_updateGrossMargin);
    totalRevenue.addListener(_updateGrossMargin);
    totalGrossProfit.addListener(_updateROI);
    totalCost.addListener(_updateROI);
    _plannedUnitSalesController.addListener(_updateTotalMP);
    _plannedTotalTAM.addListener(_updateTotalMP);
    _plannedUnitSalesController.addListener(_updateTotalCompetitivePenetration);
    _plannedTotalMarketDemand.addListener(_updateTotalCompetitivePenetration);
    resolvedTicketsController.addListener(_updateCalculations);
    totalTicketsController.addListener(_updateCalculations);
    resolutionTimesController.addListener(_updateCalculations);
    numberOfTicketsController.addListener(_updateCalculations);
    numberOfFeaturesAlignedController.addListener(_calculateMDA);
    totalPlannedFeaturesController.addListener(_calculateMDA);
  }

  @override
  @override
  void dispose() {
    _plannedUnitSalesController.dispose();
    _plannedMarketSharePercentageController.dispose();
    _plannnedCustomerAcceptanceRateController.dispose();
    _plannedCustomerSatisfactionController.dispose();
    _plannedNetProfitController.dispose();
    _plannedSalesRevenueController.dispose();
    _plannedROSController.dispose();
    plannedFixedCostsController.dispose();
    plannedSellingPerUnitController.dispose();
    plannedVariableCostPerUnitController.dispose();
    _plannedBreakevenPointController.dispose();
    _plannedBreakevenPointRevenueController.dispose();
    plannedVariableCostsController.dispose();
    _plannedProfitController.dispose();
    salesVolumeController.dispose();
    customerSatisfactionController.dispose();
    productDefectRateController.dispose();
    _plannedProductPerformanceController.dispose();
    salesVolumeMaxController.dispose();
    numberOfAdoptersController.dispose();
    totalMarketSizeController.dispose();
    customerAdoptionRateController.dispose();
    qualityTargetController.dispose();
    totalUnitsController.dispose();
    qualityMetricsController.dispose();
    numberOfInnovationsController.dispose();
    timePeriodController.dispose();
    innovationRateController.dispose();
    _scaleController.dispose();
    numberOfCopiesController.dispose();
    numberOfRewardsController.dispose();
    totalRevenue.dispose();
    totalCost.dispose();
    totalGrossProfit.dispose();
    totalGrossMargin.dispose();
    totalContributionMargin.dispose();
    totalROI.dispose();
    totalMP.dispose();
    _plannedTotalTAM.dispose();
    totalCompetitivePenetration.dispose();
    _plannedTotalMarketDemand.dispose();
    _cfsController.dispose();
    resolvedTicketsController.dispose();
    totalTicketsController.dispose();
    resolutionTimesController.dispose();
    numberOfTicketsController.dispose();
    totalPLSEController.dispose();
    totalARTController.dispose();
    numberOfFeaturesAlignedController.dispose();
    totalPlannedFeaturesController.dispose();
    mdaController.dispose();

    super.dispose();
  }

  void _saveEffectiveness() async {
    try {
      List<String> fileUrls = await _uploadFiles(_files);
      List<String> fileUrls1 = await _uploadFiles(_files1);

      Map<String, dynamic> efficiencyData = {
        'productId': widget.productId,
        'projectId': widget.projectId,
        'UnitSales': '${_plannedUnitSalesController.text} unit',
        'MarketShare': '${_plannedMarketSharePercentageController.text} %',
        'CustomerAcceptanceRate': '${_plannnedCustomerAcceptanceRateController.text} %',
        'CustomerSatisfaction': '${_plannedCustomerSatisfactionController.text} scale',
        'NetProfit': 'RM ${_plannedNetProfitController.text}',
        'SalesRevenue': 'RM ${_plannedSalesRevenueController.text}',
        'ReturnOnSales(ROS)': '${_plannedROSController.text} %',
        'SellingPricePerUnit': 'RM ${plannedSellingPerUnitController.text}',
        'FixedCosts': 'RM ${plannedFixedCostsController.text}',
        'VariableCostPerUnit': 'RM ${plannedVariableCostPerUnitController.text}',
        'BreakevenPoint': '${_plannedBreakevenPointController.text} unit',
        'BreakevenPointRevenue': 'RM ${_plannedBreakevenPointRevenueController.text}',
        'VariableCost': 'RM ${plannedVariableCostsController.text}',
        'Profit': 'RM ${_plannedProfitController.text}',
        'SalesVolume': '${salesVolumeController.text} units',
        'MaxSalesVolume': '${salesVolumeMaxController.text} units',
        'CustomerSatisfactionScore': '${customerSatisfactionController.text} %',
        'ProductDefectRate': '${productDefectRateController.text} %',
        'ProductPerformance': _plannedProductPerformanceController.text,
        'NumberOfAdopters': numberOfAdoptersController.text,
        'TotalMarketSize': totalMarketSizeController.text,
        'CustomerAdoptionRate': customerAdoptionRateController.text,
        'NumberOfInnovations': '${numberOfInnovationsController.text} items',
        'TimePeriod': timePeriodController.text,
        'InnovationRate': innovationRateController.text,
        'CustomerRetentationRate': '${_scaleController.text} %',
        'NumberOfCopies': numberOfCopiesController.text,
        'NumberOfRewards': numberOfRewardsController.text,
        'TotalRevenue': 'RM ${totalRevenue.text}',
        'TotalCost': 'RM ${totalCost.text}',
        'TotalGrossProfit': 'RM ${totalGrossProfit.text}',
        'TotalGrossMargin': 'RM ${totalGrossMargin.text}',
        'TotalContributionMargin': 'RM ${totalContributionMargin.text}',
        'TotalROI': 'RM ${totalROI.text}',
        'MarketPenetration': '${totalMP.text} %',
        'TotalAddressableMarket': '${_plannedTotalTAM.text} units',
        'CustomerFeedbackScore': _cfsController.text,
        'ResolvedTickets': resolvedTicketsController.text,
        'TotalTickets': totalTicketsController.text,
        'ResolutionTimes': resolutionTimesController.text,
        'NumberOfTickets': numberOfTicketsController.text,
        'PostLaunchSupport': totalPLSEController.text,
        'AverageResolutionTime': totalARTController.text,
        'NumberOfFeaturesAligned': numberOfFeaturesAlignedController.text,
        'TotalPlannedFeatures': totalPlannedFeaturesController.text,
        'MarketDemandAlignment': '${mdaController.text} %',
        'TotalCompetitivePenetration': totalCompetitivePenetration.text,
        'TotalMarketDemand': _plannedTotalMarketDemand.text,
        'QualityTarget': '${qualityTargetController.text} %',
        'TotalUnits': '${totalUnitsController.text} units',
        'QualityMetrics': qualityMetricsController.text,
        'FileUrls': fileUrls,
        'FileUrls1': fileUrls1,
      };

      await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('products')
          .doc(widget.productId)
          .collection('planned')
          .doc('effectiveness')
          .set(efficiencyData);

      _showSuccessMessage('Effectiveness data saved successfully!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewSelectedProjectID(projectId: widget.projectId),
        ),
      );
    } catch (e) {
      _showErrorMessage('Failed to save efficiency data: $e');
    }
  }

  Future<List<String>> _uploadFiles(List<PlatformFile> files) async {
    List<String> fileUrls = [];

    for (var file in files) {
      if (file.path != null) {
        File localFile = File(file.path!);
        String fileName = file.name;
        try {
          Reference storageRef = FirebaseStorage.instance
              .ref()
              .child('uploads/${widget.projectId}/${widget.productId}/$fileName');
          UploadTask uploadTask = storageRef.putFile(localFile);
          TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});

          String downloadUrl = await snapshot.ref.getDownloadURL();
          fileUrls.add(downloadUrl);
        } catch (e) {
          _showErrorMessage('Failed to upload file: $e');
        }
      }
    }

    return fileUrls;
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

  void _calculateMDA() {
    final numberOfFeaturesAligned = int.tryParse(numberOfFeaturesAlignedController.text) ?? 0;
    final totalPlannedFeatures = int.tryParse(totalPlannedFeaturesController.text) ?? 0;

    if (totalPlannedFeatures == 0) {
      mdaController.text = '0%';
    } else {
      final mda = (numberOfFeaturesAligned / totalPlannedFeatures) * 100;
      mdaController.text = '${mda.toStringAsFixed(2)}';
    }
  }

  void _updateCalculations() {
    final resolvedTickets = int.tryParse(resolvedTicketsController.text) ?? 0;
    final totalTickets = int.tryParse(totalTicketsController.text) ?? 0;
    final resolutionTimes = resolutionTimesController.text.split(',').map((e) => double.tryParse(e.trim()) ?? 0).toList();
    final numberOfTickets = int.tryParse(numberOfTicketsController.text) ?? 0;

    if (totalTickets > 0) {
      plse = (resolvedTickets / totalTickets) * 100;
    } else {
      plse = 0.0;
    }

    if (numberOfTickets > 0) {
      art = resolutionTimes.reduce((a, b) => a + b) / numberOfTickets;
    } else {
      art = 0.0;
    }

    totalPLSEController.text = plse.toStringAsFixed(2);
    totalARTController.text = art.toStringAsFixed(2);
  }

  void _updateTotalCompetitivePenetration() {
    final unitSales = double.tryParse(_plannedUnitSalesController.text) ?? 0;
    final tmd = double.tryParse(_plannedTotalMarketDemand.text) ?? 0;

    final cp = (unitSales / tmd) * 100;
    totalCompetitivePenetration.text = cp.toStringAsFixed(2);
  }

  String? _validateQualityTarget(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quality target is required';
    }
    final target = double.tryParse(value);
    if (target == null || target < 0 || target > 100) {
      return 'Enter a valid percentage (0-100)';
    }
    return null;
  }

  String? _validateTotalUnits(String? value) {
    if (value == null || value.isEmpty) {
      return 'Total units are required';
    }
    final units = double.tryParse(value);
    if (units == null || units < 0) {
      return 'Enter a valid number of units';
    }
    return null;
  }

  void _updateTotalMP() {
    final unitSales = double.tryParse(_plannedUnitSalesController.text) ?? 0;
    final tam = double.tryParse(_plannedTotalTAM.text) ?? 0;

    final mp = (unitSales / tam) * 100;
    totalMP.text = mp.toStringAsFixed(2);
  }

  void _updateContributionMargin() {
    final sellingPricePerUnit = double.tryParse(plannedSellingPerUnitController.text) ?? 0.0;
    final variableCostPerUnit = double.tryParse(plannedVariableCostPerUnitController.text) ?? 0.0;

    final cm = sellingPricePerUnit - variableCostPerUnit;
    totalContributionMargin.text = cm.toStringAsFixed(2);
  }

  void _updateROI() {
    final gp = double.tryParse(totalGrossProfit.text) ?? 0.0;
    final totalCos = double.tryParse(totalCost.text) ?? 0.0;

    final roi = ((gp - totalCos) / totalCos) * 100;
    totalROI.text = roi.toStringAsFixed(2);
  }

  void _updateGrossMargin() {
    final gp = double.tryParse(totalGrossProfit.text) ?? 0.0;
    final totalRev = double.tryParse(totalRevenue.text) ?? 0.0;

    final gm = (gp / totalRev) * 100;
    totalGrossMargin.text = gm.toStringAsFixed(2);
  }

  void _updateGrossProfit() {
    final totalRev = double.tryParse(totalRevenue.text) ?? 0.0;
    final totalCos = double.tryParse(totalCost.text) ?? 0.0;

    final gp = totalRev - totalCos;
    totalGrossProfit.text = gp.toStringAsFixed(2);
  }

  void _updateTotalCost() {
    final fixedCost = double.tryParse(plannedFixedCostsController.text) ?? 0.0;
    final variableCostPerUnit = double.tryParse(plannedVariableCostPerUnitController.text) ?? 0.0;
    final unitSales = double.tryParse(_plannedUnitSalesController.text) ?? 0;

    final cost = fixedCost + (variableCostPerUnit * unitSales);
    totalCost.text = cost.toStringAsFixed(2);
  }

  void _updateTotalRevenue() {
    final sellingPricePerUnit = double.tryParse(plannedSellingPerUnitController.text) ?? 0.0;
    final unitSales = double.tryParse(_plannedUnitSalesController.text) ?? 0; 

    final revenue = sellingPricePerUnit * unitSales;
    totalRevenue.text = revenue.toStringAsFixed(2);
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _files = result.files;
      });
    }
  }

  Future<void> _pickFiles1() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _files1 = result.files;
      });
    }
  }

  String? validateNumberOfCopies(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a valid number greater than 0';
    }
    return null;
  }

  void _updateIR() {
    final numberOfInnovations = double.tryParse(numberOfInnovationsController.text) ?? 0;

    if (selectedDate != null) {
      final currentDate = DateTime.now();
      final timePeriodDays = selectedDate!.difference(currentDate).inDays;

      if (timePeriodDays > 0) {
        final innovationRate = numberOfInnovations / timePeriodDays;
        innovationRateController.text = innovationRate.toStringAsFixed(2);
      } else {
        innovationRateController.text = '0';
      }
    } else {
      innovationRateController.text = '0';
    }
  }

  void _updateQualityMetrics() {
    final target = double.tryParse(qualityTargetController.text) ?? 0;
    final totalUnits = double.tryParse(totalUnitsController.text) ?? 0; 

    if (totalUnits > 0) {
      final qualityMetrics = (target / 100) * totalUnits; 
      qualityMetricsController.text = qualityMetrics.toStringAsFixed(2);
    } else {
      qualityMetricsController.text = '0';
    }
  }

  void _updateCustomerAdoptionRate() {
    final noAdopters = double.tryParse(numberOfAdoptersController.text) ?? 0;
    final totalMarketSize = double.tryParse(totalMarketSizeController.text) ?? 0;

    if (totalMarketSize > 0) {
      final car = noAdopters / totalMarketSize;
      customerAdoptionRateController.text = car.toStringAsFixed(2);
    } else {
      customerAdoptionRateController.text = '0';
    }
  }

  void _updatePlannedROS() {
    final plannedNetProfit = double.tryParse(_plannedNetProfitController.text) ?? 0.0;
    final plannedSalesRevenue = double.tryParse(_plannedSalesRevenueController.text) ?? 0.0;

    if (plannedSalesRevenue > 0) {
      final ros = (plannedNetProfit / plannedSalesRevenue) * 100;
      _plannedROSController.text = ros.toStringAsFixed(2);
    } else {
      _plannedROSController.text = '0.00';
    }
  }

  void _updatePlannedBreakevenPoint() {
    final plannedFixedCosts = double.tryParse(plannedFixedCostsController.text) ?? 0.0;
    final plannedSellingPricePerUnit = double.tryParse(plannedSellingPerUnitController.text) ?? 0.0;
    final plannedVariableCostPerUnit = double.tryParse(plannedVariableCostPerUnitController.text) ?? 0.0;

    if (plannedSellingPricePerUnit > plannedVariableCostPerUnit) {
      final breakevenPoint = plannedFixedCosts / (plannedSellingPricePerUnit - plannedVariableCostPerUnit);
      _plannedBreakevenPointController.text = breakevenPoint.toStringAsFixed(2);
      final breakevenPointRevenue = breakevenPoint * plannedSellingPricePerUnit;
      _plannedBreakevenPointRevenueController.text = breakevenPointRevenue.toStringAsFixed(2);
    } else {
      _plannedBreakevenPointController.text = 'N/A'; 
      _plannedBreakevenPointRevenueController.text = 'N/A'; 
    }
  }

  void _updatePlannedProfit() {
    final plannedFixedCosts = double.tryParse(plannedFixedCostsController.text) ?? 0.0;
    final plannedVariableCosts = double.tryParse(plannedVariableCostsController.text) ?? 0.0;
    final plannedSalesRevenue = double.tryParse(_plannedSalesRevenueController.text) ?? 0.0;
    if (plannedSalesRevenue < 0 || plannedFixedCosts < 0 || plannedVariableCosts < 0) {
      _plannedProfitController.text = 'Invalid input';
      return;
    }

    final profit = plannedSalesRevenue - (plannedFixedCosts + plannedVariableCosts);
    _plannedProfitController.text = profit.toStringAsFixed(2);
  }

  void _updatePlannedProductPerformance() {
    final salesVolume = double.tryParse(salesVolumeController.text) ?? 0; //in units
    final marketShare = double.tryParse(_plannedMarketSharePercentageController.text) ?? 0; //in %
    final custSatisfactionRate = double.tryParse(customerSatisfactionController.text) ?? 0; //in %
    final productDefectRate = double.tryParse(productDefectRateController.text) ?? 0; //in %
    final salesVolumeMax = double.tryParse(salesVolumeMaxController.text) ?? 0; //in units
    final normalizedSalesVolume = salesVolume / salesVolumeMax;
    final productPerformance = normalizedSalesVolume + marketShare + custSatisfactionRate - productDefectRate;

    _plannedProductPerformanceController.text = productPerformance.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Planned - Effectiveness Factors',
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
                        'Unit Sales & Market Share :',
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
                              'Number of Units to be Sold :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedUnitSalesController,
                              hintText: 'Enter your unit value',
                              prefixIcon: Icons.energy_savings_leaf_sharp,
                              isValid: true,
                              suffixText: 'unit',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedUnitSalesController.text) ?? 0;
                                _plannedUnitSalesController.text = (currentValue + 1).toString();
                                _updateTotalRevenue();
                                _updateTotalCost();
                                _updateGrossProfit();
                                _updateGrossMargin();
                                _updateROI();
                                _updateTotalCost();
                                _updateTotalMP();
                                _updateTotalCompetitivePenetration();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedUnitSalesController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedUnitSalesController.text = (currentValue - 1).toString();
                                  _updateTotalRevenue();
                                  _updateTotalCost();
                                  _updateGrossProfit();
                                  _updateGrossMargin();
                                  _updateROI();
                                  _updateTotalCost();
                                  _updateTotalMP();
                                  _updateTotalCompetitivePenetration();
                                }
                              },
                              onChanged: (value) {
                                setState(() {
                                  _updateTotalRevenue();
                                  _updateTotalCost();
                                  _updateGrossProfit();
                                  _updateGrossMargin();
                                  _updateROI();
                                  _updateTotalCost();
                                  _updateTotalMP();
                                  _updateTotalCompetitivePenetration();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Planned unit sales cannot be empty';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Market Share Percentage :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedMarketSharePercentageController,
                              hintText: 'Enter your % value',
                              prefixIcon: Icons.energy_savings_leaf_sharp,
                              isValid: true,
                              suffixText: '%',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedMarketSharePercentageController.text) ?? 0;
                                _plannedMarketSharePercentageController.text = (currentValue + 1).toString();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedMarketSharePercentageController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedMarketSharePercentageController.text = (currentValue - 1).toString();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Planned market share cannot be empty';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedProductPerformance();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Customer Acceptance & Satisfaction :',
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
                              'Customer Acceptance Rate :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannnedCustomerAcceptanceRateController,
                              hintText: 'Enter your customer expected to accept the product',
                              prefixIcon: Icons.people,
                              isValid: true,
                              suffixText: '%',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannnedCustomerAcceptanceRateController.text) ?? 0;
                                _plannnedCustomerAcceptanceRateController.text = (currentValue + 1).toString();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannnedCustomerAcceptanceRateController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannnedCustomerAcceptanceRateController.text = (currentValue - 1).toString();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Planned customer acceptance rate cannot be empty';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Customer Acceptance Satisfaction :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomScaleTextField(
                              controller: _plannedCustomerSatisfactionController,
                              hintText: 'Enter your satisfaction scale (1-10)',
                              prefixIcon: Icons.star,
                              suffixText: 'scale',
                              keyboardType: TextInputType.number,
                              isValid: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Satisfaction scale cannot be empty';
                                }
                                final intValue = int.tryParse(value);
                                if (intValue == null || intValue < 1 || intValue > 10) {
                                  return 'Please enter a number between 1 and 10';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Return on Sales :',
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
                              'Net Profit :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedNetProfitController,
                              hintText: 'Enter your target net profit value',
                              prefixIcon: Icons.price_change_rounded,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedROS();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedNetProfitController.text) ?? 0;
                                _plannedNetProfitController.text = (currentValue + 1).toString();
                                _updatePlannedROS();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedNetProfitController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedNetProfitController.text = (currentValue - 1).toString();
                                  _updatePlannedROS();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Net profit cannot be empty';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Sales Revenue :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedSalesRevenueController,
                              hintText: 'Enter your target sales revenue value',
                              prefixIcon: Icons.price_change_rounded,
                              isValid: true,
                              suffixText: 'RM',
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedROS();
                                  _updatePlannedProfit();
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(_plannedSalesRevenueController.text) ?? 0;
                                _plannedSalesRevenueController.text = (currentValue + 1).toString();
                                _updatePlannedROS();
                                _updatePlannedProfit();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(_plannedSalesRevenueController.text) ?? 0;
                                if (currentValue > 0) {
                                  _plannedSalesRevenueController.text = (currentValue - 1).toString();
                                  _updatePlannedROS();
                                  _updatePlannedProfit();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Sales revenue cannot be empty';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Return on Sales :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedROSController,
                              hintText: 'Total Return on Sales',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: '%',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total return on sales should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Breakeven & Breakeven Point :',
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
                              'Fixed Costs :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: plannedFixedCostsController,
                              hintText: 'Enter Total Fixed Costs',
                              prefixIcon: Icons.attach_money,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              suffixText: 'RM',
                              isValid: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the fixed costs';
                                }
                                final num? parsedValue = num.tryParse(value);
                                if (parsedValue == null || parsedValue <= 0) {
                                  return 'Invalid amount';
                                }
                                return null;
                              },
                              showIncrementDecrement: false,
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedBreakevenPoint();
                                  _updatePlannedProfit();
                                  _updateTotalCost();
                                  _updateGrossProfit();
                                  _updateROI();
                                  _updateTotalCost();
                                });
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Selling Price per unit :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: plannedSellingPerUnitController,
                              hintText: 'Enter Selling Price per Unit',
                              prefixIcon: Icons.price_check,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              suffixText: 'RM',
                              isValid: true,
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedBreakevenPoint();
                                  _updateTotalRevenue();
                                  _updateContributionMargin();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the selling price per unit';
                                }
                                final num? parsedValue = num.tryParse(value);
                                if (parsedValue == null || parsedValue <= 0) {
                                  return 'Invalid amount';
                                }
                                return null;
                              },
                              showIncrementDecrement: false,
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Variable Cost per unit :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: plannedVariableCostPerUnitController,
                              hintText: 'Enter Variable Cost per Unit',
                              prefixIcon: Icons.money_off,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              suffixText: 'RM',
                              isValid: true,
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedBreakevenPoint();
                                  _updateContributionMargin();
                                  _updateTotalCost();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the variable cost per unit';
                                }
                                final num? parsedValue = num.tryParse(value);
                                if (parsedValue == null || parsedValue <= 0) {
                                  return 'Invalid amount';
                                }
                                return null;
                              },
                              showIncrementDecrement: false,
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Breakeven Point (units) :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedBreakevenPointController,
                              hintText: 'Breakeven Point',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'units',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Breakeven point should be calculated';
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
                              'Breakeven Point (Revenue) :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedBreakevenPointRevenueController,
                              hintText: 'Breakeven Point (Revenue)',
                              prefixIcon: Icons.monetization_on,
                              isValid: true,
                              suffixText: 'RM',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Breakeven point (revenue) should be calculated';
                                }
                                return null;
                              },
                            ),


                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Profit :',
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
                              'Variable Costs :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: plannedVariableCostsController,
                              hintText: 'Enter Total Variable Costs',
                              prefixIcon: Icons.attach_money,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                              suffixText: 'RM',
                              isValid: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the variable costs';
                                }
                                final num? parsedValue = num.tryParse(value);
                                if (parsedValue == null || parsedValue <= 0) {
                                  return 'Invalid amount';
                                }
                                return null;
                              },
                              showIncrementDecrement: false,
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedProfit();
                                });
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Profit :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedProfitController,
                              hintText: 'Profit',
                              prefixIcon: Icons.money,
                              isValid: true,
                              suffixText: 'RM',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Profit should be calculated';
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
                              'Sales Volume :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: salesVolumeController,
                              hintText: 'Enter sales volume',
                              prefixIcon: Icons.bar_chart,
                              keyboardType: TextInputType.number,
                              suffixText: 'units',
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                final volume = int.tryParse(value ?? '');
                                if (volume == null || volume < 0) {
                                  return 'Enter a valid positive number';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedProductPerformance();
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Max Sales Volume :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: salesVolumeMaxController,
                              hintText: 'Enter maximum sales volume',
                              prefixIcon: Icons.bar_chart,
                              keyboardType: TextInputType.number,
                              suffixText: 'units',
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                final volume = int.tryParse(value ?? '');
                                if (volume == null || volume < 0) {
                                  return 'Enter a valid positive number';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedProductPerformance();
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Customer Satisfaction Score :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: customerSatisfactionController,
                              hintText: 'Enter satisfaction score',
                              prefixIcon: Icons.star,
                              keyboardType: TextInputType.number,
                              suffixText: '%',
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                final score = double.tryParse(value ?? '');
                                if (score == null || score < 0 || score > 100) {
                                  return 'Enter a valid score between 0 and 100';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedProductPerformance();
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Product Defect Rate :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: productDefectRateController,
                              hintText: 'Enter defect rate',
                              prefixIcon: Icons.warning,
                              keyboardType: TextInputType.number,
                              suffixText: '%',
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                final rate = double.tryParse(value ?? '');
                                if (rate == null || rate < 0 || rate > 100) {
                                  return 'Enter a valid rate between 0 and 100';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _updatePlannedProductPerformance();
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Product Performance :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedProductPerformanceController,
                              hintText: 'Total product performance',
                              prefixIcon: Icons.money,
                              isValid: true,
                              suffixText: '',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Profit should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Customer Adoption Rate :',
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
                              'Number of Adopters :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: numberOfAdoptersController,
                              hintText: 'Number of Adopters',
                              prefixIcon: Icons.people,
                              keyboardType: TextInputType.number,
                              suffixText: '',
                              isValid: true,
                              onChanged: (value) {
                                _updateCustomerAdoptionRate();
                              },
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(numberOfAdoptersController.text) ?? 0;
                                numberOfAdoptersController.text = (currentValue + 1).toString();
                                _updateCustomerAdoptionRate();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(numberOfAdoptersController.text) ?? 0;
                                if (currentValue > 0) {
                                  numberOfAdoptersController.text = (currentValue - 1).toString();
                                  _updateCustomerAdoptionRate();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the number of adopters';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Total Market Share :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: totalMarketSizeController,
                              hintText: 'Enter your total market share value',
                              prefixIcon: Icons.business,
                              isValid: true,
                              suffixText: '',
                              onChanged: (value) {
                                setState(() {
                                  _updateCustomerAdoptionRate();
                                });
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(totalMarketSizeController.text) ?? 0;
                                totalMarketSizeController.text = (currentValue + 1).toString();
                                _updateCustomerAdoptionRate();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(totalMarketSizeController.text) ?? 0;
                                if (currentValue > 0) {
                                  totalMarketSizeController.text = (currentValue - 1).toString();
                                  _updateCustomerAdoptionRate();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the total market size';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Customer Adoption Rate :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: customerAdoptionRateController,
                              hintText: 'Total Customer Adoption Rate',
                              prefixIcon: Icons.people,
                              isValid: true,
                              suffixText: '',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total customer adoption rate should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Quality Metrics :',
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
                              'Quality Target :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: qualityTargetController,
                              hintText: 'Enter Quality Target (%)',
                              prefixIcon: Icons.percent,
                              keyboardType: TextInputType.number,
                              suffixText: '%',
                              onChanged: (value) => _updateQualityMetrics(),
                              validator: _validateQualityTarget,
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Total Units :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: totalUnitsController,
                              hintText: 'Enter Total Units',
                              prefixIcon: Icons.format_list_numbered,
                              keyboardType: TextInputType.number,
                              onChanged: (value) => _updateQualityMetrics(),
                              validator: _validateTotalUnits,
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Quality Metrics :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: qualityMetricsController,
                              hintText: 'Quality Metrics',
                              prefixIcon: Icons.insights,
                              isValid: true,
                              suffixText: '',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total quality metrics should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Innovation Rate :',
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
                              'Number of Innovations :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: numberOfInnovationsController,
                              hintText: 'Number of new features, patents, or innovations expected',
                              prefixIcon: Icons.add, // Choose an appropriate icon
                              keyboardType: TextInputType.number,
                              suffixText: 'items',
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid number';
                                }
                                final number = int.tryParse(value);
                                if (number == null || number <= 0) {
                                  return 'Please enter a number greater than 0';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Time Period :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null && pickedDate != selectedDate) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                    timePeriodController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                                  });
                                }
                              },
                              child: AbsorbPointer(
                                child: CustomTextFieldNew(
                                  controller: timePeriodController,
                                  hintText: 'Time period for expected innovations',
                                  prefixIcon: Icons.date_range, 
                                  keyboardType: TextInputType.datetime,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a valid date';
                                    }
                                    return null;
                                  },
                                  readOnly: true,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Innovation Rate :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: innovationRateController,
                              hintText: 'Total Innovation Rate',
                              prefixIcon: Icons.production_quantity_limits,
                              isValid: true,
                              suffixText: '',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total innovation rate should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Customer Retention Rate :',
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
                              'Customer Retention Rate :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomScaleTextField1(
                              controller: _scaleController,
                              hintText: 'Enter Scale',
                              prefixIcon: Icons.scale,
                              keyboardType: TextInputType.number,
                              suffixText: '%',
                              onChanged: (value) {
                                print('Scale changed: $value');
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                final scale = int.tryParse(value);
                                if (scale == null || scale < 1 || scale > 100) {
                                  return 'Please enter a value between 1 and 100';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Copy Registered :',
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
                              'Number of Copy Registration :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: numberOfCopiesController,
                              hintText: 'Number of Copies Registered',
                              prefixIcon: Icons.copy,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly, 
                              ],
                              validator: validateNumberOfCopies,
                              suffixText: 'copies', 
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(numberOfCopiesController.text) ?? 0;
                                numberOfCopiesController.text = (currentValue + 1).toString();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(numberOfCopiesController.text) ?? 0;
                                if (currentValue > 0) {
                                  numberOfCopiesController.text = (currentValue - 1).toString();
                                }
                              },
                            ),
                            ElevatedButton(
                              onPressed: _pickFiles1,
                              child: Text('Pick PDF Files'),
                            ),
                            if (_files1.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _files1.map((file) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      file.name,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Rewards/Achievements :',
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
                              'Number of Rewards/Achievements :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: numberOfRewardsController,
                              hintText: 'Number of Rewards/Achievements',
                              prefixIcon: Icons.copy,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: validateNumberOfCopies,
                              suffixText: 'rewards',
                              showIncrementDecrement: true,
                              onIncrement: () {
                                final currentValue = int.tryParse(numberOfRewardsController.text) ?? 0;
                                numberOfRewardsController.text = (currentValue + 1).toString();
                              },
                              onDecrement: () {
                                final currentValue = int.tryParse(numberOfRewardsController.text) ?? 0;
                                if (currentValue > 0) {
                                  numberOfRewardsController.text = (currentValue - 1).toString();
                                }
                              },
                            ),
                            ElevatedButton(
                              onPressed: _pickFiles,
                              child: Text('Pick PDF Files'),
                            ),
                            if (_files.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _files.map((file) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      file.name,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Financial Performance :',
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
                              'Total Revenue :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: totalRevenue,
                              hintText: 'Total Revenue',
                              prefixIcon: Icons.pinch_rounded,
                              isValid: true,
                              suffixText: 'RM',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total revenue should be calculated';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _updateGrossMargin();
                                  _updateGrossProfit();
                                });
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Total Cost :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: totalCost,
                              hintText: 'Total Cost',
                              prefixIcon: Icons.pinch_rounded,
                              isValid: true,
                              suffixText: 'RM',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total cost should be calculated';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _updateROI();
                                  _updateGrossProfit();
                                });
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Gross Profit :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: totalGrossProfit,
                              hintText: 'Total Gross Profit',
                              prefixIcon: Icons.money,
                              isValid: true,
                              suffixText: 'RM',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total gross profit should be calculated';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _updateROI();
                                  _updateGrossMargin();
                                });
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Gross Margin :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: totalGrossMargin,
                              hintText: 'Total Gross Margin',
                              prefixIcon: Icons.pinch_rounded,
                              isValid: true,
                              suffixText: 'RM',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total gross margin should be calculated';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Return on Investment (ROI) :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: totalROI,
                              hintText: 'ROI',
                              prefixIcon: Icons.analytics,
                              isValid: true,
                              suffixText: 'RM',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'ROI should be calculated';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            Text(
                              'Contribution Margin :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: totalContributionMargin,
                              hintText: 'Contribution Margin',
                              prefixIcon: Icons.analytics,
                              isValid: true,
                              suffixText: 'RM',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Contribution Margin should be calculated';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Market Penetration :',
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
                              'Total Addressable Market (TAM) :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedTotalTAM,
                              hintText: 'Enter total TAM',
                              prefixIcon: Icons.energy_savings_leaf_sharp,
                              isValid: true,
                              suffixText: 'units',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              showIncrementDecrement: false,
                              onChanged: (value) {
                                setState(() {
                                  _updateTotalMP();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Planned total TAM cannot be empty';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Market Penetration Rate :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: totalMP,
                              hintText: 'Total Market Penetration Rate',
                              prefixIcon: Icons.analytics,
                              isValid: true,
                              suffixText: '%',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total Market Penetration Rate should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Competitive Penetration :',
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
                              'Total Market Demand :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: _plannedTotalMarketDemand,
                              hintText: 'Enter total market demand',
                              prefixIcon: Icons.energy_savings_leaf_sharp,
                              isValid: true,
                              suffixText: '',
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              showIncrementDecrement: false,
                              onChanged: (value) {
                                setState(() {
                                  _updateTotalCompetitivePenetration();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Planned total market demand cannot be empty';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Competitive Penetration :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: totalCompetitivePenetration,
                              hintText: 'Competitive Penetration',
                              prefixIcon: Icons.analytics,
                              isValid: true,
                              suffixText: '',
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Total Competitive Penetration should be calculated';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Customer feedback integration :',
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
                              'Customer Feedback Score :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                            controller: _cfsController,
                            hintText: 'Enter total of customer feedback score value',
                            prefixIcon: Icons.people,
                            isValid: true,
                            suffixText: '',
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            showIncrementDecrement: true,
                            onIncrement: () {
                              int currentValue = int.tryParse(_cfsController.text) ?? 0;
                              _cfsController.text = (currentValue + 1).toString();
                            },
                            onDecrement: () {
                              int currentValue = int.tryParse(_cfsController.text) ?? 0;
                              if (currentValue > 0) {
                                _cfsController.text = (currentValue - 1).toString();
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Total customer feedback score value cannot be empty';
                              }
                              return null;
                            },
                          ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Post-launch Support :',
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

                            CustomTextFieldNew(
                              controller: resolvedTicketsController,
                              hintText: 'Number of Resolved Tickets',
                              prefixIcon: Icons.check,
                              keyboardType: TextInputType.number,
                              showIncrementDecrement: true,
                              onIncrement: () {
                                setState(() {
                                  final currentValue = int.tryParse(resolvedTicketsController.text) ?? 0;
                                  resolvedTicketsController.text = (currentValue + 1).toString();
                                  _updateCalculations();
                                });
                              },
                              onDecrement: () {
                                setState(() {
                                  final currentValue = int.tryParse(resolvedTicketsController.text) ?? 0;
                                  if (currentValue > 0) {
                                    resolvedTicketsController.text = (currentValue - 1).toString();
                                    _updateCalculations();
                                  }
                                });
                              },
                              onChanged: (_) => _updateCalculations(),
                            ),
                            CustomTextFieldNew(
                              controller: totalTicketsController,
                              hintText: 'Total Number of Tickets',
                              prefixIcon: Icons.info,
                              keyboardType: TextInputType.number,
                              showIncrementDecrement: true,
                              onIncrement: () {
                                setState(() {
                                  final currentValue = int.tryParse(totalTicketsController.text) ?? 0;
                                  totalTicketsController.text = (currentValue + 1).toString();
                                  _updateCalculations();
                                });
                              },
                              onDecrement: () {
                                setState(() {
                                  final currentValue = int.tryParse(totalTicketsController.text) ?? 0;
                                  if (currentValue > 0) {
                                    totalTicketsController.text = (currentValue - 1).toString();
                                    _updateCalculations();
                                  }
                                });
                              },
                              onChanged: (_) => _updateCalculations(),
                            ),
                            CustomTextFieldNew(
                              controller: resolutionTimesController,
                              hintText: 'Resolution Times (comma-separated)',
                              prefixIcon: Icons.timer,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter resolution times';
                                }

                                final times = value.split(',').map((e) => e.trim()).toList();
                                if (times.isEmpty) {
                                  return 'Please enter at least one resolution time';
                                }

                                for (var time in times) {
                                  if (double.tryParse(time) == null) {
                                    return 'Invalid format for resolution times';
                                  }
                                }

                                return null;
                              },
                              onChanged: (_) => _updateCalculations(),
                            ),
                            CustomTextFieldNew(
                              controller: numberOfTicketsController,
                              hintText: 'Number of Tickets',
                              prefixIcon: Icons.confirmation_number,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              showIncrementDecrement: true,
                              onIncrement: () {
                                setState(() {
                                  final currentValue = int.tryParse(numberOfTicketsController.text) ?? 0;
                                  numberOfTicketsController.text = (currentValue + 1).toString();
                                  _updateCalculations();
                                });
                              },
                              onDecrement: () {
                                setState(() {
                                  final currentValue = int.tryParse(numberOfTicketsController.text) ?? 0;
                                  if (currentValue > 0) {
                                    numberOfTicketsController.text = (currentValue - 1).toString();
                                    _updateCalculations();
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the number of tickets';
                                }

                                final numberOfTickets = int.tryParse(value);
                                if (numberOfTickets == null || numberOfTickets < 0) {
                                  return 'Please enter a valid number of tickets';
                                }

                                return null;
                              },
                              onChanged: (_) => _updateCalculations(),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Post-Launch Support Efficiency (PLSE): ${totalPLSEController.text}%',
                              style: AppFonts.text16(AppColor.black),
                            ),
                            Text(
                              'Average Resolution Time (ART): ${totalARTController.text} minutes',
                              style: AppFonts.text16(AppColor.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Market Demand Alignment :',
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
                              'Number of Features Aligned with Market Needs :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: numberOfFeaturesAlignedController,
                              hintText: 'Enter number of Features Aligned with Market Needs',
                              prefixIcon: Icons.check,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => _calculateMDA(),
                              showIncrementDecrement: true,
                              onIncrement: () {
                                setState(() {
                                  numberOfFeaturesAlignedController.text = (int.tryParse(numberOfFeaturesAlignedController.text) ?? 0 + 1).toString();
                                  _calculateMDA();
                                });
                              },
                              onDecrement: () {
                                setState(() {
                                  final currentValue = int.tryParse(numberOfFeaturesAlignedController.text) ?? 0;
                                  if (currentValue > 0) {
                                    numberOfFeaturesAlignedController.text = (currentValue - 1).toString();
                                    _calculateMDA();
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Total Number of Planned Features :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: totalPlannedFeaturesController,
                              hintText: 'Enter total Number of Planned Features',
                              prefixIcon: Icons.list,
                              keyboardType: TextInputType.number,
                              showIncrementDecrement: false,
                              onChanged: (_) => _calculateMDA(),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Planned MDA :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 8),
                            CustomTextFieldNew(
                              controller: mdaController,
                              hintText: 'Total Planned MDA',
                              prefixIcon: Icons.pie_chart,
                              readOnly: true,
                              suffixText: '%',
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveEffectiveness();
                    } else{
                      setState(() {
                        _showError = true;
                      });
                    }
                  },
                  child: Text(
                    'Submit',
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
}
