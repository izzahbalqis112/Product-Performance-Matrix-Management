import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tf_pdpppms/common/appColors.dart';
//import 'package:tf_pdpppms/pages/mppCurrentProject/mainCP.dart';
import 'package:tf_pdpppms/pages/userProfile/profile.dart';
import '../pages/event/mainPage.dart';
import '../pages/mppSameCategory/mainPage.dart';

class ButtomNavBar extends StatefulWidget {
  final int initialIndex;

  ButtomNavBar({this.initialIndex = 0});

  @override
  _ButtomNavBarState createState() => _ButtomNavBarState();
}

class _ButtomNavBarState extends State<ButtomNavBar> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  final screens = [
    //MainCPPage(),
    ProfilePage(),
    MainPage(),
    ButtonPage(initialTabIndex: 0),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      /*AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(index == 0 ? 8.0 : 0),
        child: Icon(
          Icons.file_present,
          size: 26,
          color: index == 0 ? AppColor.deepGreen : AppColor.black.withOpacity(0.4),
        ),
      ),
       */
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(index == 0 ? 8.0 : 0),
        child: Icon(
          Icons.person,
          size: 26,
          color: index == 0 ? AppColor.darkgrey : Colors.black.withOpacity(0.4),
        ),
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(index == 1 ? 8.0 : 0),
        child: Icon(
          Icons.event,
          size: 26,
          color: index == 1 ? AppColor.darkgrey : Colors.black.withOpacity(0.4),
        ),
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(index == 2 ? 8.0 : 0),
        child: Icon(
          Icons.label_important,
          size: 26,
          color: index == 2 ? AppColor.darkgrey : Colors.black.withOpacity(0.4),
        ),
      ),
    ];

    return Container(
      color: AppColor.black,
      child: SafeArea(
        top: true,
        child: Scaffold(
          extendBody: true,
          body: screens[index],
          bottomNavigationBar: CurvedNavigationBar(
            height: 60,
            index: index,
            items: items,
            color: AppColor.color4,
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            onTap: (newIndex) {
              setState(() {
                index = newIndex;
              });
            },
          ),
        ),
      ),
    );
  }
}
