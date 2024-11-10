import 'package:flutter/material.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import 'package:tf_pdpppms/pages/mppSameCategory/category/mainCtg.dart';
import 'package:tf_pdpppms/pages/mppSameCategory/complete/CompletedProjectsPage.dart';
import 'package:tf_pdpppms/pages/mppSameCategory/sc/mainSC.dart';


class ButtonPage extends StatefulWidget {
  final int initialTabIndex;

  ButtonPage({required this.initialTabIndex});

  @override
  _ButtonPageState createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.black,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 5,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            alignment: Alignment.center,
            child: TabBar(
              controller: _tabController,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColor.white,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: AppColor.white70,
              ),
              tabs: [
                Tab(text: 'Main'),
                Tab(text: 'Complete'),
                Tab(text: 'Category'),
              ],
              indicatorColor: AppColor.white,
              indicatorWeight: 4.0,
              isScrollable: false,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MainSCPage(),
          CPPage(),
          MainCtgResultsPage(),
        ],
      ),
    );
  }
}
