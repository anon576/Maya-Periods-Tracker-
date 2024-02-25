import 'package:flutter/material.dart';
import '/model/partner_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import '../apis/user_api.dart';
import 'package:email_validator/email_validator.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _sendDataToServer() async {
    try {
      bool result = await ApiService.getUser(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (result) {
        _showEmailWarningDialog("User Already Exist");
      } else {
        // _showEmailWarningDialog();
        Navigator.pushNamed(context, '/userData');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool Validate(String email) {
    bool _isValid = EmailValidator.validate(email);
    return _isValid;
  }

  bool isStrongPassword(String password) {
    // Minimum length check
    if (password.length < 8) {
      return false;
    }

    // Count uppercase letters
    int uppercaseCount = password.replaceAll(RegExp(r'[^A-Z]'), '').length;
    if (uppercaseCount < 2) {
      return false;
    }

    // Count numeric characters
    int numericCount = password.replaceAll(RegExp(r'[^0-9]'), '').length;
    if (numericCount < 3) {
      return false;
    }

    // Special character check
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return false;
    }

    return true;
  }

  void _showEmailWarningDialog(String val) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: Text(val),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        
        body: Container(
          height: mediaQuery.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFCE5E7), Color(0xFFC6E2FF)], // Gradient colors
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 120.0, 25.0, 5.0),
                    child: Container(
                      height: 170,
                      width: 170,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFB4A9),
                        shape: BoxShape.circle,
                      ),
                      child: const Stack(
                        children: [
                          Center(
                            child: Text(
                              "Glow",
                              style: TextStyle(
                                  color: Color(0xFFFFF5F5),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Positioned(
                            top: 25,
                            right: 110,
                            child: Icon(
                              Icons.favorite,
                              color: Color(0xFFFFF5F5),
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 7.0),
                    child: const Center(
                        child: Text(
                      'Welcome to Glow Tracker!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                  ),
                ),

                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 15.0),
                    child: const Center(
                      child: Text('Enter your email to start with Glow',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter email",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Password",
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _confirmpasswordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Confirm Password",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(70.0, 0.0, 70.0, 0.0),
                    child: const Text(
                        "Note : Password should contain 8 character with 2 Uppercase letter 3 Numeric character and 1 Special character"),
                  ),
                ),
                const SizedBox(height: 16),
                // const SizedBox(height: 6),
                Center(
                    child: Container(
                  padding: const EdgeInsets.fromLTRB(25.0, 1.0, 25.0, 1.0),
                  height: 60,
                  width: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1CAF2),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                    ),
                    onPressed: () async {
                      if (_emailController.text.isEmpty ||
                          !Validate(_emailController.text) ||
                          _passwordController.text.isEmpty ||
                          _confirmpasswordController.text.isEmpty) {
                        _showEmailWarningDialog("Enter Valid Credentials");
                      } else if (_passwordController.text !=
                          _confirmpasswordController.text) {
                        _showEmailWarningDialog(
                            "Confirm password does not match");
                      } else if (!isStrongPassword(_passwordController.text)) {
                        _showEmailWarningDialog(
                            "Password should contain 8 characters with 2 uppercase letters, 3 numeric characters, and 1 special character");
                      } else {
                        setState(() {
                          _isLoading = true;
                        });
                        final SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        sp.setString('email', _emailController.text);

                        sp.setString('password', _passwordController.text);
                        await _sendDataToServer();
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black54),
                          )
                        : const Text('Sign Up'),
                  ),
                )),
                Center(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => (StartUp())),
                        );
                      },
                      child: Text("Already registered? Log In"),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => (PartnerLogin())),
                        );
                      },
                      child: Text("Partner Log In"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

//   Future<String> sendMail({
//     required String from,
//     required List<String> recipients,
//     required String subject,
//     required String body,
//   }) async {
//     final smtpServer =
//         gmail(from, 'tkdcwqrlnkvxxirj'); // Replace with your email password

//     final message = Message()
//       ..from = Address(from)
//       ..recipients.addAll(recipients)
//       ..subject = subject
//       ..text = body;

//     try {
//       final sendReport = await send(message, smtpServer);
//       return 'Message sent: ${sendReport.toString()}';
//     } on MailerException catch (e) {
//       return 'Message not sent. ${e.toString()}';
//     }
//   }
//
}
