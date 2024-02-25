import 'package:flutter/material.dart';
import '/model/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _discomfortOption;
  String? _cycleOption;
  String? _disorderOption;
  String? _sleepImprovementOption;

  // Options for discomfort
  List<String> discomfortOptions = [
    'Painful Menstrual cramps',
    'Unusual Discharge',
     'Others',
    'Heavy Menstrual flow',
      "Nothing, I'm totally fine",
  ];

   List<String> cycleOptions = [
    'My cycle is regular',
    'My cycle is irregular',
    'IDK',
    'Not sure',
  ];

  // Options for disorder
  List<String> disorderOptions = [
    'I don\'t know',
    'Yes',
    'No',
    'No, But i used to',
  ];

  // Options for sleep improvement
  List<String> sleepImprovementOptions = [
    'Wake up less often',
    'Fall asleep faster',
    'Improve sleep quality',
    'Consistent bedtime routine',
    'Reduce stress before bed',
  ];

  @override
  void initState() {
    super.initState();
    _loadOptions(); // Load saved options when widget initializes
  }

  _loadOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cycleOption = prefs.getString("selectedMethod");
      _discomfortOption = prefs.getString('discomfortSelectedMethod');
      _disorderOption = prefs.getString('disorderSelectedMethod');
      _sleepImprovementOption =
          prefs.getString('sleepImprovementSelectedOption');
    });
  }

  _updateOptions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("selectedMethod", _cycleOption!);
    prefs.setString('discomfortSelectedMethod', _discomfortOption!);
    prefs.setString('disorderSelectedMethod', _disorderOption!);
    prefs.setString('sleepImprovementSelectedOption', _sleepImprovementOption!);
    // Show a message or perform any action indicating that options are updated
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Options updated successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
       
      ),
      body: Container(
        padding:EdgeInsets.fromLTRB(20, 150, 20, 0),
        height: mediaQuery.height,
        width: mediaQuery.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCE5E7), Color(0xFFC6E2FF)], // Gradient colors
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                'Cycle Regular',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
                DropdownButton<String>(
                value: _cycleOption,
                onChanged: (newValue) {
                  setState(() {
                     _cycleOption= newValue;
                  });
                },
                items: cycleOptions.map((option) {
                  return DropdownMenuItem(
                    child: Text(option),
                    value: option,
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Text(
                'Discomfort Option:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _discomfortOption,
                onChanged: (newValue) {
                  setState(() {
                    _discomfortOption = newValue;
                  });
                },
                items: discomfortOptions.map((option) {
                  return DropdownMenuItem(
                    child: Text(option),
                    value: option,
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Text(
                'Disorder Option:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _disorderOption,
                onChanged: (newValue) {
                  setState(() {
                    _disorderOption = newValue;
                  });
                },
                items: disorderOptions.map((option) {
                  return DropdownMenuItem(
                    child: Text(option),
                    value: option,
                  );
                }).toList(),
              ),
             SizedBox(height: 30),
              Text(
                'Sleep Improvement Option:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _sleepImprovementOption,
                onChanged: (newValue) {
                  setState(() {
                    _sleepImprovementOption = newValue;
                  });
                },
                items: sleepImprovementOptions.map((option) {
                  return DropdownMenuItem(
                    child: Text(option),
                    value: option,
                  );
                }).toList(),
              ),
             SizedBox(height: 30),
              ElevatedButton(
                onPressed: _updateOptions,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
