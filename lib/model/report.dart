import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/model/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  late String name = '';
  late int cycleRange = 0;
  late int periodRange = 0;

  @override
  void initState() {
    getPref();
    setState(() {});
    super.initState();
  }

// Future<void> generatePdfAndShare(BuildContext context) async {
//   final url = 'http://192.168.43.192:5000/generate_report';
//   final data = {
//     'name': 'John Doe',
//     'period_range': 5,
//     'cycle_range': 28,
//     'symptoms': ['Symptom 1', 'Symptom 2'],
//     'notes': ['Note 1', 'Note 2'],
//     'sleep': ['Sleep 1', 'Sleep 2'],
//   };

//   final response = await http.post(
//     Uri.parse(url),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode(data),
//   );

//   if (response.statusCode == 200) {
//     final dir = await getExternalStorageDirectory();
//     final file = File('${dir!.path}/report.pdf');
//     await file.writeAsBytes(response.bodyBytes);

//     // Share PDF file
//     Share.shareFiles([file.path], text: 'Report PDF');
//   } else {
//     // Handle error
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Failed to generate PDF: ${response.statusCode}'),
//       ),
//     );
//   }
// }
  Future<List<String>> fetchSymptoms() async {
    final response = await http
        .get(Uri.parse('http://192.168.43.192:5000//report_symptoms'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load symptoms');
    }
  }

  Future<List<String>> fetchNotes() async {
    final response =
        await http.get(Uri.parse('http://192.168.43.192:5000/report_notes'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<List<String>> fetchSleep() async {
    final response =
        await http.get(Uri.parse('http://192.168.43.192:5000/report_sleep'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<void> getPref() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      name = sp.getString("name")!;
      cycleRange = sp.getInt("cycleLength") ?? 0;
      periodRange = sp.getInt("periodrange") ?? 0;
    });

    print(name);
  }

    Widget _buildTextContainer() {
    if (cycleRange > 32 || cycleRange < 22) {
      return const Text(
        'Abnormal',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 223, 67, 39),
        ),
      );
    } else {
      return const Text(
        'Normal',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 235, 176, 14),
        ),
      );
    }
  }

  Widget _buildPeriodTextContainer() {
    if (periodRange > 9 || periodRange < 2) {
      return const Text(
        'Abnormal',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 22, 167, 8),
        ),
      );
    } else {
      return const Text(
        'Normal',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 22, 167, 8),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
      
      ),
      body: Container(
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
          child: Column(
            children: [
              const SizedBox(height: 20.0), // Add space at the top
              Container(
                margin: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report for ${DateFormat.MMMM().format(DateTime.now())}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Period Length:',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              // Replace 'periodLength' with the actual period length value
                              '$periodRange days',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cycle Length:',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              // Replace 'cycleLength' with the actual cycle length value
                              '$cycleRange days',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ovulation Phase Length:',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              // Replace 'ovulationLength' with the actual ovulation phase length value
                              '${(cycleRange - periodRange) ~/ 3} days',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0), 
              Container(
                width: mediaQuery.width,
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),

                child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                     Text(
                      'Cycle Nature',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                     _buildTextContainer(),
                      const SizedBox(height: 10.0),
                     Text("As your cycle length is $cycleRange",
                    style: TextStyle(   fontStyle: FontStyle.italic,
                                color: Colors.grey,),
                     )
                     ]

                    
                       
                 
                ),
              ),// Add space between containers

        
              Container(
                width: mediaQuery.width,
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),

                child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                     Text(
                      'Period Nature',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                     _buildPeriodTextContainer(),
                      const SizedBox(height: 10.0),
                     Text("As your period length is $periodRange",
                    style: TextStyle(   fontStyle: FontStyle.italic,
                                color: Colors.grey,),
                     )
                     ]

                    
                       
                 
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: mediaQuery.width,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Symptoms:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Adjust color as needed
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    FutureBuilder<List<String>>(
                      future: fetchSymptoms(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          );
                        } else {
                          if (snapshot.data!.isEmpty) {
                            return const Text(
                              'No symptoms recorded.',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: snapshot.data!.map((symptom) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    '- $symptom',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                width: mediaQuery.width,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Adjust color as needed
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    FutureBuilder<List<String>>(
                      future: fetchNotes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          );
                        } else {
                          if (snapshot.data!.isEmpty) {
                            return Text(
                              'No notes recorded.',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: snapshot.data!.map((note) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    '- $note',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                width: mediaQuery.width,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sleep:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Adjust color as needed
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    FutureBuilder<List<String>>(
                      future: fetchSleep(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          );
                        } else {
                          if (snapshot.data!.isEmpty) {
                            return Text(
                              'No sleep recorded.',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: snapshot.data!.map((note) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    '- $note',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }
                      },
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
