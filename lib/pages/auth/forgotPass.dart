import 'package:animated_background/animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../common/appColors.dart';
import '../../common/appFonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with TickerProviderStateMixin{
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _validateEmail(String email) {
    // Regular expressions for the accepted email formats
    final RegExp googleEmail = RegExp(r'^[\w.+-]+@gmail\.com$', caseSensitive: false);
    final RegExp utemEmail = RegExp(r'^[\w.+-]+@(utem\.edu\.my|student\.utem\.edu\.my)$', caseSensitive: false);
    final RegExp outlookEmail = RegExp(r'^[\w.+-]+@outlook\.com$', caseSensitive: false);
    final RegExp yahooEmail = RegExp(r'^[\w.+-]+@yahoo\.com$', caseSensitive: false);

    // Check if the email matches any of the accepted formats
    if (googleEmail.hasMatch(email) ||
        utemEmail.hasMatch(email) ||
        outlookEmail.hasMatch(email) ||
        yahooEmail.hasMatch(email)) {
      return true; // Email is valid
    } else {
      return false; // Email is invalid
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      Fluttertoast.showToast(
        msg: 'Password reset email sent. Check your inbox.',
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to send password reset email. Please try again later.',
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedBackground(
          behaviour: RandomParticleBehaviour(
            options: ParticleOptions(
              spawnMaxRadius: 20,
              spawnMaxSpeed: 6,
              particleCount: 40,
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
          child: Stack(
            children: [
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColor.black,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/img/TF-logo1.png',
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(width: 16), // Add some space to the right of the logo
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 160.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60),
                            Text(
                              "Enter your email",
                              style: AppFonts.text20(AppColor.white),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.only(left: 0.05),
                              width: MediaQuery.of(context).size.width - 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(32),
                                              borderSide: BorderSide(
                                                color: _isEmailValid ? AppColor.green : Colors.red,
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal:  15),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: _isEmailValid ? AppColor.green: Colors.red,
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            hintText: "Email",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            prefixIcon: Icon(Icons.email),
                                            fillColor: Colors.white,
                                            filled: true,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              _isEmailValid = _validateEmail(value);
                                            });
                                          },
                                          keyboardType: TextInputType.emailAddress,
                                          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!_isEmailValid)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                                      child: Text(
                                        'Invalid email format',
                                        style: AppFonts.text14(AppColor.red),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.only(left: 0.05),
                              width: MediaQuery.of(context).size.width - 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 22), // Ad
                                      ElevatedButton(
                                        onPressed: resetPassword,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.green,
                                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 74), // Adjust padding for size
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(44), // Adjust border radius
                                            side: BorderSide(color: AppColor.green, width: 2), // Border color and width
                                          ),
                                          elevation: 5, //shadow
                                        ),
                                        child: Text(
                                          "Reset Password",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white), // Text style
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
