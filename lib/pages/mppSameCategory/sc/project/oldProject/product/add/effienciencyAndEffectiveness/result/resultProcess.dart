import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../../common/appColors.dart';
import '../../../../../../../../../common/appFonts.dart';
import '../../../selectedProjectID.dart';

class ResultProcessPage extends StatefulWidget {
  final String projectId;
  final String productId;

  ResultProcessPage({required this.projectId, required this.productId});

  @override
  _ResultProcessPageState createState() => _ResultProcessPageState();
}

class _ResultProcessPageState extends State<ResultProcessPage> {
  Map<String, dynamic> plannedData = {};
  Map<String, dynamic> actualData = {};
  String _overallResultData = "Loading...";
  String _resultEfficiencyData = "Loading...";
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final plannedEfficiencyDoc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('products')
          .doc(widget.productId)
          .collection('planned')
          .doc('efficiency')
          .get();

      final actualEfficiencyDoc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('products')
          .doc(widget.productId)
          .collection('actual')
          .doc('efficiency')
          .get();

      final plannedEffectivenessDoc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('products')
          .doc(widget.productId)
          .collection('planned')
          .doc('effectiveness')
          .get();

      final actualEffectivenessDoc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('products')
          .doc(widget.productId)
          .collection('actual')
          .doc('effectiveness')
          .get();

      setState(() {
        plannedData = plannedEfficiencyDoc.data() ?? {};
        actualData = actualEfficiencyDoc.data() ?? {};
        _resultEfficiencyData = _calculateEfficiencyResult();
        _overallResultData = _calculateOverallResult();
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _resultEfficiencyData = "Error fetching efficiency data";
        _overallResultData = "Error fetching data";
      });
    }
  }

  String _calculateEfficiencyResult() {
    final plannedEfficiency = plannedData['efficiency'] ?? 0.0;
    final actualEfficiency = actualData['efficiency'] ?? 0.0;

    double difference = (actualEfficiency - plannedEfficiency).abs();
    String result;
    String suggestion;

    if (actualEfficiency > plannedEfficiency) {
      if (actualEfficiency - plannedEfficiency >= 0.1 * plannedEfficiency) {
        result = "SUCCESSFUL";
        suggestion = "Keep up the good work! Consider analyzing what strategies contributed to this success and replicate them in other areas.";
      } else {
        result = "PARTIALLY SUCCESSFUL";
        suggestion = "While the efficiency is better than planned, there is still room for improvement. Investigate areas where efficiency can be further enhanced.";
      }
    } else if (actualEfficiency < plannedEfficiency) {
      if (plannedEfficiency - actualEfficiency >= 0.1 * plannedEfficiency) {
        result = "FAILED";
        suggestion = "The actual efficiency is significantly lower than planned. Analyze the reasons for the shortfall and address the underlying issues to improve future performance.";
      } else {
        result = "PARTIALLY SUCCESSFUL";
        suggestion = "The efficiency is lower than planned, but not drastically. Review processes and identify specific areas for improvement to achieve planned targets.";
      }
    } else {
      result = "NO IMPROVEMENT";
      suggestion = "Efficiency is on par with the plan. Consider setting more ambitious targets and explore opportunities for optimization.";
    }

    return '$result\nDifference: ${difference.toStringAsFixed(2)}\nSuggestion: $suggestion';
  }

  Color _getResultColor(String result) {
    switch (result) {
      case "SUCCESSFUL":
        return Colors.green; 
      case "FAILED":
        return Colors.red; 
      case "PARTIALLY SUCCESSFUL":
        return Colors.orange;
      case "NO IMPROVEMENT":
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  String _calculateOverallResult() {
    final plannedEfficiency = plannedData['efficiency'] ?? 0.0;
    final plannedEffectiveness = plannedData['effectiveness'] ?? 0.0;
    final actualEfficiency = actualData['efficiency'] ?? 0.0;
    final actualEffectiveness = actualData['effectiveness'] ?? 0.0;

    if (actualEfficiency < plannedEfficiency) {
      if (actualEffectiveness < plannedEffectiveness) {
        return "NEW NPD FAILED";
      } else if (actualEffectiveness == plannedEffectiveness) {
        return "NEW NPD FAILED";
      } else {
        return "DIFFICULT TO JUDGE";
      }
    } else if (actualEfficiency == plannedEfficiency) {
      if (actualEffectiveness < plannedEffectiveness) {
        return "NEW NPD FAILED";
      } else if (actualEffectiveness == plannedEffectiveness) {
        return "NO IMPROVEMENT (NPD FAILED)";
      } else {
        return "SUCCESSFUL";
      }
    } else {
      if (actualEffectiveness < plannedEffectiveness) {
        return "NEW NPD FAILED";
      } else if (actualEffectiveness == plannedEffectiveness) {
        return "PARTIALLY SUCCESSFUL";
      } else {
        return "VERY SUCCESSFUL";
      }
    }
  }

  Color _getResultHighlightColor(String result) {
    switch (result) {
      case "VERY SUCCESSFUL":
        return Colors.orange;
      case "SUCCESSFUL":
        return Colors.yellow;
      case "PARTIALLY SUCCESSFUL":
        return Colors.amberAccent;
      case "DIFFICULT TO JUDGE":
        return Colors.lightBlueAccent;
      case "NEW NPD FAILED":
        return Colors.redAccent;
      case "NO IMPROVEMENT (NPD FAILED)":
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  void _navigateToViewSelectedProject() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewSelectedProjectID(projectId: widget.projectId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.black,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColor.white),
          onPressed: _navigateToViewSelectedProject,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EFFICIENCY [INTERNAL GOALS] :',
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width, 
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [
                              // DEV LEAD TIME Row
                              _buildRow('DEVELOPMENT LEAD TIME :', _resultEfficiencyData),
                              // DEV. COST ROW
                              _buildRow('DEVELOPMENT COST :', _resultEfficiencyData),
                              // PRODUCT PERFORMANCE
                              _buildRow('PRODUCT PERFORMANCE :', _resultEfficiencyData),
                              // QUALITY GOALS
                              _buildRow('QUALITY GOALS :', _resultEfficiencyData),
                              // LAUNCHED ON TIME
                              _buildRow('LAUNCHED ON TIME :', _resultEfficiencyData),
                              // COST
                              _buildRow('COST :', _resultEfficiencyData),
                              // YEARLY UNIT SALES
                              _buildRow('YEARLY UNIT SALES :', _resultEfficiencyData),
                              // RESOURCE UTILIZATION
                              _buildRow('RESOURCE UTILIZATION :', _resultEfficiencyData),
                              // TIME TO MARKET
                              _buildRow('TIME TO MARKET :', _resultEfficiencyData),
                              // PROCESS CYCLE
                              _buildRow('PROCESS CYCLE :', _resultEfficiencyData),
                              // RESOURCE ALLOCATION
                              _buildRow('RESOURCE ALLOCATION :', _resultEfficiencyData),
                              // PROTOTYPE ITERATION TIME
                              _buildRow('PROTOTYPE ITERATION TIME :', _resultEfficiencyData),
                              // WASTE REDUCTION
                              _buildRow('WASTE REDUCTION :', _resultEfficiencyData),
                              // MANUFACTURING
                              _buildRow('MANUFACTURING :', _resultEfficiencyData),
                              // CYCLE TIME REDUCTION
                              _buildRow('CYCLE TIME REDUCTION :', _resultEfficiencyData),
                              // SUPPLIER
                              _buildRow('SUPPLIER :', _resultEfficiencyData),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'EFFECTIVENESS [EXTERNAL GOALS] :',
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, 
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width, 
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [
                              _buildRow('UNIT SALES :', _resultEfficiencyData),
                              _buildRow('MARKET SHARE :', _resultEfficiencyData),
                              _buildRow('CUSTOMER ACCEPTANCE RATE :', _resultEfficiencyData),
                              _buildRow('CUSTOMER ACCEPTANCE SATISFACTION :', _resultEfficiencyData),
                              _buildRow('RETURN ON SALES (ROS) :', _resultEfficiencyData),
                              _buildRow('BREAKEVEN POINT (UNITS) :', _resultEfficiencyData),
                              _buildRow('BREAKEVEN POINT (REVENUE) :', _resultEfficiencyData),
                              _buildRow('YEARLY UNIT SALES :', _resultEfficiencyData),
                              _buildRow('PROFIT :', _resultEfficiencyData),
                              _buildRow('SALES VOLUME (UNIT SOLD) :', _resultEfficiencyData),
                              _buildRow('PRODUCT PERFORMANCE :', _resultEfficiencyData),
                              _buildRow('CUSTOMER ADOPTION RATE:', _resultEfficiencyData),
                              _buildRow('QUALITY METRICS :', _resultEfficiencyData),
                              _buildRow('INNOVATION RATE :', _resultEfficiencyData),
                              _buildRow('CUSTOMER RETENTION RATE :', _resultEfficiencyData),
                              _buildRow('COPY REGISTERED :', _resultEfficiencyData),
                              _buildRow('REWARDS/ACHIEVEMENTS :', _resultEfficiencyData),
                              _buildRow('TOTAL REVENUE :', _resultEfficiencyData),
                              _buildRow('TOTAL COST :', _resultEfficiencyData),
                              _buildRow('GROSS PROFIT :', _resultEfficiencyData),
                              _buildRow('GROSS MARGIN :', _resultEfficiencyData),
                              _buildRow('RETURN ON INVESTMENT (ROI) :', _resultEfficiencyData),
                              _buildRow('CONTRIBUTION MARGIN :', _resultEfficiencyData),
                              _buildRow('MARKET PENETRATION RATE :', _resultEfficiencyData),
                              _buildRow('COMPETITIVE PENETRATION :', _resultEfficiencyData),
                              _buildRow('CUSTOMER FEEDBACK SCORE :', _resultEfficiencyData),
                              _buildRow('POST-LAUNCH SUPPORT :', _resultEfficiencyData),
                              _buildRow('AVERAGE RESOLUTION TIME :', _resultEfficiencyData),
                              _buildRow('MARKET DEMAND ALIGNMENT :', _resultEfficiencyData),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 60.0,
            color: AppColor.deepGreen,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildRow1(
                  'OVERALL RESULT :',
                  _overallResultData, 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRow(String label, String resultData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFonts.text16Bold(AppColor.deepGreen1),
          ),
          SizedBox(height: 8), 
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: _getResultColor(_getResultFromString(resultData)), 
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              resultData,
              style: AppFonts.text16Bold(AppColor.black),
            ),
          ),
        ],
      ),
    );
  }

  String _getResultFromString(String resultData) {
    return resultData.split('\n').first;
  }

  Widget _buildRow1(String label, String resultData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.text18Bold(AppColor.white),
        ),
        SizedBox(width: 10,),
        Text(
          resultData,
          style: AppFonts.text18(AppColor.white).copyWith(
            backgroundColor: _getResultHighlightColor(resultData),
          ),
        ),
      ],
    );
  }
}
