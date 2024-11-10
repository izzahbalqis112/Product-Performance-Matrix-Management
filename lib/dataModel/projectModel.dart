import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String projectId;
  final String projectName;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final int leadTime;
  final DateTime? actualStartDate;
  final DateTime? actualEndDate;
  final int? actualLeadTime;
  final String category;
  final String projectType;
  final String teamLeadName;
  final String projectStatus;

  ProjectModel({
    required this.projectId,
    required this.projectName,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.leadTime,
    this.actualStartDate,
    this.actualEndDate,
    this.actualLeadTime,
    required this.category,
    required this.projectType,
    required this.teamLeadName,
    required this.projectStatus,
  });

  factory ProjectModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data()!;
    return ProjectModel(
      projectId: doc.id,
      projectName: data['projectName'] as String,
      description: data['description'] as String?,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      leadTime: data['leadTime'] as int,
      actualStartDate: data.containsKey('actualStartDate')
          ? (data['actualStartDate'] as Timestamp).toDate()
          : null,
      actualEndDate: data.containsKey('actualEndDate')
          ? (data['actualEndDate'] as Timestamp).toDate()
          : null,
      actualLeadTime: data['actualLeadTime'] as int?,
      category: data['category'] as String,
      projectType: data['projectType'] as String,
      teamLeadName: data['teamLeadName'] as String,
      projectStatus: data['projectStatus'] as String,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      projectId: json['projectId'] as String,
      projectName: json['projectName'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      leadTime: json['leadTime'] as int,
      actualStartDate: json.containsKey('actualStartDate')
          ? DateTime.parse(json['actualStartDate'] as String)
          : null,
      actualEndDate: json.containsKey('actualEndDate')
          ? DateTime.parse(json['actualEndDate'] as String)
          : null,
      actualLeadTime: json['actualLeadTime'] as int?,
      category: json['category'] as String,
      projectType: json['projectType'] as String,
      teamLeadName: json['teamLeadName'] as String,
      projectStatus: json['projectStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'projectName': projectName,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'leadTime': leadTime,
      'actualStartDate': actualStartDate != null
          ? Timestamp.fromDate(actualStartDate!)
          : null,
      'actualEndDate': actualEndDate != null
          ? Timestamp.fromDate(actualEndDate!)
          : null,
      'actualLeadTime': actualLeadTime,
      'category': category,
      'projectType': projectType,
      'teamLeadName': teamLeadName,
      'projectStatus': projectStatus,
    };
  }
}
