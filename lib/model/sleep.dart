import 'package:flutter/material.dart';
import '/model/setup.dart';

class SleepImprovement extends StatefulWidget {
  @override
  _SleepImprovementState createState() => _SleepImprovementState();
}

class _SleepImprovementState extends State<SleepImprovement> {
  String? _selectedOption;
  int _currentStep = 6;

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
                  'Anything you want to improve about your sleep?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                child: Wrap(
                  spacing: 10,
                  children: [
                    _buildOption('Wake up less often', Icons.bed, Colors.blue),
                    _buildOption(
                        'Fall asleep faster', Icons.timer, Colors.green),
                    _buildOption(
                        'Improve sleep quality', Icons.star, Colors.yellow),
                    _buildOption('Establish a consistent bedtime routine',
                        Icons.nightlight_round, Colors.orange),
                    _buildOption('Reduce stress before bed',
                        Icons.airline_seat_recline_extra, Colors.purple),
                    _buildOption('Other', Icons.more_horiz, Colors.grey),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedOption != null
                    ? () {
                        // Navigate to next question screen with fade transition
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder: (_, __, ___) =>
                                SetupAnimationScreen(), // Replace with the next screen
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(
                                      1.0, 0.0), // Start offscreen to the right
                                  end: Offset
                                      .zero, // Slide to the center of the screen
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
        ));
  }

  Widget _buildOption(String option, IconData icon, Color iconColor) {
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
        label: Text(option),
        selected: _selectedOption == option,
        onSelected: (selected) {
          setState(() {
            _selectedOption = selected ? option : null;
          });
        },
      ),
    );
  }
}
