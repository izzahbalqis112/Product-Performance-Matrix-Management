import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tf_pdpppms/pages/mppSameCategory/category/processResult.dart';
import '../../../common/appColors.dart';
import '../sc/project/oldProject/product/add/effienciencyAndEffectiveness/result/resultProcess.dart';

class MainCtgResultsPage extends StatefulWidget {
  @override
  _MainCtgResultsPageState createState() => _MainCtgResultsPageState();
}

class _MainCtgResultsPageState extends State<MainCtgResultsPage> with TickerProviderStateMixin {
  Map<String, List<Map<String, dynamic>>> categorizedProjects = {};
  Map<String, List<String>> selectedProjects = {}; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoriesAndProjects();
  }

  Future<void> _fetchCategoriesAndProjects() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance.collection('projects').get();

      final allProjects = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'projectName': data['projectName'] ?? '',
          'projectId': data['projectId'] ?? '',
          'category': data['category'] ?? '',
        };
      }).toList();

      final categories = allProjects.map((project) => project['category'] as String).toSet();

      final projectsByCategory = <String, List<Map<String, dynamic>>>{};
      for (var category in categories) {
        final categoryProjects = allProjects.where((project) => project['category'] == category).toList();
        projectsByCategory[category] = categoryProjects;
      }

      setState(() {
        categorizedProjects = projectsByCategory;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching project data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onProjectSelected(String category, String projectId) {
    setState(() {
      if (selectedProjects[category] == null) {
        selectedProjects[category] = [];
      }

      if (selectedProjects[category]!.contains(projectId)) {
        selectedProjects[category]!.remove(projectId);
      } else {
        if (selectedProjects[category]!.length < 2) {
          selectedProjects[category]!.add(projectId);
        }
      }
    });
  }

  void _processSelectedProjects(String category) {
    final selected = selectedProjects[category];
    if (selected != null && selected.length == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProcessPage(
            selectedProjects: selected,
          ),
        ),
      );
    } else {
      print('Please select two projects from the $category category.');
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
            image: Image.asset("assets/img/TF-logo.png"),
          ),
        ),
        vsync: this,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (categorizedProjects.isEmpty)
                Center(child: Text('No data available', style: TextStyle(color: Colors.white)))
              else
                ...categorizedProjects.entries.map((entry) => _CategoryProjectWidget(entry.key, entry.value)),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _CategoryProjectWidget(String category, List<Map<String, dynamic>> projects) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Center(
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 400,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                final projectName = project['projectName'] as String? ?? '';
                final projectId = project['projectId'] as String? ?? '';
                final isSelected = selectedProjects[category]?.contains(projectId) ?? false;

                return GestureDetector(
                  onTap: () => _onProjectSelected(category, projectId),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: isSelected
                          ? LinearGradient(
                        colors: [AppColor.bgGreen1, AppColor.bgGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : LinearGradient(
                        colors: [AppColor.color4, AppColor.color5],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            projectName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withOpacity(0.3),
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'ID: $projectId',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: selectedProjects[category]?.length == 2
                  ? () => _processSelectedProjects(category)
                  : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  selectedProjects[category]?.length == 2
                      ? AppColor.color3
                      : Colors.grey,
                ),
              ),
              child: Text(
                'Process',
                style: TextStyle(
                  color: selectedProjects[category]?.length == 2
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
