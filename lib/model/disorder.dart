import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import '/model/sleep.dart';

class Disorder extends StatefulWidget {
  @override
  _DisorderState createState() => _DisorderState();
}

class _DisorderState extends State<Disorder> {
  String? _selectedMethod;
  int _currentStep = 5;

  @override
  void initState() {
    super.initState();
    _loadSelectedMethod(); // Load saved selection when widget initializes
  }

  _loadSelectedMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMethod = prefs.getString('disorderSelectedMethod');
    });
  }

  _saveSelectedMethod(String method) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('disorderSelectedMethod', method);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              7,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentStep == index + 1
                        ? Colors.blue // Change color based on active step
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // Handle skip button pressed
            },
            child: Text(
              'Skip',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Container(
        height: mediaQuery.height,
        width: mediaQuery.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCE5E7), Color(0xFFC6E2FF)], // Gradient colors
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(50, 50, 50, 20),
              child: Text(
                'Do you have any reproductive health disorders?',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
              child: Wrap(
                spacing: 10,
                children: [
                  _buildMethodOption(
                      'I don\'t know', Icons.help_outline, Colors.blue),
                  _buildMethodOption(
                      'Yes', Icons.error_outline, Colors.red),
                  _buildMethodOption(
                      'No', Icons.check_circle_outline, Colors.green),
                  _buildMethodOption(
                      'No, But i used to', Icons.history, Colors.orange),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedMethod != null
                  ? () {
                      _saveSelectedMethod(
                          _selectedMethod!); // Save selected method
                      // Navigate to next question screen with fade transition
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) =>
                              SleepImprovement(), // Replace NextScreen with your desired screen
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(
                                    1.0, 0.0), // Start offscreen to the right
                                end: Offset.zero, // Slide to the center of the screen
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    }
                  : null, // Disable the button if no option is selected
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodOption(
      String method, IconData icon, Color iconColor) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height * 0.08,
      child: ChoiceChip(
        avatar: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        label: Text(method),
        selected: _selectedMethod == method,
        onSelected: (selected) {
          setState(() {
            _selectedMethod = selected ? method : null;
          });
        },
      ),
    );
  }
}
