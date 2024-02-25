import 'package:flutter/material.dart';
import '/main.dart';
import '/model/partner_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/model/signup.dart';
import '../apis/user_api.dart';
import 'package:email_validator/email_validator.dart';



class StartUp extends StatefulWidget {
  StartUp({super.key});

  @override
  State<StartUp> createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  bool _isGradientAnimated = false;

  @override
  void initState() {
    super.initState();
    // Trigger animation after the widget has been built
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isGradientAnimated = true;
      });
    });
  }

  Future<void> _sendDataToServer() async {
    try {
      
      bool result = await ApiService.getUser(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (result) {
        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
      } else {
        _showEmailWarningDialog();
        // Navigator.pushNamed(context, '/userData');
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

  void _showEmailWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('Enter valid credentials'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
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
      backgroundColor: Colors.transparent,
      
      body: SizedBox( 
        height: mediaQuery.height,
        child: AnimatedContainer(
        duration: Duration(seconds: 3), // Duration for gradient animation
        decoration: BoxDecoration(
          gradient: _isGradientAnimated
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFCE5E7), Color(0xFFC6E2FF)], // Gradient colors
                )
              : null,
        ),
        child: SingleChildScrollView( 
        child: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(25.0,190.0, 25.0, 5.0),
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
                          fontWeight: FontWeight.bold
                        ),
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
                child: Text('Enter your email to start with Glow                ',
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
          const SizedBox(height: 6),
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
                if (_emailController.text.isEmpty || !Validate(_emailController.text ) || _passwordController.text.isEmpty) {
                  _showEmailWarningDialog();
                }
                else {
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
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                    )
                  : Text('Sign In'),
            ),
          )),
          Center(
            child: Container(
              child: TextButton(
                onPressed: (){
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>(SignUp())),
                        );
                },
                child: Text("New User! Create Account"),
              ),
            ),
          ),
          Center(
            child: Container(
              child: TextButton(
                onPressed: (){
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>(PartnerLogin())),
                        );
                },
                child: Text("Partner Log In"),
              ),
            ),
          ),
        ],
      ),
      ),
      ),
      )
    );
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
