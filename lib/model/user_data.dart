import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/model/accessory_widgets.dart';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? profileImagePath;
  bool isLoading = false;
  DateTime? dob;

  Future<void> handleImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // File is picked successfully
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      profileImagePath = '$appDocPath/profile_image.jpg';

      // Copy the picked image to the app's local directory
      File(pickedFile.path).copySync(profileImagePath!);

      // Save the image path to SharedPreferences
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('profileImagePath', profileImagePath!);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: mediaQuery.height,
      decoration: const BoxDecoration(
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                  child: Container(
                    height: 120,
                    width: 150,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFB4A9),
                      shape: BoxShape.circle,
                    ),
                    child: const Stack(
                      children: [
                        Center(
                          child: Text(
                            "Glow",
                            style: TextStyle(
                                color: Color(0xFFFFF5F5),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Positioned(
                          top: 25,
                          right: 95,
                          child: Icon(
                            Icons.favorite,
                            color: Color(0xFFFFF5F5),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 5, 50, 0),
                child: Text("Persona Prelude..!",
                    style: GoogleFonts.nunitoSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: mediaQuery.width * .06)),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(50, 5, 50, 0),
                child: Text(
                  "Let's Craft Your Aura!.",
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600, color: Colors.black38),
                ),
              ),
              SizedBox(
                height: mediaQuery.height * .03,
              ),
              Form(
                  key: _key,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(50, 5, 50, 0),
                    height: mediaQuery.height * .55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 2) {
                              return "Invalid name";
                            } else {
                              return null;
                            }
                          },
                          style: GoogleFonts.nunitoSans(),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: const Icon(
                                Ionicons.person_outline,
                              ),
                              hintText: "Name",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: const Color(0xFFFFF5F5),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          maxLines: null,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter a valid last name";
                            } else {
                              return null;
                            }
                          },
                          style: GoogleFonts.nunitoSans(),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: const Icon(
                                Ionicons.accessibility_outline,
                              ),
                              hintText: "Last Name",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: const Color(0xFFFFF5F5),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),
                        SizedBox(
                            height: mediaQuery.height * .09,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter birth date";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: _dateController,
                                    keyboardType: TextInputType.datetime,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 15),
                                        prefixIcon: const Icon(
                                          Ionicons.calendar_outline,
                                        ),
                                        hintText: "DOB",
                                        hintStyle: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black38),
                                        fillColor: const Color(0xFFFFF5F5),
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide.none)),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      dob = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2005, 1, 1),
                                        firstDate: DateTime(1950, 1, 1),
                                        lastDate: DateTime.now().subtract(
                                            const Duration(days: 18 * 365)),
                                      );
                                      if (dob != null) {
                                        _dateController.text =
                                            DateFormat.yMMMd().format(dob!);
                                      }
                                    },
                                    icon: const Icon(
                                        Icons.calendar_month_outlined))
                              ],
                            )),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _phoneController,
                          validator: (value) {
                            if (value!.isEmpty || value.length != 10) {
                              return "Invalid phone number";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: const Icon(
                                Ionicons.phone_portrait_outline,
                              ),
                              hintText: "Phone",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: const Color(0xFFFFF5F5),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Upload profile",
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: mediaQuery.width * .05,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                handleImagePicker();
                              },
                              child: Text(
                                "Upload",
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                const Color(0xFFFFB4A9),
                              )),
                            )
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            bool isValid = _key.currentState!.validate();
                            if (profileImagePath == null) {
                              showSnackBar("Please upload an image.");
                              return;
                            }
                            if (isValid) {
                              setState(() {
                                isLoading = true;
                              });
                              final SharedPreferences sp =
                                  await SharedPreferences.getInstance();
                              sp.setString('name', _nameController.text);
                              sp.setString('lastname', _lastNameController.text);
                              sp.setString('dob', _dateController.text);
                              sp.setString('phone', _phoneController.text);
                              Navigator.pushNamed(context, '/cycleData');
                            } else {
                              showSnackBar("Please fill in all the details.");
                            }
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: mediaQuery.width * .11,
                                vertical: mediaQuery.height * .015,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFFFB4A9),
                            ),
                          ),
                          child: Text(
                            "Next",
                            style: GoogleFonts.nunitoSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: mediaQuery.width * .04,
                            ),)
                    )],
                    ),
                  ))
            ],
          ),
        ),
      ),
    ));
  }

  // void nextPage() {
  //   Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (co()));
  // }
}
