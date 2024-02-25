import 'package:flutter/material.dart';
import '/model/login.dart';
import '/model/report.dart';
import 'model/cycle_data.dart';
import 'model/partner.dart';
import 'model/profile.dart';
import 'model/view_partner.dart';
import 'model/setting.dart';
import 'model/user_data.dart';
import 'model/home.dart';
import 'model/splash_screen.dart';
import 'model/calender.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(), // Change to MainScreen as the initial screen
      routes: {
        '/userData': (context) => const UserData(),
        '/home': (context) => const MainScreen(), // Change to MainScreen for consistency
        '/calender': (context) => const CalendarScreen(),
        '/other': (context) => const Setting(),
        '/profile': (context) => const Profile(),
        '/register': (context) => StartUp(),
        '/addpartner': (context) => const Partner(),
        '/viewpartner': (context) => const PartnerData(),
        '/cycleData': (context) => const CycleData(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const CalendarScreen(),
    const Report(),
    const Setting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.black,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            backgroundColor: Colors.black,
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            backgroundColor: Colors.black,
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            backgroundColor: Colors.black,
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
