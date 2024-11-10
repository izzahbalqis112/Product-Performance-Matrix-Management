import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../common/appColors.dart';

class CPPage extends StatefulWidget {
  @override
  _CPPageState createState() => _CPPageState();
}

Future<List<DocumentSnapshot>> fetchCompletedProjects() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('projects')
      .where('projectStatus', isEqualTo: 'Completed') // Filter by completed status
      .get();
  return querySnapshot.docs;
}

class _CPPageState extends State<CPPage> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            spawnMaxRadius: 20,
            spawnMaxSpeed: 6,
            particleCount: 60,
            spawnMinSpeed: 6,
            minOpacity: 0.3,
            spawnOpacity: 0.4,
            baseColor: AppColor.bgGreen,
            image: Image(
              image: AssetImage("assets/img/TF-logo.png"),
            ),
          ),
        ),
        vsync: this,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              CategoryProjectWidget(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget CategoryProjectWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Completed Projects',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          FutureBuilder<List<DocumentSnapshot>>(
            future: fetchCompletedProjects(), // Fetch completed projects
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No completed projects found.'));
              }

              return Column(
                children: snapshot.data!.map((project) {
                  final data = project.data() as Map<String, dynamic>?;

                  final projectName = data != null && data.containsKey('projectName')
                      ? data['projectName']
                      : 'No Name';
                  final startDate = data != null && data.containsKey('actualDate') && data['actualDate'] is Timestamp
                      ? formatDate((data['actualDate'] as Timestamp).toDate().toLocal())
                      : 'No Start Date';
                  final endDate = data != null && data.containsKey('actualEndDate') && data['actualEndDate'] is Timestamp
                      ? formatDate((data['actualEndDate'] as Timestamp).toDate().toLocal())
                      : 'No End Date';
                  final leadTime = data != null && data.containsKey('actualLeadTime')
                      ? data['actualLeadTime']
                      : 'No Lead Time';
                  final projectType = data != null && data.containsKey('projectType')
                      ? data['projectType']
                      : 'Unknown project type';
                  final projectCategory = data != null && data.containsKey('category')
                      ? data['category']
                      : 'Unknown Category';
                  final projectTeamLeadName = data != null && data.containsKey('teamLeadName')
                      ? data['teamLeadName']
                      : 'Unknown Team Lead Name';
                  final projectDescription = data != null && data.containsKey('projectDescription')
                      ? data['projectDescription']
                      : null;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColor.color4, AppColor.color5],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                projectName,
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22.0,
                                  letterSpacing: 1.1,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  color: AppColor.deepGreen1,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        ...[
                          {'icon': Icons.date_range, 'text': 'Actual Start Date : $startDate'},
                          {'icon': Icons.date_range, 'text': 'Actual End Date : $endDate'},
                          {'icon': Icons.timeline, 'text': 'Actual Lead Time : $leadTime'},
                          {'icon': Icons.merge_type, 'text': 'Type : $projectType'},
                          {'icon': Icons.category, 'text': 'Category : $projectCategory'},
                          {'icon': Icons.person, 'text': 'Team Lead : $projectTeamLeadName'},
                          if (projectDescription != null && projectDescription.isNotEmpty)
                            {'icon': Icons.description, 'text': 'Description : $projectDescription'},
                        ].map(
                              (item) => Container(
                            padding: const EdgeInsets.all(12.0),
                            margin: const EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item['icon'] as IconData,
                                  color: AppColor.deepGreen1,
                                  size: 20.0,
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    item['text'] as String,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16.0,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).toList(),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}

