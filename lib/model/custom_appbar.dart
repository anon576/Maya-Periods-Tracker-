import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserNameFromPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBar(
            automaticallyImplyLeading: false,
            title: CircularProgressIndicator(), // Placeholder while loading
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
          );
        } else if (snapshot.hasError) {
          return AppBar(
            automaticallyImplyLeading: false,
            title: Text('Error loading user name'), // Placeholder for error
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
          );
        } else {
          final userName = snapshot.data!;
          return AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const CircleAvatar(
                  // Assuming you have a user image, replace the placeholder AssetImage with your actual user image
                  backgroundImage: AssetImage('assets/profile-picture.png'),
                  radius: 20,
                ),
                const SizedBox(
                    width: 8), // Adjust spacing between the profile image and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                    Text(
                      userName,
                      style: const TextStyle(
                          color: Colors.pink, fontSize: 16),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  'Glow',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontSize: 25),
                ),
                // SizedBox(width: 1), // Adjust spacing between the icon and text
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
          );
        }
      },
    );
  }

  Future<String> _getUserNameFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'Guest';
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
