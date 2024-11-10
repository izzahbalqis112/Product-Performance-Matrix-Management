import 'package:flutter/material.dart';
import '../../common/appColors.dart';
import 'event/eventMainPage.dart';
import 'findShareholders/ShareholderPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          preferredSize: const Size.fromHeight(50),
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
                color: AppColor.grey,
              ),
              tabs: const [
                Tab(text: 'Events'),
                Tab(text: 'Shareholders'),
              ],
              indicatorColor: AppColor.white,
              indicatorWeight: 2.0,
              isScrollable: false,
            ),
          ),
        ),
      ),
      body: Container(
        color: AppColor.black,
        child: TabBarView(
          controller: _tabController,
          children: const [
            EventMainPage(),
            ShareholdersPage(),
          ],
        ),
      ),
    );
  }
}
