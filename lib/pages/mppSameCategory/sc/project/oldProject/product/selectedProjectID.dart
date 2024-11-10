import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import '../../../../../../controller/navbar.dart';
import 'add/addNewProduct.dart';
import 'add/effienciencyAndEffectiveness/actual/efficiencyFactors1.dart';
import 'add/effienciencyAndEffectiveness/planned/efficiencyFactors.dart';
import 'add/effienciencyAndEffectiveness/result/resultProcess.dart';
import 'edit/editNewProduct.dart';

class ViewSelectedProjectID extends StatefulWidget {
  final String projectId;

  ViewSelectedProjectID({required this.projectId});


  @override
  _ViewSelectedProjectIDState createState() => _ViewSelectedProjectIDState();
}

class _ViewSelectedProjectIDState extends State<ViewSelectedProjectID> {
  Map<String, dynamic>? projectData;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  bool hasData = false;
  bool _hasEfficiencyData = false;
  bool _hasEfficiencyData1 = false;

  @override
  void initState() {
    super.initState();
    _fetchProjectData();
  }

  Future<void> _fetchEfficiencyData(String productId) async {
    try {
      var plannedCollectionRef = FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('products')
          .doc(productId)
          .collection('planned');

      var collectionSnapshot = await plannedCollectionRef.get();
      setState(() {
        _hasEfficiencyData = collectionSnapshot.docs.isNotEmpty;
      });
    } catch (e) {
      _showErrorMessage('Error fetching efficiency data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchEfficiencyData1(String productId) async {
    try {
      var actualCollectionRef = FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('products')
          .doc(productId)
          .collection('actual');

      var collectionSnapshot = await actualCollectionRef.get();
      setState(() {
        _hasEfficiencyData1 = collectionSnapshot.docs.isNotEmpty;
      });
    } catch (e) {
      _showErrorMessage('Error fetching efficiency data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _fetchProjectData() async {
    try {
      DocumentSnapshot projectSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .get();

      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('products')
          .get();

      if (projectSnapshot.exists) {
        setState(() {
          projectData = projectSnapshot.data() as Map<String, dynamic>;
          products = productSnapshot.docs
              .map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // Convert Timestamp to DateTime if needed
            if (data['launchDate'] is Timestamp) {
              data['launchDate'] = (data['launchDate'] as Timestamp).toDate();
            }

            return data;
          })
              .toList();
          hasData = products.isNotEmpty;
          isLoading = false;
        });
      } else {
        print('Project document does not exist.');
        setState(() {
          isLoading = false;
          hasData = false;
        });
      }
    } catch (e) {
      print('Error fetching project data: $e');
      setState(() {
        isLoading = false;
        hasData = false;
      });
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();
    return DateFormat.yMMMd().format(dateTime);
  }

  void _showAddDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Add New Entry',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColor.black,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogButton(
                'Planned',
                Icons.assignment_outlined,
                AppColor.blue,
                AppColor.deepGreen.withOpacity(0.1),
                    () {
                  _fetchEfficiencyData(productId).then((_) {
                    if (_hasEfficiencyData) {
                      _showErrorMessage("Efficiency data already exists. Cannot create new data.");
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EfficiencyFactorsPage(
                          projectId: widget.projectId,
                          productId: productId,
                        ),
                      ),
                    );
                  }).catchError((error) {
                    _showErrorMessage('Error fetching efficiency data: $error');
                  });
                },
              ),
              SizedBox(height: 15),
              _buildDialogButton(
                'Actual',
                Icons.assignment_turned_in,
                AppColor.deepGreen,
                AppColor.blue.withOpacity(0.1),
                    () {
                  _fetchEfficiencyData1(productId).then((_) {
                    if (_hasEfficiencyData1) {
                      _showErrorMessage("Efficiency data already exists. Cannot create new data.");
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EfficiencyFactors1Page(
                          projectId: widget.projectId,
                          productId: productId,
                        ),
                      ),
                    );
                  }).catchError((error) {
                    _showErrorMessage('Error fetching efficiency data: $error');
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogButton(String text, IconData icon, Color iconColor, Color backgroundColor, VoidCallback onPressed) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: iconColor),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }

  void _showDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Select product details below :',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
              color: AppColor.black,
            ),
            textAlign: TextAlign.center,
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust spacing between buttons
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  backgroundColor: AppColor.blue.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, color: AppColor.blue),
                    SizedBox(width: 8),
                    Text(
                      'Edit',
                      style: TextStyle(color: AppColor.blue),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditSelectedProductIDPage(
                        projectId: widget.projectId,
                        productId: productId,
                      ),
                    ),
                  );
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  backgroundColor: Colors.red.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete, color: AppColor.red),
                    SizedBox(width: 8),
                    Text(
                      'Delete',
                      style: TextStyle(color: AppColor.red),
                    ),
                  ],
                ),
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('projects')
                          .doc(widget.projectId)
                          .collection('products')
                          .doc(productId)
                          .delete();
                      Navigator.pop(context);
                      _fetchProjectData(); // Refresh data after deletion
                      _showSuccessMessage('Product deleted successfully!');
                    } catch (e) {
                      _showErrorMessage('Error deleting product: $e');
                    }
                  }

              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ButtomNavBar(initialIndex: 2)),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductDialog(projectId: widget.projectId)),
              ).then((_) {
                // Refresh the product list after adding a new product
                _fetchProjectData();
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                Text(
                  'New Product',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Project Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildDetailRow(Icons.assignment, 'Project ID', projectData?['projectId'] ?? 'N/A'),
                  _buildDetailRow(Icons.person, 'Project Name', projectData?['projectName'] ?? 'N/A'),
                  _buildDetailRow(Icons.people, 'Team Lead Name', projectData?['teamLeadName'] ?? 'N/A'),
                  _buildDetailRow(Icons.category, 'Project Type', projectData?['projectType'] ?? 'N/A'),
                  _buildDetailRow(Icons.date_range, 'Start Date', _formatTimestamp(projectData?['startDate'])),
                  _buildDetailRow(Icons.date_range, 'End Date', _formatTimestamp(projectData?['endDate'])),
                  _buildDetailRow(Icons.timer, 'Lead Time', '${projectData?['leadTime'] ?? 'N/A'} '),
                  _buildDetailRow(Icons.info, 'Status', projectData?['projectStatus'] ?? 'N/A'),
                  _buildDetailRow(Icons.label, 'Category', projectData?['category'] ?? 'N/A'),
                  // Conditional rendering based on project status
                  if (projectData?['projectStatus'] == 'Completed') ...[
                    _buildDetailRow(Icons.date_range, 'Actual Start Date', _formatTimestamp(projectData?['actualDate'])),
                    _buildDetailRow(Icons.date_range, 'Actual End Date', _formatTimestamp(projectData?['actualEndDate'])),
                    _buildDetailRow(Icons.timer, 'Actual Lead Time', '${projectData?['actualLeadTime'] ?? 'N/A'}'),
                  ],
                  if (projectData?['description'] != null && projectData!['description'].isNotEmpty)
                    _buildDetailRow(Icons.description, 'Description', projectData?['description'] ?? 'N/A'),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Product Lists',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      'No products available.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  );
                }
                var product = products[index];

                // Convert launchDate to string format
                String launchDateString = product['launchDate'] != null
                    ? DateFormat.yMMMd().format(product['launchDate'] as DateTime)
                    : 'N/A';

                return Slidable(
                  key: ValueKey(index),
                  direction: Axis.horizontal,
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _showAddDialog(context, product['productId']);
                        },
                        backgroundColor: AppColor.color7,
                        foregroundColor: Colors.white,
                        icon: Icons.add,
                        label: 'Add',
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        borderRadius: BorderRadius.circular(12),
                        autoClose: true,
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultProcessPage(projectId: widget.projectId, productId: product['productId']),
                            ),
                          );
                        },
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.report,
                        label: 'Process the Result',
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        borderRadius: BorderRadius.circular(12),
                        autoClose: true,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _showDialog(context, products[index]['productId']);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColor.color3, AppColor.color6],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.production_quantity_limits,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  product['productName'] ?? 'No Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    color: AppColor.color5, // Use bgGreen1 for the background color
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(
                                    product['productStatus'] ?? 'No Status',
                                    style: TextStyle(
                                      color: Colors.black, // Text color is black
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            _buildProductDetail('Product ID', product['productId']),
                            _buildProductDetail('Launch Date', launchDateString),
                            _buildProductDetail('Cost', '${product['cost'] ?? 'N/A'}'),
                            _buildProductDetail('Functionality', '${product['functionality'] ?? 'N/A'}'),
                            _buildProductDetail('Market Demand', '${product['marketDemand'] ?? 'N/A'}'),
                            _buildProductDetail('Model', '${product['model'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: products.isEmpty ? 1 : products.length, // Show a single item if empty
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
