import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/main.dart';
import '/model/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;

  bool isLoggedIn = false;
  List<Color> gradientColors = [Color(0xFFFCE5E7), Color(0xFFC6E2FF)];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    getValidationData().whenComplete(() async {
      _timer = Timer(Duration(seconds: 3), () {
        if (isLoggedIn) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainScreen()));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => StartUp()));
        }
      });
    });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  Future<void> getValidationData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    // sp.setBool('isLogin',false);
    setState(() {
      isLoggedIn = sp.getBool('isLogin') ?? false;
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedContainer(
        duration: Duration(seconds: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        onEnd: () {
          setState(() {
            // Reverse gradient colors when the animation ends
            gradientColors = gradientColors.reversed.toList();
          });
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 5.0),
            child: Container(
              height: 300,
              width: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB4A9),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "Glow",
                      style: TextStyle(
                        color: Color(0xFFFFF5F5),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    right: 130,
                    child: Icon(
                      Icons.favorite,
                      color: Color(0xFFFFF5F5),
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
