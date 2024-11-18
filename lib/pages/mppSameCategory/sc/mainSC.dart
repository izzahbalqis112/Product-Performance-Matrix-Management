import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tf_pdpppms/pages/mppSameCategory/sc/project/addNewProject/addNewPlanProject.dart';
import 'package:tf_pdpppms/pages/mppSameCategory/sc/project/oldProject/editProject/editSelectedProjectID.dart';
import 'package:tf_pdpppms/pages/mppSameCategory/sc/project/oldProject/product/selectedProjectID.dart';
import '../../../common/appColors.dart';
import '../complete/dialog.dart';
import '../mainPage.dart';

class MainSCPage extends StatefulWidget {
  @override
  _MainSCPageState createState() => _MainSCPageState();
}

class _MainSCPageState extends State<MainSCPage> with TickerProviderStateMixin {
  late Future<List<DocumentSnapshot>> ongoingProjects;
  late Future<List<DocumentSnapshot>> newProjects;
  late Future<List<DocumentSnapshot>> oldProjects;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  void _loadProjects() {
    setState(() {
      ongoingProjects = fetchProjects('Ongoing Project');
      newProjects = fetchProjects('New Project');
      oldProjects = fetchProjects('Old Project');
    });
  }

  Future<List<DocumentSnapshot>> fetchProjects(String projectType) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('projects')
        .where('projectType', isEqualTo: projectType)
        .get();
    return querySnapshot.docs;
  }


  Future<void> deleteProject(String projectId) async {
    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .delete();
      _loadProjects();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting project: $e')),
      );
    }
  }

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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.color4, AppColor.color5],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60.0),
                    bottomRight: Radius.circular(60.0),
                  ),
                ),
                child: AddProjectWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProjectListWidget(title: 'Ongoing Projects', projectType: 'Ongoing Project'),
                    ProjectListWidget(title: 'New Projects', projectType: 'New Project'),
                    ProjectListWidget(title: 'Old Projects', projectType: 'Old Project'),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget AddProjectWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical:20, horizontal: 20),
      height: 800,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Performance Matrix',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(0.2),  
                decoration: BoxDecoration(
                  color: AppColor.color3,
                  borderRadius: BorderRadius.circular(20.0),  
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2.0,  
                      offset: Offset(0, 3),  
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () async {
                    bool? result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AddProjectDialog();
                      },
                    );
                    if (result == true) {
                      _loadProjects(); 
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),  
                    backgroundColor: Colors.transparent,
                  ),
                  child: Text(
                    'Add Project',
                    style: TextStyle(
                      fontSize: 12,  
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Boejang Table',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 128,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.white,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/img/BoejangPerformanceMatrixTable.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Widget ProjectListWidget({required String title, required String projectType}) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: fetchProjects(projectType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No $title found.'));
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: 820,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!.map((project) {
                      final data = project.data() as Map<String, dynamic>?;
                      final projectName = data != null && data.containsKey('projectName')
                          ? data['projectName']
                          : 'No Name';
                      final projectDescription = data != null && data.containsKey('projectDescription')
                          ? data['projectDescription']
                          : null; 
                      final startDate = data != null && data.containsKey('startDate') && data['startDate'] is Timestamp
                          ? formatDate((data['startDate'] as Timestamp).toDate().toLocal())
                          : 'No Start Date';
                      final endDate = data != null && data.containsKey('endDate') && data['endDate'] is Timestamp
                          ? formatDate((data['endDate'] as Timestamp).toDate().toLocal())
                          : 'No End Date';
                      final projectStatus = data != null && data.containsKey('projectStatus')
                          ? data['projectStatus']
                          : 'Unknown Status';
                      final projectCategory = data != null && data.containsKey('category')
                          ? data['category']
                          : 'Unknown Category';
                      final projectTeamLeadName = data != null && data.containsKey('teamLeadName')
                          ? data['teamLeadName']
                          : 'Unknown Team Lead Name';

                      return Slidable(
                        key: ValueKey(project.id),
                        direction: Axis.horizontal,
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewSelectedProjectID(projectId: project.id),
                                  ),
                                );
                              },
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.white,
                              icon: Icons.visibility,
                              label: 'View',
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              borderRadius: BorderRadius.circular(12),
                              autoClose: true,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditSelectedProjectIDPage(projectId: project.id),
                                  ),
                                );
                              },
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              borderRadius: BorderRadius.circular(12),
                              autoClose: true,
                            ),
                            SlidableAction(
                              onPressed: (context) async {
                                await deleteProject(project.id);
                              },
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              borderRadius: BorderRadius.circular(12),
                              autoClose: true,
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          width: MediaQuery.of(context).size.width * 0.9,
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
                                      '$projectStatus',
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
                                {'icon': Icons.date_range, 'text': 'Start Date: $startDate'},
                                {'icon': Icons.date_range, 'text': 'End Date: $endDate'},
                                {'icon': Icons.category, 'text': 'Category: $projectCategory'},
                                {'icon': Icons.person, 'text': 'Team Lead: $projectTeamLeadName'},
                                if (projectDescription != null && projectDescription.isNotEmpty)
                                  {'icon': Icons.description, 'text': 'Description: $projectDescription'},
                              ].map(
                                    (item) => Container(
                                  padding: const EdgeInsets.all(12.0),
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: MediaQuery.of(context).size.width * 0.8,
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
                              Row(
                                children: [
                                  Checkbox(
                                    value: projectStatus == 'Completed',
                                    onChanged: (bool? value) async {
                                      if (value == true) {
                                        bool? result = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return CompletionDialog(projectId: project.id);
                                          },
                                        );
                                        if (result == true) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Project marked as completed.')),
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ButtonPage(initialTabIndex: 1),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  Text(
                                    'Mark as Completed',
                                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
