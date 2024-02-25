import 'package:flutter/material.dart';
import '/model/custom_appbar.dart';
import '/model/health.dart';
import '/model/info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late final TextEditingController dateController = TextEditingController();

  bool partner = false;
  // String? selectedAppUsageReason;
@override
  void initState() {
    getSharedPreference();
    // TODO: implement initState
    super.initState();
  }

  void getSharedPreference() async{
     final SharedPreferences sp = await SharedPreferences.getInstance();
     partner = sp.getBool('partner')!;
  }

  @override
  void dispose() {
    dateController.dispose(); // Dispose of the controller
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
     final mediaQuery = MediaQuery.of(context).size;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
      
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
        child:  SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Center(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 200.0, 25.0, 1.0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(25.0, 1.0, 25.0, 1.0),
                    // height: 60,
                    width: 220,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB4A9),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black54,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: const Text("Profile"),
                    ),
                  ))),
          const SizedBox(height: 20),
          Center(
              child: Container(
            padding: const EdgeInsets.fromLTRB(25.0, 1.0, 25.0, 1.0),
            // height: 60,
            width: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB4A9),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black54,
              ),
              onPressed: () {
                if(partner){
                     Navigator.pushNamed(context, '/viewpartner');
                }else{
                  Navigator.pushNamed(context, '/addpartner');
                }
               
              },
              child: const Text("Partner"),
            ),
          )),
          const SizedBox(height: 20),
          Center(
              child: Container(
            padding: const EdgeInsets.fromLTRB(25.0, 1.0, 25.0, 1.0),
            // height: 60,
            width: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB4A9),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black54,
              ),
              onPressed: () {
                 Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          pageBuilder: (_, __, ___) =>
                               PeriodDetailsBlogScreen(), // Replace NextScreen with your desired screen
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0,
                                    0.0), // Start offscreen to the right
                                end: Offset.zero, // Slide to the center of the screen
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
               
              },
              child: const Text("Info"),
            ),
          )),
          const SizedBox(height: 20),
          Center(
              child: Container(
            padding: const EdgeInsets.fromLTRB(25.0, 1.0, 25.0, 1.0),
            // height: 60,
            width: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB4A9),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black54,
              ),
              onPressed: () {
               Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          pageBuilder: (_, __, ___) =>
                              SettingsScreen(), // Replace NextScreen with your desired screen
                          transitionsBuilder: (_, animation, __, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0,
                                    0.0), // Start offscreen to the right
                                end: Offset.zero, // Slide to the center of the screen
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
              },
              child: const Text("Health"),
            ),
          )),
           const SizedBox(height: 20),
          Center(
              child: Container(
            padding: const EdgeInsets.fromLTRB(25.0, 1.0, 25.0, 1.0),
            // height: 60,
            width: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB4A9),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black54,
              ),
              onPressed: () async {
                final SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setBool('isLogin', false);
                await sp.clear();
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Logout"),
            ),
          )),
          
        ],
      ),
      ),
      

    ));
  }
}
