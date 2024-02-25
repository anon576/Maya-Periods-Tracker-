import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:ionicons/ionicons.dart';
import '/model/custom_appbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apis/user_api.dart';
import '/model/accessory_widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  PlatformFile? file;
  bool isLoading = false;
  DateTime? dob;
  String? profileImagePath;


  @override
  void initState() {
    super.initState();
    // Load values from SharedPreferences when the screen is loaded
    loadSharedPreferences();
  }

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
profileImagePath = profileImagePath;
    // Update the state to trigger a rebuild of the widget tree
    setState(() {
      
    });
  }
}

Future<void> updateProfile() async {
    try {
      await ApiService.updateProfile(
        name: _nameController.text,
        lastName: _lastNameController.text,
        dob: _dateController.text,
        phone: _phoneController.text,
      );

      // Add any additional logic after successful update

    } catch (error) {
      // Handle error
      print('Error updating profile: $error');
    }
  }

  void loadSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImagePath = prefs.getString('profileImagePath');
      print(profileImagePath);
      _nameController.text = prefs.getString('name') ?? '';
      _lastNameController.text = prefs.getString('lastname') ?? '';
      _dateController.text = prefs.getString('dob') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      // You may need to convert the saved date string to DateTime
      dob = DateTime.tryParse(prefs.getString('dob') ?? '');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _lastNameController.dispose();
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
              Center(
                child:Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
                  child: Stack(
                    children: [
                      ClipOval(
                        child: profileImagePath != null
                            ? Image.file(
                                File(profileImagePath!),
                                key: Key(profileImagePath!),  // Add a key to force rebuild when the path changes
                                height: 180,
                                width: 180,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 190,
                                width: 190,
                                color: Colors.grey, // Placeholder color
                              ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () async {
                            handleImagePicker();
                         
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
             

              Form(
                  key: _key,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(50, 5, 50, 0),
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
                              prefixIcon: Icon(
                                Ionicons.person_outline,
                              ),
                              hintText: "Name",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: Color(0xFFFFF5F5),
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
                              prefixIcon: Icon(
                                Ionicons.accessibility_outline,
                              ),
                              hintText: "Last Name",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: Color(0xFFFFF5F5),
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
                                      if (dob != null) {
                                        return null;
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
                                        prefixIcon: Icon(
                                          Ionicons.calendar_outline,
                                        ),
                                        hintText: "DOB",
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
                                    onPressed: () async {
                                      dob = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2005, 1, 1),
                                        firstDate: DateTime(1950, 1, 1),
                                        lastDate: DateTime.now()
                                            .subtract(Duration(days: 18 * 365)),
                                      );
                                      if (dob != null) {
                                        _dateController.text =
                                            DateFormat.yMMMd().format(dob!);
                                      }
                                    },
                                    icon: Icon(Icons.calendar_month_outlined))
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
                              prefixIcon: Icon(
                                Ionicons.phone_portrait_outline,
                              ),
                              hintText: "Phone",
                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor: Color(0xFFFFF5F5),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              // bool isValid = _key.currentState!.validate();
                             if (profileImagePath == null) {
                                AccessoryWidgets.showSnackBar(
                                    "Upload Image", context);
                                return;
                              }
                              await updateProfile();
                                final SharedPreferences sp =
                                  await SharedPreferences.getInstance();
                              sp.setString('name', _nameController.text);
                              sp.setString(
                                  'lastname', _lastNameController.text);
                              sp.setString('dob', _dateController.text);
                              sp.setString('phone', _phoneController.text);
                              Navigator.pushNamed(context, '/profile');
                            },
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: mediaQuery.width * .11,
                                        vertical: mediaQuery.height * .015)),
                                backgroundColor: MaterialStateProperty.all(
                                  Color(0xFFFFB4A9),
                                )),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Update profile",
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

  // void nextPage() {
  //   Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (co()));
  // }
}
