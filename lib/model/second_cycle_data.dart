import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:ionicons/ionicons.dart';
import '/model/cycle_regualar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondCycleData extends StatefulWidget {
  const SecondCycleData({super.key});

  @override
  State<SecondCycleData> createState() => _SecondCycleDataState();
}

class _SecondCycleDataState extends State<SecondCycleData> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _cycleRangeController = TextEditingController();
  final TextEditingController _cycleLengthController = TextEditingController();
  final TextEditingController _periodRangeController = TextEditingController();
  final TextEditingController _periodLengthController = TextEditingController();
  PlatformFile? file;
  bool isLoading = false;
  DateTime? dob;
  int _currentStep = 2;
  // Future<void> sendDataToServer() async {
  //   final SharedPreferences sp = await SharedPreferences.getInstance();
  //   String? email = sp.getString('email');
  //    String? password = sp.getString('password');
  //   String? name = sp.getString('name');
  //   String? lastname = sp.getString('lastname');
  //   String? dob = sp.getString('dob');
  //   String? phone = sp.getString('phone');
  //   try {
  //     bool result = await ApiService.sendDataToServer(
  //         email: email,
  //         name: name,
  //         password:password,
  //         lastName: lastname,
  //         dob: dob,
  //         phone: phone,
  //         cycleStartDate: cycleSelectedDates.start,
  //         cycleEndDate: cycleSelectedDates.end,
  //         cycleRange: cycleLength,
  //         periodStartDate: periodSelectedDates.start,
  //         periodEndDate: periodSelectedDates.end,
  //         periodRange: periodLength);

  //     if (result) {
  //       Navigator.pushNamed(context, '/home');
  //     } else {
  //       // Handle error cases based on the result value
  //       print('Error else: $result');
  //     }
  //   } catch (error) {
  //     print('Error carch: $error');
  //   }
  // }

  DateTimeRange cycleSelectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  Duration? cycleLength;

  DateTimeRange periodSelectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  Duration? periodLength;

  Future<void> _showWarningDialog(String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Warning"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cycleRangeController.dispose();
    _cycleLengthController.dispose();
    _periodLengthController.dispose();
    _periodRangeController.dispose();
    super.dispose();
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFCE5E7), Color(0xFFC6E2FF)], // Gradient colors
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Center(
                  //   child: Padding(
                  //     padding: EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                  //     child: Container(
                  //       height: 120,
                  //       width: 150,
                  //       decoration: const BoxDecoration(
                  //         color: Color(0xFFFFB4A9),
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: const Stack(
                  //         children: [
                  //           Center(
                  //             child: Text(
                  //               "Maya",
                  //               style: TextStyle(
                  //                 color: Color(0xFFFFF5F5),
                  //               ),
                  //             ),
                  //           ),
                  //           Positioned(
                  //             top: 25,
                  //             right: 95,
                  //             child: Icon(
                  //               Icons.favorite,
                  //               color: Color(0xFFFFF5F5),
                  //               size: 24,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(50, 5, 50, 0),
                  //   child: Text("Almost there.!",
                  //       style: GoogleFonts.nunitoSans(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: mediaQuery.width * .06)),
                  // ),
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(50, , 50, 0),
                  //   child: Text(
                  //     "Let's add a few details about your cycle to get started.!",
                  //     style: GoogleFonts.nunitoSans(
                  //         fontWeight: FontWeight.w600, color: Colors.black38),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: mediaQuery.height * .03,
                  // ),
                  SizedBox(
                    height: mediaQuery.height * .06,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 100, 0, 0),
                    child: Text(
                      'What\'s your Second last month cycle info',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                  // SizedBox(height: 20),
                  Form(
                      key: _key,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(50, 5, 50, 0),
                        height: mediaQuery.height * .55,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: mediaQuery.height * 0.09,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter cycle range";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: _cycleRangeController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  15, 0, 0, 0),
                                          // prefixIcon: Icon(
                                          //   Ionicons.calendar_outline,
                                          // ),
                                          hintText: "Cycle Range",
                                          hintStyle: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black38),
                                          fillColor: Color(0xFFFFF5F5),
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide.none)),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit_calendar_outlined),
                                    onPressed: () async {
                                      final SharedPreferences sp =
                                          await SharedPreferences.getInstance();
                                      final DateTimeRange? dateTimeRange =
                                          await showDateRangePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(3000),
                                      );
                                      if (dateTimeRange != null) {
                                        setState(() {
                                          cycleSelectedDates = dateTimeRange;
                                          _cycleRangeController.text =
                                              '${DateFormat.MMMd().format(dateTimeRange.start)} - ${DateFormat.MMMd().format(dateTimeRange.end)}';

                                          // Calculate and set the cycle length
                                          cycleLength = dateTimeRange.end
                                              .difference(dateTimeRange.start);
                                          int cycleLengthInDays =
                                              cycleLength!.inDays;

                                          sp.setInt(
                                              "cyclerange", cycleLengthInDays);
                                          sp.setBool("date", false);
                                          _cycleLengthController.text =
                                              '${cycleLength!.inDays + 1} days';
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter cycle length";
                                } else {
                                  return null;
                                }
                              },
                              controller: _cycleLengthController,
                              maxLines: null,
                              style: GoogleFonts.nunitoSans(),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                prefixIcon: Icon(
                                  Ionicons.accessibility_outline,
                                ),
                                hintText: "Cycle Length",
                                hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38,
                                ),
                                fillColor: Color(0xFFFFF5F5),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: mediaQuery.height * 0.09,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter period range";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: _periodRangeController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  15, 0, 0, 0),
                                          // prefixIcon: Icon(
                                          //   Ionicons.calendar_outline,
                                          // ),
                                          hintText: "Period Range",
                                          hintStyle: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black38),
                                          fillColor: Color(0xFFFFF5F5),
                                          filled: true,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide.none)),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit_calendar_outlined),
                                    onPressed: () async {
                                      final SharedPreferences sp =
                                          await SharedPreferences.getInstance();
                                      final DateTimeRange? dateTimeRange =
                                          await showDateRangePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(3000),
                                      );
                                      if (dateTimeRange != null) {
                                        setState(() {
                                          periodSelectedDates = dateTimeRange;
                                          _periodRangeController.text =
                                              '${DateFormat.MMMd().format(dateTimeRange.start)} - ${DateFormat.MMMd().format(dateTimeRange.end)}';

                                          // Calculate and set the cycle length
                                          periodLength = dateTimeRange.end
                                              .difference(dateTimeRange.start);
                                          int periodLengthInDays =
                                              periodLength!.inDays;

                                          sp.setInt("periodrange",
                                              periodLengthInDays);
                                          _periodLengthController.text =
                                              '${periodLength!.inDays + 1} days';
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter period length";
                                } else {
                                  return null;
                                }
                              },
                              controller: _periodLengthController,
                              maxLines: null,
                              style: GoogleFonts.nunitoSans(),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                prefixIcon: Icon(
                                  Ionicons.accessibility_outline,
                                ),
                                hintText: "Period Length",
                                hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38,
                                ),
                                fillColor: Color(0xFFFFF5F5),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_key.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 500),
                                        pageBuilder: (_, __, ___) =>
                                            CycleRegular(), // Replace NextScreen with your desired screen
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(1.0,
                                                  0.0), // Start offscreen to the right
                                              end: Offset
                                                  .zero, // Slide to the center of the screen
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                    // await sendDataToServer();
                                    // final SharedPreferences sp =
                                    //     await SharedPreferences.getInstance();
                                    // sp.setBool('isLogin', true);
                                    // sp.setBool('partner', false);
                                  } else {
                                    // Validation failed
                                    _showWarningDialog(
                                        "Please fill in all the fields.");
                                  }
                                },
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            horizontal: mediaQuery.width * .11,
                                            vertical:
                                                mediaQuery.height * .015)),
                                    backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFFFB4A9),
                                    )),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        strokeWidth: 1,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        "Next",
                                        style: GoogleFonts.nunitoSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: mediaQuery.width * .04),
                                      ))
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
