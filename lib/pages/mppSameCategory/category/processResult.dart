import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tf_pdpppms/common/appColors.dart';

class ProcessPage extends StatefulWidget {
  final List<String> selectedProjects;

  const ProcessPage({Key? key, required this.selectedProjects}) : super(key: key);

  @override
  _ProcessPageState createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  Map<String, Map<String, dynamic>> projectDetails = {};
  bool isLoading = true;
  bool showDescriptionColumn = false;

  @override
  void initState() {
    super.initState();
    _fetchProjectData();
  }

  Future<void> _fetchProjectData() async {
    try {
      Map<String, Map<String, dynamic>> tempProjectDetails = {};
      bool hasDescription = false;

      for (String projectId in widget.selectedProjects) {
        DocumentSnapshot projectSnapshot = await FirebaseFirestore.instance
            .collection('projects')
            .doc(projectId)
            .get();

        QuerySnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('projects')
            .doc(projectId)
            .collection('products')
            .get();

        if (projectSnapshot.exists) {
          final projectData = projectSnapshot.data() as Map<String, dynamic>;
          final products = productSnapshot.docs
              .map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            if (data['launchDate'] is Timestamp) {
              data['launchDate'] = (data['launchDate'] as Timestamp).toDate();
            }

            return data;
          }).toList();

          tempProjectDetails[projectId] = {
            'projectData': projectData,
            'products': products,
          };

          if (projectData['description'] != null && projectData['description']!.isNotEmpty) {
            hasDescription = true;
          }
        } else {
          print('Project document does not exist for ID: $projectId');
        }
      }

      setState(() {
        projectDetails = tempProjectDetails;
        showDescriptionColumn = hasDescription;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching project data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.black, AppColor.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40), 
              Text(
                'Selected Projects:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'RobotoMono',
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: 800, 
                      ),
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              'Project ID',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Project Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (showDescriptionColumn)
                            DataColumn(
                              label: Text(
                                'Description',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          DataColumn(
                            label: Text(
                              'Products Count',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                        rows: projectDetails.entries.map((entry) {
                          final projectId = entry.key;
                          final details = entry.value;
                          final projectData = details['projectData'] as Map<String, dynamic>;
                          final productCount = (details['products'] as List).length;

                          return DataRow(cells: [
                            DataCell(Text(projectId, style: TextStyle(color: Colors.black.withOpacity(0.8)))),
                            DataCell(Text(projectData['projectName'] ?? 'No Name', style: TextStyle(color: Colors.black.withOpacity(0.8)))),
                            if (showDescriptionColumn)
                              DataCell(Text(projectData['description'] ?? 'No Description', style: TextStyle(color: Colors.black.withOpacity(0.8)))),
                            DataCell(Text(productCount.toString(), style: TextStyle(color: Colors.black.withOpacity(0.8)))),
                          ]);
                        }).toList(),
                        headingRowColor: MaterialStateColor.resolveWith((states) => AppColor.color4), 
                        dataRowColor: MaterialStateColor.resolveWith((states) => AppColor.color5), 
                        dividerThickness: 2,
                        showBottomBorder: true,
                        columnSpacing: 30,
                        border: TableBorder.all(color: AppColor.color3), 
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, 
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        elevation: 5,
                      ),
                      icon: Icon(Icons.close),
                      label: Text('Close'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        print('Processing projects: ${widget.selectedProjects.join(", ")}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white, 
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        elevation: 5,
                      ),
                      icon: Icon(Icons.play_arrow),
                      label: Text('Continue'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
