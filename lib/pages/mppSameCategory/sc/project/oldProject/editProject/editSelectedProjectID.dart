import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import '../../../../../../common/appFonts.dart';
import '../../../../../../common/widget/customCategoryField.dart';
import '../../../../../../common/widget/customStatusField.dart';
import '../../../../../../common/widget/customTeamLeadName.dart';
import '../../../../../../common/widget/projectTypeField.dart';
import '../../../../../../controller/navbar.dart';
import '../../../../../../dataModel/projectModel.dart';
import '../../../../../../common/widget/customLeadTimeField.dart';
import '../../../../../../common/widget/datepicker.dart';
import '../../../../../../common/widget/customTextFieldNew.dart';

class EditSelectedProjectIDPage extends StatefulWidget {
  final String projectId;

  EditSelectedProjectIDPage({required this.projectId});

  @override
  _EditSelectedProjectIDPageState createState() => _EditSelectedProjectIDPageState();
}

class _EditSelectedProjectIDPageState extends State<EditSelectedProjectIDPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _projectNameController;
  late TextEditingController _teamLeadNameController;
  late TextEditingController _projectTypeController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _leadTimeController;
  late TextEditingController _statusController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _actualCostController;
  late TextEditingController _budgetController;
  bool _isTeamLeadNameValid = true;
  bool _isProjectNameValid = true;
  bool _showError = false;
  DateTime? _startDate;
  DateTime? _endDate;

  List<String> _categories = ['Teachnology', 'Healthcare', 'Finance', 'Manufacturing', 'Retail', 'Energy'];

  @override
  void initState() {
    super.initState();
    _projectNameController = TextEditingController();
    _teamLeadNameController = TextEditingController();
    _projectTypeController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _leadTimeController = TextEditingController();
    _statusController = TextEditingController();
    _categoryController = TextEditingController();
    _descriptionController = TextEditingController();
    _actualCostController = TextEditingController();
    _budgetController = TextEditingController();
    _startDateController.addListener(_updateLeadTime);
    _endDateController.addListener(_updateLeadTime);
    _loadProjectData();
  }

  @override
  void dispose() {
    _startDateController.removeListener(_updateLeadTime);
    _endDateController.removeListener(_updateLeadTime);
    _projectNameController.dispose();
    _descriptionController.dispose();
    _teamLeadNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _leadTimeController.dispose();
    _categoryController.dispose();
    _statusController.dispose();
    _actualCostController.dispose();
    _budgetController.dispose();
    _projectTypeController.dispose();
    super.dispose();
  }

  void _updateLeadTime() {
    final startDateText = _startDateController.text;
    final endDateText = _endDateController.text;

    if (startDateText.isNotEmpty && endDateText.isNotEmpty) {
      try {
        final start = DateFormat('dd-MM-yyyy').parse(startDateText);
        final end = DateFormat('dd-MM-yyyy').parse(endDateText);

        if (end.isAfter(start)) {
          final leadTime = end.difference(start).inDays;
          _leadTimeController.text = leadTime.toString();
        } else {
          _leadTimeController.text = '0'; 
        }
        setState(() {
          _endDate = end;
        });
      } catch (e) {
        _leadTimeController.text = '0';
      }
    }
  }

  Future<void> _loadProjectData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('projects').doc(widget.projectId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _projectNameController.text = data['projectName'] ?? '';
          _teamLeadNameController.text = data['teamLeadName'] ?? '';
          _projectTypeController.text = data['projectType'] ?? '';
          _categoryController.text = data['category'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _statusController.text = data['projectStatus'] ?? '';
          _startDate = (data['startDate'] as Timestamp).toDate();
          _endDate = (data['endDate'] as Timestamp).toDate();
          _startDateController.text = DateFormat('dd-MM-yyyy').format(_startDate!);
          _endDateController.text = DateFormat('dd-MM-yyyy').format(_endDate!);
          _updateLeadTime(); 
        });
      }
    } catch (e) {
      _showErrorMessage('Failed to load project data: $e');
    }
  }

  void _updateSaveProject() async {
    if (!_formKey.currentState!.validate()) return;
    DateTime startDate = _startDate ?? DateTime.now();
    DateTime endDate = _endDate ?? DateTime.now();
    int leadTime = int.tryParse(_leadTimeController.text) ?? 0;

    try {
      ProjectModel projectModel = ProjectModel(
        projectId: widget.projectId, 
        projectName: _projectNameController.text,
        description: _descriptionController.text,
        startDate: startDate,
        endDate: endDate,
        leadTime: leadTime,
        category: _categoryController.text,
        projectType: _projectTypeController.text,
        teamLeadName: _teamLeadNameController.text,
        projectStatus: _statusController.text,
      );

      Map<String, dynamic> projectData = {
        'projectId': projectModel.projectId,
        'projectName': projectModel.projectName,
        'description': projectModel.description ?? '',
        'startDate': projectModel.startDate,
        'endDate': projectModel.endDate,
        'leadTime': '${projectModel.leadTime} days',
        'category': projectModel.category,
        'projectType': projectModel.projectType,
        'teamLeadName': projectModel.teamLeadName,
        'projectStatus': projectModel.projectStatus,
      };

      await FirebaseFirestore.instance.collection('projects').doc(projectModel.projectId).update(projectData);
      _showSuccessMessage('Project updated successfully!');
      Navigator.pop(context, true);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ButtomNavBar(initialIndex: 2)),
      );
    } catch (e) {
      _showErrorMessage('Failed to update project: $e');
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
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColor.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ButtomNavBar(initialIndex: 2),
              ),
            );
          },
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'Edit Project Details',
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
                        'Please re-select your project type, status and category.',
                        style: AppFonts.text18Bold(AppColor.bgGreen1),
                      ),
                      SizedBox(height: 20,),
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
                              'Project Name :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 5),
                            CustomTextFieldNew(
                              controller: _projectNameController,
                              hintText: "Enter your project name",
                              prefixIcon: Icons.title,
                              isValid: _isProjectNameValid,
                              onChanged: (value) {
                                setState(() {
                                  _isProjectNameValid = value.isNotEmpty;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a project name';
                                } else if (value.length > 255) {
                                  return 'Project name cannot exceed 255 characters';
                                }
                                return null;
                              },
                            ),
                            if (!_isProjectNameValid)
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Project name cannot be empty',
                                  style: TextStyle(color: Colors.red, fontSize: 14),
                                ),
                              ),

                            SizedBox(height: 20),

                            Text(
                              'Team Leader Name :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 5),
                            CustomTeamLeadNameField(
                              controller: _teamLeadNameController,
                              isValid: _isTeamLeadNameValid,
                              onChanged: (value) {
                                setState(() {
                                  _isTeamLeadNameValid = value.isNotEmpty;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a team lead name';
                                } else if (value.length > 255) {
                                  return 'Team lead name cannot exceed 255 characters';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Project Type :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 5),
                            CustomProjectTypeField(
                              controller: _projectTypeController,
                              hintText: 'Select your project type',
                              prefixIcon: Icons.category,
                              showError: _showError, 
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a project type';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Start Date :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 5),
                            DatePicker(
                              controller: _startDateController,
                              hintText: "Select your start date for the project",
                              prefixIcon: Icons.calendar_today,
                              isValid: true,
                              onChanged: (value) {
                                setState(() {
                                  _startDate = DateFormat('dd-MM-yyyy').parse(value);
                                  _updateLeadTime();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a start date';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            Text(
                              'End Date :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 5),
                            DatePicker(
                              controller: _endDateController,
                              hintText: "Select your end date for the project",
                              prefixIcon: Icons.calendar_today,
                              isValid: true,
                              minDate: _startDate,
                              onChanged: (value) {
                                setState(() {
                                  _endDate = DateFormat('dd-MM-yyyy').parse(value);
                                  _updateLeadTime(); 
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select an end date';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Lead Time :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 5),
                            CustomLeadTimeField(
                              startDateController: _startDateController,
                              endDateController: _endDateController,
                              leadTimeController: _leadTimeController,
                              hintText: "Project lead time",
                              isValid: true,
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a lead time';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Project Status :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 5),
                            CustomProjectStatusField(
                              controller: _statusController,
                              hintText: 'Select your project status',
                              prefixIcon: Icons.assignment,
                              showError: _showError,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a project status';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Project Category :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 5),
                            CustomCategoryField(
                              controller: _categoryController,
                              hintText: 'Select your project category',
                              prefixIcon: Icons.category,
                              showError: _showError, 
                              categories: _categories,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a category';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 20),

                            Text(
                              'Description (Optional) :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 5),
                            CustomTextFieldNew(
                              controller: _descriptionController,
                              hintText: "Enter your project description",
                              prefixIcon: Icons.description,
                              isValid: true,
                              minLines: 1,
                              maxLines: 5,
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateSaveProject();
                    } else {
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
