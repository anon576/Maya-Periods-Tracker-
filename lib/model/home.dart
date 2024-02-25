import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/model/custom_appbar.dart';
import '/model/ovulation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apis/home_api.dart';
import '../model/symptons.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime today = DateTime.now();
  late final TextEditingController dateController = TextEditingController();
  late final TextEditingController _noteController = TextEditingController();
  late Map<String, dynamic> card = {};
  late int cycleRange = 0;
  late int periodRange = 0;
  late String name = '';
  String? _selectedOption;

  // late DateTime _rangeStartDay;
  // late DateTime _rangeEndDay;

  @override
  void initState() {
    getNotes();
    getSymptons();
    getSleep();
    createDate();
    getDay();
    setState(() {});
    super.initState();
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
          createSleep(option);
          setState(() {
            _selectedOption = selected ? option : null;
          });
        },
      ),
    );
  }

  Future<void> createDate() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
 

    cycleRange = sp.getInt("cycleLength") ?? 0;
    periodRange = sp.getInt("periodrange") ?? 0;
    name = sp.getString("name")!;

  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      getSleep();
      getNotes();
      getDay();
      getSymptons();
    });
  }

  Future<void> createNote(String note) async {
    // Perform asynchronous work without updating the widget state
    await HomeApi.createNote(today, note);

    // Fetch updated notes after creating a new note
    await getNotes();

    // Update the widget state inside a synchronous call to setState
    setState(() {
      // Update any state variables if needed
    });
  }

   Future<void> createSleep(String sleep) async {
    // Perform asynchronous work without updating the widget state
    await HomeApi.createSleep(today, sleep);

    // Fetch updated notes after creating a new note
    await getNotes();

    // Update the widget state inside a synchronous call to setState
    setState(() {
      // Update any state variables if needed
    });
  }

  Future<List<dynamic>> getNotes() async {
    return HomeApi.getNotes(today);
  }
Future<List<dynamic>> getSleep() async {
    return HomeApi.getSleep(today);
  }

  Future<Map<String, dynamic>> getDay() async {
    card = await HomeApi.getDate(today);
    setState(() {});
    return HomeApi.getDate(today);
  }

  Future<List<dynamic>> getSymptons() async {
    return await HomeApi.getSymptons(today);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

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

  Widget _buildPeriodDaysContainer() {
    if (periodRange > 9 || periodRange < 2) {
      return Text(
        '$periodRange Days',
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 223, 40, 40),
        ),
      );
    } else {
      return Text(
        '$periodRange Days',
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }
  }

  Widget _buildDaysContainer() {
    if (cycleRange > 32 || cycleRange < 22) {
      return Text(
        '$cycleRange Days',
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 223, 40, 40),
        ),
      );
    } else {
      return Text(
        '$cycleRange Days',
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    var t = DateTime.now();
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
                  child: TableCalendar(
                    daysOfWeekHeight: 30,
                    rowHeight: 40,
                    availableGestures: AvailableGestures.all,
                    selectedDayPredicate: (day) => isSameDay(day, today),
                    focusedDay: today,
                    firstDay: DateTime.utc(1950, 10, 16),
                    lastDay: DateTime.utc(2050, 10, 16),
                    calendarFormat: CalendarFormat.week,
                    onDaySelected: _onDaySelected,
                    headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        leftChevronVisible: false,
                        rightChevronVisible: false,
                        titleTextStyle: TextStyle(fontWeight: FontWeight.w300),
                        headerMargin: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB4A9),
                        // shape: BoxShape.rectangle,
                        // borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 75,
                          color: const Color(0xFFFFB4A9),
                        ),
                      ),
                    ),
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(color: Colors.black),
                      selectedDecoration: BoxDecoration(
                        color: Color.fromARGB(255, 151, 147, 147),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                )),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Stack(
                      children: [
                        // Circular background with gradient
                        Container(
                          height: mediaQuery.height * 0.47,
                          width: mediaQuery.width,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 199, 250),
                                Color(0xFF9AAFFF)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.water_drop,
                                  color: Color.fromARGB(255, 228, 97, 141),
                                  size: 60,
                                ),
                                const SizedBox(height: 10),

                                Text(
                                  '${card['day']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${card['cycleUpdate1']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Common symptoms
                                Text(
                                  'May feel : ${card['symptons']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${card['cycleUpdate2']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                Text(
                                  DateFormat('MMMd').format(t),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 238, 67, 124),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Circular cards
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: mediaQuery.height * .16,
                        width: mediaQuery.width * .55,
                        decoration: const BoxDecoration(
                            color: Color(0xFFFCE5E7),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              iconSize: mediaQuery.height * .07,
                              color: Colors.pink[200],
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Symptons(selectedDate: today)),
                                );
                              },
                            ),
                            SizedBox(
                                height: mediaQuery.height *
                                    .001), // Adjust the spacing between icon and text as needed
                            Text(
                              'Log Symptoms',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight
                                    .bold, // Adjust the font weight as needed
                                color: Colors.pink[
                                    200], // Adjust the text color as needed
                              ),
                            ),
                            const Text(
                              'Tap here to add your symptoms',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10, // Adjust the font size as needed
                                fontWeight: FontWeight
                                    .w100, // Adjust the font weight as needed
                                color: Colors
                                    .black, // Adjust the text color as needed
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: mediaQuery.width * .02),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: mediaQuery.height * .16,
                        width: mediaQuery.width * .35,
                        decoration: const BoxDecoration(
                            color: Color(0xFFFCE5E7),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.note_add_outlined),
                              iconSize: mediaQuery.height * .07,
                              color: Colors.pink[200],
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: const Text("Add Note"),
                                        content: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: TextField(
                                            controller: _noteController,
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  String noteText =
                                                      _noteController.text;
                                                  Navigator.of(context).pop();
                                                  createNote(noteText);
                                                  _noteController.clear();
                                                });
                                              },
                                              child: const Text("ADD"))
                                        ],
                                      );
                                    });
                                // Navigate to another screen when the button is pressed
                              },
                            ),
                            SizedBox(
                                height: mediaQuery.height *
                                    .001), // Adjust the spacing between icon and text as needed
                            Text(
                              'Add Note',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20, // Adjust the font size as needed
                                fontWeight: FontWeight
                                    .bold, // Adjust the font weight as needed
                                color: Colors.pink[
                                    200], // Adjust the text color as needed
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: FutureBuilder<List<dynamic>>(
                    future: getSymptons(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Container();
                      } else {
                        List<dynamic> symptoms = snapshot.data!;
                        return Column(
                          children: [
                            // Other widgets above the symptoms list
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                              child: Container(
                                width: 380,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: Color(0xFFFFF5F5),
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero, // Remove padding
                                  shrinkWrap: true,
                                  itemCount: symptoms.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () =>
                                          print(''), // Handle onTap as needed
                                      title: Text(
                                          '${index + 1}. ${symptoms[index]}'),
                                      trailing: IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline_outlined),
                                        onPressed: () async {
                                          await HomeApi.deleteSymptons(
                                              today, symptoms[index]);
                                          setState(() {});
                                          print(
                                              'Deleting symptom at index $index');
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Symptoms list
                          ],
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: FutureBuilder<List<dynamic>>(
                    future: getNotes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Container();
                      } else {
                        List<dynamic> notes = snapshot.data!;
                        return Column(
                          children: [
                            // Other widgets above the notes list
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                              // height: 60,
                              width: 380,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: Color(0xFFFFF5F5),
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap:
                                    true, // Make sure it doesn't take more space than needed
                                itemCount: notes.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    // ignore: avoid_print
                                    onTap: () => print(''),
                                    title:
                                        Text('${index + 1}. ${notes[index]}'),
                                    trailing: IconButton(
                                      icon: const Icon(
                                          Icons.delete_outline_outlined),
                                      onPressed: () async {
                                        await HomeApi.deleteNote(
                                            today, notes[index]);
                                        setState(() {});
                                        print(
                                            'Deleting symptom at index $index');
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                            // Notes list
                          ],
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                    margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    height: mediaQuery.height * .19,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Cycle',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Container(
                                // padding: const EdgeInsets.all(12.0),
                                height: mediaQuery.height * .12,
                                width: mediaQuery.width * .4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color:
                                        const Color.fromARGB(255, 235, 176, 14),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      const Color.fromARGB(255, 243, 222, 198),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 0, 10),
                                        child: _buildTextContainer()),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 0, 5),
                                        child: _buildDaysContainer()),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 0, 5),
                                      child: const Text(
                                        'Cycle length',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                            const SizedBox(width: 20.0),
                            Container(
                                // padding: const EdgeInsets.all(12.0),
                                height: mediaQuery.height * .12,
                                width: mediaQuery.width * .4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color:
                                        const Color.fromARGB(255, 22, 167, 8),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      const Color.fromARGB(255, 193, 228, 201),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 0, 10),
                                        child: _buildPeriodTextContainer()),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 0, 5),
                                        child: _buildPeriodDaysContainer()),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 0, 5),
                                      child: const Text(
                                        'Period length',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                    margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    height: mediaQuery.height * .19,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 193, 230, 235),
                        border: Border.all(
                          width: 1,
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ovulation Update',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Container(
                                // padding: const EdgeInsets.all(12.0),
                                height: mediaQuery.height * .12,
                                width: mediaQuery.width * .4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color:
                                        const Color.fromARGB(255, 5, 110, 180),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      const Color.fromARGB(255, 170, 216, 243),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 0, 10),
                                      child: const Text(
                                        'May In',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 13, 52, 122),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 0, 5),
                                      child: Text(
                                        '${card['ovdays']} Days',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 0, 5),
                                      child: const Text(
                                        'Ovulation Info',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                            const SizedBox(width: 20.0),
                            Container(
                                // padding: const EdgeInsets.all(12.0),
                                height: mediaQuery.height * .12,
                                width: mediaQuery.width * .4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color:
                                        const Color.fromARGB(255, 223, 8, 126),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      const Color.fromARGB(255, 235, 202, 235),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            45, 10, 0, 0),
                                        child: IconButton(
                                          iconSize: 50,
                                          icon: const Icon(Icons.info),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OvulationInfo(),
                                                ));
                                          },
                                        )),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 0, 0),
                                      child: const Text(
                                        'Know More',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(height: 15),
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                    margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    height: mediaQuery.height * .19,
                    width: mediaQuery.width,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 232, 216, 238),
                        border: Border.all(
                          width: 1,
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sleep Update',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                            // padding: const EdgeInsets.all(12.0),
                            height: mediaQuery.height * .08,
                            width: mediaQuery.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: const Color.fromARGB(255, 5, 110, 180),
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(255, 191, 210, 235),
                            ),
                            child: SingleChildScrollView( 
                              scrollDirection: Axis.horizontal,
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                                  child: Wrap(
                                    spacing: 10,
                                    children: [
                                      
                                      _buildOption('Good',
                                          Icons.star, Colors.yellow),
                                      _buildOption(
                                          'Average',
                                          Icons.nightlight_round,
                                          Colors.orange),
                                      _buildOption(
                                          'RPoor',
                                          Icons.airline_seat_recline_extra,
                                          Colors.purple),
                                          _buildOption('Wake up less often',
                                          Icons.bed, Colors.blue),
                                      _buildOption('Fall asleep faster',
                                          Icons.timer, Colors.green),
                                      _buildOption('Other', Icons.more_horiz,
                                          Colors.grey),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                            )
                      ],
                    )),
                      const SizedBox(height: 15),
                Center(
                  child: FutureBuilder<List<dynamic>>(
                    future: getSleep(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Container();
                      } else {
                        List<dynamic> notes = snapshot.data!;
                        return Column(
                          children: [
                            // Other widgets above the notes list
                            Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                              // height: 60,
                              width: 380,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: Color(0xFFFFF5F5),
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap:
                                    true, // Make sure it doesn't take more space than needed
                                itemCount: notes.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    // ignore: avoid_print
                                    onTap: () => print(''),
                                    title:
                                        Text('${index + 1}. ${notes[index]}'),
                                    trailing: IconButton(
                                      icon: const Icon(
                                          Icons.delete_outline_outlined),
                                      onPressed: () async {
                                        await HomeApi.deleteSleep(
                                            today, notes[index]);
                                        setState(() {});
                                        print(
                                            'Deleting symptom at index $index');
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                            // Notes list
                          ],
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                    margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    height: mediaQuery.height * .19,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 214, 215),
                        border: Border.all(
                          width: 1,
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phase Information',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          '${card['description']}',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ));
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFFFB4A9)
      ..style = PaintingStyle.fill;

    // Draw a rectangle with rounded corners
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rRect =
        RRect.fromRectAndRadius(rect, const Radius.circular(5.0));
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
