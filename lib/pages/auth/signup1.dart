import 'dart:convert';
import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../common/appColors.dart';
import '../../common/appFonts.dart';
import '../../controller/navbar.dart';
import '../../dataModel/userModel.dart';
import 'login.dart';
import 'package:uuid/uuid.dart';

class Signup1 extends StatefulWidget {
  const Signup1({Key? key}) : super(key: key);

  @override
  State<Signup1> createState() => _Signup1State();
}

class _Signup1State extends State<Signup1> with TickerProviderStateMixin {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _passwordVisible = false;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _isFirstNameValid = true;
  bool _isPhoneNumberValid = true;
  String? _phoneNumber;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _validateFirstName(String value) {
    return value.isNotEmpty && value == value.toLowerCase();
  }

  bool _validateEmail(String email) {
    final RegExp googleEmail =
    RegExp(r'^[\w.+-]+@gmail\.com$', caseSensitive: false);
    final RegExp utemEmail =
    RegExp(r'^[\w.+-]+@(utem\.edu\.my|student\.utem\.edu\.my)$', caseSensitive: false);
    final RegExp outlookEmail =
    RegExp(r'^[\w.+-]+@outlook\.com$', caseSensitive: false);
    final RegExp yahooEmail =
    RegExp(r'^[\w.+-]+@yahoo\.com$', caseSensitive: false);
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

  bool _validatePassword(String password) {
    if (password.length < 6) {
      return false;
    }
    bool hasUpperCase = false;
    int upperCaseCount = 0;
    for (int i = 0; i < password.length; i++) {
      if (password[i] == password[i].toUpperCase() && password[i] != password[i].toLowerCase()) {
        hasUpperCase = true;
        upperCaseCount++;
      }
    }
    bool hasLowerCase = false;
    int lowerCaseCount = 0;
    for (int i = 0; i < password.length; i++) {
      if (password[i] == password[i].toLowerCase() && password[i] != password[i].toUpperCase()) {
        hasLowerCase = true;
        lowerCaseCount++;
      }
    }
    bool hasSpecialChar = false;
    String specialChars = r'^ !@#$%^&*()_+{}|:<>?-=[]\;\';
    for (int i = 0; i < password.length; i++) {
      if (specialChars.contains(password[i])) {
        hasSpecialChar = true;
        break;
      }
    }
    return hasUpperCase && hasLowerCase && hasSpecialChar && upperCaseCount >= 1 && lowerCaseCount >= 1;
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes); 
    return digest.toString(); 
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

  void _onSignupPressed() async {
    setState(() {
      _isFirstNameValid = _firstNameController.text.isNotEmpty;
      _isPhoneNumberValid = _phoneNumber != null && _phoneNumber!.isNotEmpty;
    });

    if (_isFirstNameValid && _isPhoneNumberValid) {
      try {
        String userID = Uuid().v4();
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();

        UserModel userModel = UserModel(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneNumber!,
          email: email,
          password: password, 
          userID: userID,
          picture: '',
        );

        Map<String, dynamic> userProfileData = {
          'firstName': userModel.firstName,
          'lastName': userModel.lastName,
          'phoneNumber': userModel.phoneNumber,
          'userID': userModel.userID,
          'picture': userModel.picture,
          'email': userModel.email,
          'password': hashPassword(userModel.password), 
        };

        await _firestore.collection('usersAccount').doc(userModel.userID).set(userProfileData);
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ButtomNavBar(initialIndex: 0,)),
        );
      } catch (e) {
        print('Error creating user account or saving data to Firestore: $e');
        _showDialog('Error: $e');
      }
    } else {
      _showDialog('Please fill in all required fields.');
    }
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                            const SizedBox(width: 16), 
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
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
                                    const SizedBox(height: 40),
                                    Text(
                                      "Fill in your information",
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
                                              Expanded(
                                                child: TextField(
                                                  controller: _firstNameController,
                                                  decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(32),
                                                      borderSide: BorderSide(
                                                        color: _isFirstNameValid ? AppColor.green : Colors.red,
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: _isFirstNameValid ? AppColor.green: Colors.red,
                                                      ),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    hintText: "First name",
                                                    hintStyle: TextStyle(color: Colors.grey),
                                                    prefixIcon: Icon(Icons.person),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal:  15),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _isFirstNameValid = _validateFirstName(value);
                                                    });
                                                  },
                                                  keyboardType: TextInputType.text,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.singleLineFormatter
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (!_isFirstNameValid)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10.0,
                                                top: 5.0,
                                              ),
                                              child: Text(
                                                'First name cannot be empty',
                                                style: AppFonts.text14(AppColor.red),
                                              ),
                                            ),
                                          const SizedBox(height: 15),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: _lastNameController,
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
                                                    hintText: "Last name (optional)",
                                                    hintStyle: TextStyle(color: Colors.grey),
                                                    prefixIcon: Icon(Icons.person),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal:  15),
                                                  ),
                                                  onChanged: (value) {
                                                  },
                                                  keyboardType: TextInputType.text,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.singleLineFormatter
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),

                                          Container(
                                            padding: EdgeInsets.only(left: 1.0),
                                            width: MediaQuery.of(context).size.width - 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(32),
                                              border: Border.all(
                                                color: _isPhoneNumberValid ? AppColor.green : Colors.red, 
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: InternationalPhoneNumberInput(
                                                    onInputChanged: (PhoneNumber number) {
                                                      setState(() {
                                                        _phoneNumber = number.phoneNumber;
                                                        _isPhoneNumberValid = _phoneNumber != null && _phoneNumber!.isNotEmpty;
                                                      });
                                                    },
                                                    isEnabled: true,
                                                    autoValidateMode: AutovalidateMode.disabled,
                                                    selectorConfig: SelectorConfig(
                                                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                                    ),
                                                    ignoreBlank: false,
                                                    selectorTextStyle: TextStyle(color: Colors.black),
                                                    initialValue: PhoneNumber(isoCode: 'MY'), 
                                                    countries: ['AD', 'AE', 'AF', 'AG', 'AI', 'AL', 'AM', 'AO', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AW', 'AX', 'AZ', 'BA', 'BB', 'BD', 'BE', 'BF', 'BG', 'BH', 'BI', 'BJ', 'BL', 'BM', 'BN', 'BO', 'BQ', 'BR', 'BS', 'BT', 'BV', 'BW', 'BY', 'BZ', 'CA', 'CC', 'CD', 'CF', 'CG', 'CH', 'CI', 'CK', 'CL', 'CM', 'CN', 'CO', 'CR', 'CU', 'CV', 'CW', 'CX', 'CY', 'CZ', 'DE', 'DJ', 'DK', 'DM', 'DO', 'DZ', 'EC', 'EE', 'EG', 'EH', 'ER', 'ES', 'ET', 'FI', 'FJ', 'FK', 'FM', 'FO', 'FR', 'GA', 'GB', 'GD', 'GE', 'GF', 'GG', 'GH', 'GI', 'GL', 'GM', 'GN', 'GP', 'GQ', 'GR', 'GS', 'GT', 'GU', 'GW', 'GY', 'HK', 'HM', 'HN', 'HR', 'HT', 'HU', 'ID', 'IE', 'IL', 'IM', 'IN', 'IO', 'IQ', 'IR', 'IS', 'IT', 'JE', 'JM', 'JO', 'JP', 'KE', 'KG', 'KH', 'KI', 'KM', 'KN', 'KP', 'KR', 'KW', 'KY', 'KZ', 'LA', 'LB', 'LC', 'LI', 'LK', 'LR', 'LS', 'LT', 'LU', 'LV', 'LY', 'MA', 'MC', 'MD', 'ME', 'MF', 'MG', 'MH', 'MK', 'ML', 'MM', 'MN', 'MO', 'MP', 'MQ', 'MR', 'MS', 'MT', 'MU', 'MV', 'MW', 'MX', 'MY', 'MZ', 'NA', 'NC', 'NE', 'NF', 'NG', 'NI', 'NL', 'NO', 'NP', 'NR', 'NU', 'NZ', 'OM', 'PA', 'PE', 'PF', 'PG', 'PH', 'PK', 'PL', 'PM', 'PN', 'PR', 'PS', 'PT', 'PW', 'PY', 'QA', 'RE', 'RO', 'RS', 'RU', 'RW', 'SA', 'SB', 'SC', 'SD', 'SE', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL', 'SM', 'SN', 'SO', 'SR', 'SS', 'ST', 'SV', 'SX', 'SY', 'SZ', 'TC', 'TD', 'TF', 'TG', 'TH', 'TJ', 'TK', 'TL', 'TM', 'TN', 'TO', 'TR', 'TT', 'TV', 'TW', 'TZ', 'UA', 'UG', 'UM', 'US', 'UY', 'UZ', 'VA', 'VC', 'VE', 'VG', 'VI', 'VN', 'VU', 'WF', 'WS', 'YE', 'YT', 'ZA', 'ZM', 'ZW'], // List of supported countries
                                                    formatInput: true,
                                                    keyboardType: TextInputType.phone, 
                                                    inputDecoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Phone number',
                                                      hintStyle: TextStyle(color: Colors.grey),
                                                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal:  15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!_isPhoneNumberValid)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10.0,
                                                top: 5.0,
                                              ),
                                              child: Text(
                                                'Phone number cannot be empty',
                                                style: AppFonts.text14(AppColor.red),
                                              ),
                                            ),

                                          const SizedBox(height: 15),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: _emailController,
                                                  decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(32),
                                                      borderSide: BorderSide(
                                                        color: _isEmailValid
                                                            ? AppColor.green
                                                            : Colors
                                                            .red, 
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: _isEmailValid
                                                            ? AppColor.green
                                                            : Colors
                                                            .red, 
                                                      ),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    hintText: "Email",
                                                    hintStyle: TextStyle(color: Colors.grey),
                                                    prefixIcon: Icon(Icons.email),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal:  15),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _isEmailValid = _validateEmail(value);
                                                    });
                                                  },
                                                  keyboardType: TextInputType.emailAddress,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .singleLineFormatter
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (!_isEmailValid)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                  top: 5.0),
                                              child: Text(
                                                'Invalid email format',
                                                style: AppFonts.text14(AppColor.red),
                                              ),
                                            ),

                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: _passwordController,
                                                  decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(32),
                                                      borderSide: BorderSide(
                                                        color: _isPasswordValid ? AppColor.green : Colors.red,
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: _isPasswordValid ? AppColor.green : Colors.red,
                                                      ),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    hintText: "Password",
                                                    hintStyle: TextStyle(color: Colors.grey),
                                                    prefixIcon: Icon(Icons.lock),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal:  15),
                                                    suffixIcon: GestureDetector(
                                                      onTap: _togglePasswordVisibility,
                                                      child: Icon(
                                                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                                      ),
                                                    ),
                                                  ),
                                                  obscureText: !_passwordVisible,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _isPasswordValid = _validatePassword(value);
                                                    });
                                                  },
                                                  keyboardType: TextInputType.visiblePassword,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.singleLineFormatter
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (!_isPasswordValid)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                                              child: Text(
                                                'Password must be at least 6 characters with 1 uppercase, 1 lowercase, and 1 special character.',
                                                style: AppFonts.text14(AppColor.red),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColor.green,
                                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 114),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(44),
                                              side: BorderSide(color: AppColor.green, width: 2),
                                            ),
                                            elevation: 5,
                                          ),
                                          onPressed: _onSignupPressed,
                                          child: Text(
                                            "Signup",
                                            style: AppFonts.text16Bold(AppColor.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsets.only(right: 40),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Already have an account?",
                                            style: AppFonts.text16(AppColor.white),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => Login()),
                                              );
                                            },
                                            child: Text(
                                              " Login",
                                              style: AppFonts.text16Bold(AppColor.bgGreen),
                                            ),
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
            ),
          ),
        ],
      ),
    );
  }
}
