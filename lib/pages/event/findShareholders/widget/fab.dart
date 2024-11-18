import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import 'addShareholder.dart';
import 'editShareholder.dart';

class SpeedDialButton extends StatelessWidget {
  final bool dialVisible;

  SpeedDialButton({this.dialVisible = true});

  void _navigateToAddShareholderDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddShareholderDetails(
          onDataSubmitted: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _navigateToEditShareholder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditShareholder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      spacing: 5,
      spaceBetweenChildren: 5,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: dialVisible,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: AppColor.bgGreen1,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add_outlined),
          backgroundColor: AppColor.bgGreen1,
          labelWidget: Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Add',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontFamily: 'Ubuntu',
              ),
            ),
          ),
          onTap: () => _navigateToAddShareholderDetails(context),
          shape: CircleBorder(),
        ),
        SpeedDialChild(
          child: Icon(Icons.edit_outlined),
          backgroundColor: AppColor.bgGreen1,
          labelWidget: Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontFamily: 'Ubuntu',
              ),
            ),
          ),
          onTap: () => _navigateToEditShareholder(context),
          shape: CircleBorder(),
        ),
        SpeedDialChild(
          child: Icon(Icons.delete_outline),
          backgroundColor: AppColor.bgGreen1,
          labelWidget: Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontFamily: 'Ubuntu',
              ),
            ),
          ),
          onTap: () => print('THIRD CHILD'),
          shape: CircleBorder(),
        ),
      ],
    );
  }
}
