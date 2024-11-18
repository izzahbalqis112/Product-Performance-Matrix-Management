import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/appColors.dart';
import '../../common/appFonts.dart';
import '../auth/login.dart';
import 'editPicture.dart';
import 'editProfile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;
  Map<String, dynamic>? _userProfileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  final List<Map<String, dynamic>> profileMethods = [
    {'method': 'Edit Profile', 'icon': Icons.edit},
    {'method': 'Request Deletion', 'icon': Icons.delete_forever},
    {'method': 'Logout', 'icon': Icons.logout},
  ];

  String selectedMethod = 'Edit Profile';

  Future<void> _getCurrentUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      setState(() {
        _currentUser = currentUser;
      });
      await fetchAndDisplayUserData(_currentUser.email!);
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout Confirmation"),
          content: Text("Are you sure you want to logout?", style: AppFonts.text16(AppColor.black),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text(
                "Cancel",
                style: AppFonts.text16(AppColor.black),
              ),
            ),
            TextButton(
              onPressed: () {
                _signOut();
                Navigator.of(context).pop(); 
              },
              child: Text(
                "Yes",
                style: AppFonts.text16Bold(AppColor.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchAndDisplayUserData(String email) async {
    try {
      QuerySnapshot userDataSnapshot = await _firestore
          .collection('usersAccount')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userDataSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData = (userDataSnapshot.docs.first.data() as Map<String, dynamic>);
        setState(() {
          _userProfileData = userData;
          _isLoading = false;
        });
      } else {
        print('User data does not exist.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _handleDeletePressed() async {
    try {
      String? userEmail = _currentUser.email;
      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection('usersAccount')
          .where('email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        DocumentReference userDocRef = userQuerySnapshot.docs.first.reference;
        await userDocRef.delete();
        await _currentUser.delete();
        await _auth.signOut();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );

      } else {
        print('User document not found.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account. User not found.'),
          ),
        );
      }
    } catch (e) {
      print('Error deleting user account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete account. Please try again later.'),
        ),
      );
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Deletion Confirmation"),
          content: Text("Are you sure you want to delete your account? You will no longer be able to use this app, and your account and data will be lost. The admin will be notified via email.",
            style: AppFonts.text16(AppColor.black),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: AppFonts.text16(AppColor.black),
              ),
            ),
            TextButton(
              onPressed: () {
                _handleDeletePressed();
                Navigator.of(context).pop();
              },
              child: Text(
                "Yes",
                style: AppFonts.text16Bold(AppColor.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: _isLoading ? _buildLoadingScreen() : _buildProfileScreen(),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(), 
    );
  }

  Widget _buildProfileScreen() {
    return AnimatedBackground(
      behaviour: RandomParticleBehaviour(
        options: ParticleOptions(
          spawnMaxRadius: 20,
          spawnMaxSpeed: 6,
          particleCount: 40,
          spawnMinSpeed: 6,
          minOpacity: 0.3,
          spawnOpacity: 0.4,
          baseColor: AppColor.deepGreen1,
          image: Image(
            image: AssetImage("assets/img/TF-logo.png"),
          ),
        ),
      ),
      vsync: this,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  color: AppColor.color5,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60.0),
                    bottomRight: Radius.circular(60.0),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.16 - 100,
            left: (MediaQuery.of(context).size.width - 320) / 2,
            child: Column(
              children: [
                _profileImage(),
                _userDataView(),
                SizedBox(height: 30),
                _buildProfileMethods(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMethods() {
    final double containerWidth = MediaQuery.of(context).size.width * 0.8; 
    final double containerHeight = 60.0; 

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...profileMethods.map((profileM) {
            String method = profileM['method'];
            IconData icon = profileM['icon'] ?? Icons.help_outline; 
            bool isSelected = method == selectedMethod;
            return GestureDetector(
              onTap: () async {
                setState(() {
                  selectedMethod = method;
                });
                if (method == 'Logout') {
                  _showLogoutConfirmationDialog();
                } else if (method == 'Request Deletion') {
                  _showDeleteConfirmationDialog();
                } else if (method == 'Edit Profile') {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(userID: _currentUser.uid),
                    ),
                  );
                  if (result == true) {
                    await fetchAndDisplayUserData(_currentUser.email!);
                  }
                }
              },
              child: Container(
                width: containerWidth,
                height: containerHeight,
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.color4 : AppColor.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: isSelected ? AppColor.green : Colors.grey.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 15,),
                        Icon(
                          icon,
                          size: 30,
                          color: isSelected ? AppColor.black : AppColor.black.withOpacity(0.6), 
                        ),
                        SizedBox(width: 10),
                        Text(
                          method,
                          style: isSelected ? AppFonts.text18Bold(AppColor.black) : AppFonts.text18(AppColor.black.withOpacity(0.6)), 
                        ),
                      ],
                    ),
                    Radio<String>(
                      value: method,
                      groupValue: selectedMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _profileImage() {
    String? photoUrl = _userProfileData?['picture'];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
          child: Stack(
            children: [
              Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5), 
                      spreadRadius: 2, 
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: photoUrl != null && photoUrl.isNotEmpty
                        ? NetworkImage(photoUrl) 
                        : AssetImage('assets/img/userProfile.jpeg') as ImageProvider,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.bgGreen1,
                  ),
                  padding: EdgeInsets.all(4.0),
                  child: IconButton(
                    icon: Icon(Icons.edit, color: AppColor.darkgrey, size: 28,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditPicture()),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            _userProfileData?['picture'] = value;
                          });
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _userDataView() {
    if (_userProfileData != null) {
      String firstName = _userProfileData!['firstName'] ?? '';
      String lastName = _userProfileData!['lastName'] ?? '';
      String email = _userProfileData!['email'] ?? '';
      String phoneNumber = _userProfileData!['phoneNumber'] ?? '';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.0),
          Text(
            '$firstName $lastName',
            style: AppFonts.text24(AppColor.white),
          ),
          SizedBox(height: 5.0),
          Text(
            '$phoneNumber',
            style: AppFonts.text18(AppColor.white),
          ),
          SizedBox(height: 5.0),
          Text(
            '$email',
            style: AppFonts.text18(AppColor.white),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
