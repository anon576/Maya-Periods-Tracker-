import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ionicons/ionicons.dart';
import '/model/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/user_api.dart';
class Partner extends StatefulWidget {
  const Partner({super.key});

  @override
  State<Partner> createState() => _PartnerState();
}

class _PartnerState extends State<Partner> {
   final _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();
  PlatformFile? file;
  bool isLoading = false;
  DateTime? dob;

  
  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

Future<void> addPartner() async {
    try {
      await ApiService.addPartner(
        name: _nameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text
      );

      // Add any additional logic after successful update

    } catch (error) {
      // Handle error
      print('Error updating profile: $error');
    }
  }

  bool Validate(String email) {
   bool _isValid = EmailValidator.validate(email);

    print(_isValid);
    return _isValid;
  }

bool isStrongPassword(String password) {
    // Minimum length check
    if (password.length < 8) {
      return false;
    }

    // Count uppercase letters
    int uppercaseCount = password.replaceAll(RegExp(r'[^A-Z]'), '').length;
    if (uppercaseCount < 2) {
      return false;
    }

    // Count numeric characters
    int numericCount = password.replaceAll(RegExp(r'[^0-9]'), '').length;
    if (numericCount < 3) {
      return false;
    }

    // Special character check
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return false;
    }

    return true;
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
              child: Container(
                height: 80,
                width: 100,
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
                           fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      right: 65,
                      child: Icon(
                        Icons.favorite,
                        color: Color(0xFFFFF5F5),
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
              // Padding(
              //  padding: EdgeInsets.fromLTRB(50, 5, 50, 0),
              //   child: Text("Almost there.!",
              //       style: GoogleFonts.nunitoSans(
              //           color: Colors.black,
              //           fontWeight: FontWeight.bold,
              //           fontSize: mediaQuery.width * .06)),
              // ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 5, 50, 0),
                  child:  Text(
                "Note : By adding partner your partner can also track your cycle",
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w600,
                    color: Colors.black38),
              ),
              ),
             
              // SizedBox(
              //   height: mediaQuery.height * .03,
              // ),

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
                              fillColor:  Color(0xFFFFF5F5),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          maxLines: null,
                          validator: (value) {
                            if (value!.isEmpty ) {
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
                         TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _emailController,
                          validator: (value){
                            if(!Validate(_emailController.text )){
                              return "Invalid email";
                            }
                            else{
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: Icon(
                                Ionicons.mail_open_outline,
                              ),
                              hintText: "Email",

                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor:Color(0xFFFFF5F5),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),

                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _phoneController,
                          validator: (value){
                            if(value!.isEmpty || value.length!=10){
                              return "Invalid phone number";
                            }
                            else{
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
                              fillColor:Color(0xFFFFF5F5),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),

                        ),

                         TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _passwordController,
                          validator: (value){
                            if(!isStrongPassword(_passwordController.text)){
                              return "Enter Valid Password";
                            }
                            else{
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                              prefixIcon: Icon(
                                Ionicons.lock_closed_outline,
                              ),
                              hintText: "Password",

                              hintStyle: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                              fillColor:Color(0xFFFFF5F5),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none)),

                        ),
                         Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
              child: const Text(
                  "Note : Password should contain 8 character with 2 Uppercase letter 3 Numeric character and 1 Special character"),
            ),
          ),
                       ElevatedButton(
                            onPressed: () async {
                              await addPartner();
                              final SharedPreferences sp =
                                  await SharedPreferences.getInstance();
                              sp.setString('partnername', _nameController.text);
                              sp.setString(
                                  'partnerlastname', _lastNameController.text);
                              sp.setString('partneremail', _emailController.text);
                               sp.setString('password', _passwordController.text);
                              sp.setString('partnerphone', _phoneController.text);
                              sp.setBool('partner', true);
                               Navigator.pushNamed(context,'/viewpartner');
                            },
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: mediaQuery.width * .11,
                                        vertical: mediaQuery.height * .015)),
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFFFB4A9),)),
                           child:Text(
                              "Save",
                              style: GoogleFonts.nunitoSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize:20),
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