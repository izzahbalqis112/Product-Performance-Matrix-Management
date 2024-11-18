import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tf_pdpppms/dataModel/projectModel.dart';
import '../../../../../common/appColors.dart';
import '../../../../../common/appFonts.dart';
import '../../../../../common/widget/customCategoryField.dart';
import '../../../../../controller/navbar.dart';
import '../../../../../common/widget/customTextFieldNew.dart';
import '../../../../../common/widget/customLeadTimeField.dart';
import '../../../../../common/widget/customTeamLeadName.dart';
import '../../../../../common/widget/customStatusField.dart';
import '../../../../../common/widget/projectTypeField.dart';
import '../../../../../common/widget/datepicker.dart';

class AddProjectDialog extends StatefulWidget {
  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _projectIdController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _leadTimeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _projectTypeController = TextEditingController();
  final _teamLeadNameController = TextEditingController();
  final _projectStatusController = TextEditingController();
  bool _isTeamLeadNameValid = true;
  bool _isProjectNameValid = true;
  DateTime? _startDate;
  DateTime? _endDate; 
  bool _showError = false;

  List<String> _categories = ['Teachnology', 'Healthcare', 'Finance', 'Manufacturing', 'Retail', 'Energy'];

  bool get _isProjectCompleted {
    return _projectStatusController.text == 'Completed';
  }

  @override
  void initState() {
    super.initState();
    _startDateController.addListener(_updateLeadTime);
    _endDateController.addListener(_updateLeadTime);
  }

  @override
  void dispose() {
    _startDateController.removeListener(_updateLeadTime);
    _endDateController.removeListener(_updateLeadTime);
    _projectIdController.dispose();
    _projectNameController.dispose();
    _descriptionController.dispose();
    _teamLeadNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _leadTimeController.dispose();
    _categoryController.dispose();
    _projectStatusController.dispose();
    _projectTypeController.dispose();

    super.dispose();
  }

  void _saveProject() async {
    if (!_formKey.currentState!.validate()) return;
    DateTime startDate = _startDate ?? DateTime.now();
    DateTime endDate = _endDate ?? DateTime.now();
    int leadTime = int.tryParse(_leadTimeController.text) ?? 0;

    try {
      ProjectModel projectModel = ProjectModel(
        projectId: _projectIdController.text,
        projectName: _projectNameController.text,
        description: _descriptionController.text,
        startDate: startDate,
        endDate: endDate,
        leadTime: leadTime,
        category: _categoryController.text,
        projectType: _projectTypeController.text,
        teamLeadName: _teamLeadNameController.text,
        projectStatus: _projectStatusController.text,
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

      await FirebaseFirestore.instance.collection('projects').doc(projectModel.projectId).set(projectData);
      _showSuccessMessage('Project saved successfully!');
      Navigator.pop(context, true);
    } catch (e) {
      _showErrorMessage('Failed to save project: $e');
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add New Project',
              style: AppFonts.text24(AppColor.black),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please re-select your project type, status and category.',
                        style: AppFonts.text14Normal(AppColor.black.withOpacity(0.6)),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Project ID :',
                        style: AppFonts.text16Bold(AppColor.deepGreen1),
                      ),
                      SizedBox(height: 5),
                      CustomTextFieldNew(
                        controller: _projectIdController,
                        hintText: "Enter your project id",
                        prefixIcon: Icons.code,
                        isValid: true,
                        onChanged: (value) {
                          setState(() {
                            _projectIdController.text = value.toUpperCase();
                            _projectIdController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _projectIdController.text.length),
                            );
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a project ID';
                          }
                          if (value.length > 10) {
                            return 'Project ID must not exceed 10 characters';
                          }
                          if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
                            return 'Project ID must contain only uppercase letters and numbers';
                          }
                          if (!RegExp(r'\d').hasMatch(value)) {
                            return 'Project ID must contain at least one number';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

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
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(255),
                        ],
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

                      if (!_isProjectCompleted)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Project Status :',
                              style: AppFonts.text16Bold(AppColor.deepGreen1),
                            ),
                            SizedBox(height: 5),
                            CustomProjectStatusField(
                              controller: _projectStatusController,
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
                          ],
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
                      MaterialPageRoute(
                        builder: (context) => ButtomNavBar(initialIndex: 2),
                      ),
                    );
                  },
                  child: Text('Cancel', style: AppFonts.text16Bold(AppColor.deepGreen)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveProject();
                    } else {
                      setState(() {
                        _showError = true;
                      });
                    }
                  },
                  child: Text(
                    'Save Project',
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
