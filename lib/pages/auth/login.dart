import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tf_pdpppms/common/appColors.dart';
import 'package:tf_pdpppms/common/appFonts.dart';
import 'package:tf_pdpppms/pages/auth/signup1.dart';
import '../../controller/navbar.dart';
import 'forgotPass.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  //text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailValid = true;
  bool _passwordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _validateEmail(String email) {
    final RegExp googleEmail = RegExp(r'^[\w.+-]+@gmail\.com$', caseSensitive: false);
    final RegExp utemEmail = RegExp(r'^[\w.+-]+@(utem\.edu\.my|student\.utem\.edu\.my)$', caseSensitive: false);
    final RegExp outlookEmail = RegExp(r'^[\w.+-]+@outlook\.com$', caseSensitive: false);
    final RegExp yahooEmail = RegExp(r'^[\w.+-]+@yahoo\.com$', caseSensitive: false);
    if (googleEmail.hasMatch(email) ||
        utemEmail.hasMatch(email) ||
        outlookEmail.hasMatch(email) ||
        yahooEmail.hasMatch(email)) {
      return true; 
    } else {
      return false; 
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColor.red,
                size: 28.0,
              ),
              SizedBox(width: 10.0),
              Text(
                'Error Occurred',
                style: AppFonts.text24(AppColor.red),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColor.deepGreen, 
                textStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: AppFonts.text16(AppColor.white),),
            ),
          ],
        );
      },
    );
  }

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usersAccount')
          .where('email', isEqualTo: _emailController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userEmail = querySnapshot.docs.first.get('email');
        if (user?.email == _emailController.text && _emailController.text == userEmail) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ButtomNavBar(initialIndex: 0)),
          );
        } else {
          _showDialog('You are not authorized to log in');
        }
      } else {
        _showDialog('You are not authorized to log in');
      }
    } catch (e) {
      _showDialog('Login failed. Please check your email or password');
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/img/TF-logo1.png',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Welcome to ",
                                  style: AppFonts.text32(AppColor.white),
                                ),
                                TextSpan(
                                  text: "EEPMS",
                                  style: AppFonts.text32(AppColor.bgGreen),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Measure NPD performance efficiently.",
                            style: AppFonts.text18(AppColor.white),
                          ),
                          const SizedBox(height: 60),
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
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: _isEmailValid ? AppColor.green : Colors.red,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          hintText: "Email",
                                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal:  15),
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
                                        inputFormatters: [
                                          FilteringTextInputFormatter.singleLineFormatter
                                        ],
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
                          const SizedBox(height: 15),
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
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(32),
                                            borderSide: BorderSide(
                                              color: AppColor.green,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: AppColor.green,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          hintText: "Password",
                                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal:  15),
                                          hintStyle: TextStyle(color: Colors.grey),
                                          prefixIcon: Icon(Icons.lock),
                                          fillColor: Colors.white,
                                          filled: true,
                                          suffixIcon: GestureDetector(
                                            onTap: _togglePasswordVisibility,
                                            child: Icon(
                                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                        obscureText: !_passwordVisible,
                                        keyboardType: TextInputType.visiblePassword,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.singleLineFormatter
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ForgotPassword(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: AppFonts.text14(AppColor.bgGreen1),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.green,
                                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 116),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(44),
                                          side: BorderSide(color: AppColor.green, width: 2),
                                        ),
                                        elevation: 5,
                                      ),
                                      onPressed: _login,
                                      child: Text(
                                        "Login",
                                        style: AppFonts.text16Bold(AppColor.white),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account?",
                                      style: AppFonts.text16(AppColor.white),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Signup1()),
                                        );
                                      },
                                      child: Text(
                                        " Signup",
                                        style: AppFonts.text16Bold(AppColor.bgGreen),
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
