import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../../../../common/appColors.dart';
import '../../../../../../../common/appFonts.dart';
import '../../../../../../../common/widget/customMarketDemand.dart';
import '../../../../../../../common/widget/customProductStatusField.dart';
import '../../../../../../../dataModel/productModel.dart';
import '../selectedProjectID.dart';
import '../../../../../../../common/widget/datepicker1.dart';
import '../../../../../../../common/widget/customTextFieldNew.dart';

class EditSelectedProductIDPage extends StatefulWidget {
  final String projectId;
  final String productId;

  EditSelectedProductIDPage({required this.projectId, required this.productId});

  @override
  _EditSelectedProductIDPageState createState() => _EditSelectedProductIDPageState();
}

class _EditSelectedProductIDPageState extends State<EditSelectedProductIDPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _launchDateController;
  late TextEditingController _costController;
  late TextEditingController _functionalityController;
  late TextEditingController _marketDemandController;
  late TextEditingController _modelController;
  late TextEditingController _statusController;
  bool _isProductNameValid = true;
  DateTime? _launchDate;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController();
    _launchDateController = TextEditingController();
    _costController = TextEditingController();
    _functionalityController = TextEditingController();
    _marketDemandController = TextEditingController();
    _modelController = TextEditingController();
    _statusController = TextEditingController();

    _loadProductData();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _launchDateController.dispose();
    _costController.dispose();
    _functionalityController.dispose();
    _marketDemandController.dispose();
    _modelController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _loadProductData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('products')
          .doc(widget.productId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _productNameController.text = data['productName'] ?? '';
          _launchDate = (data['launchDate'] as Timestamp).toDate();
          _costController.text = data['cost'] != null ? data['cost'].toString() : '';
          _functionalityController.text = data['functionality'] ?? '';
          _marketDemandController.text = data['marketDemand'] ?? '';
          _statusController.text = data['productStatus'] ?? '';
          _modelController.text = data['model'] ?? '';
          _launchDateController.text = DateFormat('dd-MM-yyyy').format(_launchDate!);
        });
      }
    } catch (e) {
      _showErrorMessage('Failed to load product data: $e');
    }
  }

  void _updateSaveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    DateTime launchDate = _launchDate ?? DateTime.now();

    try {
      // Remove the 'RM' suffix and parse the value to a double
      String costText = _costController.text.replaceAll('RM', '').trim();
      double cost = double.tryParse(costText) ?? 0.0;

      ProductModel productModel = ProductModel(
        projectId: widget.projectId,
        productId: widget.productId,
        productName: _productNameController.text,
        launchDate: launchDate,
        cost: cost,
        functionality: _functionalityController.text,
        model: _modelController.text,
        marketDemand: _marketDemandController.text,
        productStatus: _statusController.text,
      );

      Map<String, dynamic> productData = {
        'productId': productModel.productId,
        'productName': productModel.productName,
        'launchDate': productModel.launchDate,
        'productStatus': productModel.productStatus,
        'cost': 'RM ${productModel.cost}',
        'functionality': productModel.functionality,
        'model': productModel.model,
        'marketDemand': productModel.marketDemand,
        'projectId': productModel.projectId,
      };

      // Save to Firestore within the selected project ID collection
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('products')
          .doc(productModel.productId)
          .set(productData);

      _showSuccessMessage('Product saved successfully!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewSelectedProjectID(projectId: widget.projectId),
        ),
      );
    } catch (e) {
      _showErrorMessage('Failed to save product: $e');
    }
  }

  void _showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        title: Text('Edit Product Details', style: AppFonts.text24(AppColor.white)),
        backgroundColor: AppColor.black,
        iconTheme: IconThemeData(color: AppColor.black),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please re-select your product status and market demand',
                        style: AppFonts.text16(AppColor.white),
                      ),

                      SizedBox(height: 20),

                      Text(
                        'Product Name :',
                        style: AppFonts.text16Bold(AppColor.bgGreen),
                      ),
                      SizedBox(height: 10),
                      // productName
                      CustomTextFieldNew(
                        controller: _productNameController,
                        hintText: "Enter your product name",
                        prefixIcon: Icons.title,
                        isValid: _isProductNameValid,
                        onChanged: (value) {
                          setState(() {
                            _isProductNameValid = value.isNotEmpty;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a product name';
                          } else if (value.length > 255) {
                            return 'Product name cannot exceed 255 characters';
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(255),
                        ],
                      ),
                      if (!_isProductNameValid)
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            'Product name cannot be empty',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      SizedBox(height: 20),

                      Text(
                        'Launch Date :',
                        style: AppFonts.text16Bold(AppColor.bgGreen),
                      ),
                      SizedBox(height: 10),
                      // launchDate
                      DatePicker1(
                        controller: _launchDateController,
                        hintText: "Select your launch date",
                        prefixIcon: Icons.calendar_today,
                        isValid: true,
                        onChanged: (value) {
                          setState(() {
                            _launchDate = DateFormat('dd-MM-yyyy').parse(value);
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a launch date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      Text(
                        'Product Status :',
                        style: AppFonts.text16Bold(AppColor.bgGreen),
                      ),
                      SizedBox(height: 10),
                      // status
                      CustomProductStatusField(
                        controller: _statusController,
                        hintText: 'Select Product Status',
                        prefixIcon: Icons.assignment,
                        showError: _showError,
                        onChanged: (value) {
                          setState(() {
                            _statusController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a product status';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      Text(
                        'Product Cost :',
                        style: AppFonts.text16Bold(AppColor.bgGreen),
                      ),
                      SizedBox(height: 10),
                      // cost
                      CustomTextFieldNew(
                        controller: _costController,
                        hintText: "Enter your product cost",
                        prefixIcon: Icons.attach_money,
                        suffixText: "RM", // Added RM suffix
                        isValid: true,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the cost';
                          }
                          return null;
                        },
                      ),


                      SizedBox(height: 20),

                      Text(
                        'Product Functionality :',
                        style: AppFonts.text16Bold(AppColor.bgGreen),
                      ),
                      SizedBox(height: 10),
                      // functionality
                      CustomTextFieldNew(
                        controller: _functionalityController,
                        hintText: "Enter your product functionality",
                        prefixIcon: Icons.description,
                        isValid: true,
                        minLines: 1,
                        maxLines: 5,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          return null; // No validation needed for optional field
                        },
                      ),

                      SizedBox(height: 20),

                      Text(
                        'Product Model :',
                        style: AppFonts.text16Bold(AppColor.bgGreen),
                      ),
                      SizedBox(height: 10),
                      // model
                      CustomTextFieldNew(
                        controller: _modelController,
                        hintText: "Enter your product model",
                        prefixIcon: Icons.device_hub,
                        isValid: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the model';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      Text(
                        'Market Demand :',
                        style: AppFonts.text16Bold(AppColor.bgGreen),
                      ),
                      SizedBox(height: 10),
                      // market demand
                      CustomMarketDemandField(
                        controller: _marketDemandController,
                        hintText: 'Select Market Demand',
                        prefixIcon: Icons.assignment,
                        showError: _showError,
                        onChanged: (value) {
                          // Handle change
                          setState(() {
                            _marketDemandController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a market demand';
                          }
                          return null;
                        },
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ViewSelectedProjectID(projectId: widget.projectId)),
                    );
                  },
                  child: Text('Cancel', style: AppFonts.text16Bold(AppColor.deepGreen)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateSaveProduct();
                    } else {
                      setState(() {
                        _showError = true;
                      });
                    }
                  },
                  child: Text(
                    'Save Product',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.deepGreen,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
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
