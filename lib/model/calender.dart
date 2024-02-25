import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/apis/home_api.dart';
import '/model/custom_appbar.dart';
import '/model/menstruation.dart';
import '../apis/calender_api.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key}); // Corrected constructor syntax

  @override
  State<CalendarScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalendarScreen> {
  DateTime today = DateTime.now();
  late final TextEditingController dateController = TextEditingController();
  late String updateRange;
  late List<PickerDateRange> a = [];
  late Map<String, dynamic> card = {};
  Map<String, dynamic> cycles = {};
  Map<String, dynamic> periods = {};

  @override
  void initState() {
    setState(() {
      getDay();
      rangeOfDates();
      fetchData();
    });
    super.initState();
  }

  Future<Map<String, dynamic>> getDay() async {
    card = await HomeApi.getDate(today);
    setState(() {});
    return HomeApi.getDate(today);
  }

  Future<void> updatePeriod() async {
    try {
      bool result = await CalendarApi.updatePeriod(
          periodStartDate: selectedDates.start,
          periodEndDate: selectedDates.end,
          periodRange: updateRange);

      if (result) {
        setState(() {});
      }
    } catch (error) {
      print('Error carch: $error');
    }
  }

  Future<void> fetchData() async {
    try {
      Map<String, dynamic> data = await CalendarApi.getCurrentMonthData();

      if (data.containsKey('error')) {
        // Handle error case
        print('Error: ${data['error']}');
      } else {
        setState(() {
          cycles = data['cycles'];
          periods = data['periods'];
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {}

  void rangeOfDates() async {
    a = await CalendarApi.fetchPeriods();
  }

  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  // DateTime? _selectedDay;
  DateTime? d;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  void dispose() {
    // dateController.dispose(); // Dispose of the controller
    super.dispose();
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
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                  decoration: const BoxDecoration(
                      color: Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: FutureBuilder<List<PickerDateRange>>(
                    future: CalendarApi.fetchPeriods(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Handle case where there is no data
                        return Container(
                            // Your empty container widget
                            );
                      } else {
                        List<PickerDateRange> a = snapshot.data!;
                        return SfDateRangePicker(
                          headerHeight: 50,
                          showNavigationArrow: false,
                          allowViewNavigation: false,
                          enablePastDates: true,
                          onSelectionChanged: _onSelectionChanged,
                          selectionMode:
                              DateRangePickerSelectionMode.multiRange,
                          initialSelectedRanges: a,
                          headerStyle: const DateRangePickerHeaderStyle(
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          monthCellStyle: const DateRangePickerMonthCellStyle(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                                color: Colors.black),
                            todayTextStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                                color: Color.fromARGB(255, 3, 3, 3)),
                          ),
                          initialSelectedRange: PickerDateRange(
                              DateTime.now().subtract(const Duration(days: 1)),
                              DateTime.now().add(const Duration(days: 3))),
                          monthViewSettings:
                              const DateRangePickerMonthViewSettings(
                                  showTrailingAndLeadingDates: true,
                                  dayFormat: 'EEE',
                                  viewHeaderStyle:
                                      DateRangePickerViewHeaderStyle(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0)))),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    height: 60,
                    width: 380,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFFFFF5F5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                        const Expanded(
                          child: Text(
                            "Edit period dates",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_calendar_outlined),
                          onPressed: () async {
                            final DateTimeRange? dateTimeRange =
                                await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(3000));
                            if (dateTimeRange != null) {
                              setState(() {
                                selectedDates = dateTimeRange;
                                updateRange =
                                    '${DateFormat.MMMd().format(dateTimeRange.start)} - ${DateFormat.MMMd().format(dateTimeRange.end)}';
                                updatePeriod();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    height: 70,
                    width: 380,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(
                              10, 5, 0, 3), // Add padding for better visibility
                          child: const Text(
                            "Previous cycle length",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 150, 3),
                              child: Text(
                                "${cycles['range']} Days",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Spacer(), // Add this Spacer widget
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 3),
                              child: const Icon(
                                Icons.check_outlined,
                                color: Colors.green, // Set the color to green
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    height: 70,
                    width: 380,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(
                              10, 5, 0, 3), // Add padding for better visibility
                          child: const Text(
                            "Previous period length",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 150, 3),
                              child: Text(
                                "${periods['range']} Days",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Spacer(), // Add this Spacer widget
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 3),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                color: Color.fromARGB(255, 212, 91, 21),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    height: 70,
                    width: 380,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(
                              10, 5, 0, 3), // Add padding for better visibility
                          child: const Text(
                            "May be Next Periods in",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 150, 3),
                              child: Text(
                                "${card['nextPeriods']} Days",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Spacer(), // Add this Spacer widget
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 3),
                              child: const Icon(
                                Icons.next_week_outlined,
                                color: Color.fromARGB(255, 212, 91, 21),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                  margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  height: mediaQuery.height * .19,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 144, 229, 235),
                      border: Border.all(
                        width: 1,
                        color: Colors.black54,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: Stack(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Menstrual Cycle',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Expanded(
                            child: Text(
                              'Understanding the Menstrual Cycle: A Comprehensive Guide',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PeriodCycleBlog()));
                          },
                          child: const Text(
                            'Read More',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
