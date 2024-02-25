import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<bool> sendDataToServer({
    required String? name,
    required String? email,
    required String? password,
    required String? lastName,
    required String? dob,
    required String? phone,
    required DateTime? cycleStartDate,
    required DateTime? cycleEndDate,
    required Duration? cycleRange,
    required DateTime? periodStartDate,
    required DateTime? periodEndDate,
    required Duration? periodRange,
  }) async {
    // Convert DateTime objects to ISO 8601 formatted strings
    String formattedCycleStartDate = cycleStartDate?.toIso8601String() ?? "";
    String formattedCycleEndDate = cycleEndDate?.toIso8601String() ?? "";
    String formattedPeriodStartDate = periodStartDate?.toIso8601String() ?? "";
    String formattedPeriodEndDate = periodEndDate?.toIso8601String() ?? "";
    final SharedPreferences sp = await SharedPreferences.getInstance();

    String? userPeriodStartDate  =  sp.getString("periodStartDate");
    String? userPeriodEndDate  =  sp.getString("periodEndDate");
    String? userCycleStartDate  =  sp.getString("cycleStartDate");
    String? userCycleEndDate  =  sp.getString("cycleEndDate");
    // Prepare data in JSON format
    Map<String, dynamic> userData = {
      "firstName": name,
      "lastName": lastName,
      "password": password,
      "email": email,
      "mobileno": phone,
      "dob": dob,
      "cycleStartDate": formattedCycleStartDate,
      "cycleEndDate": formattedCycleEndDate,
      "cycleRange": cycleRange?.inDays ?? 0,
      "periodStartDate": formattedPeriodStartDate,
      "periodEndDate": formattedPeriodEndDate,
      "periodRange": periodRange?.inDays ?? 0,
      "partner": "False",
      "userPeriodStartDate":userPeriodStartDate,
      "userPeriodEndDate":userPeriodEndDate,
      "userCycleStartDate":userCycleStartDate,
      "userCycleEndDate":userCycleEndDate
    };

    // Convert the data to JSON
    String jsonData = jsonEncode(userData);

    // Specify the API endpoint URL
    Uri apiUrl = Uri.parse('http://192.168.43.192:5000/users');

    try {
      http.Response response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      if (response.statusCode == 201) {
        dynamic responseData = jsonDecode(response.body);
        responseData['result'];
        if (responseData['result']) {
          final SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setInt('userID', responseData['uid']);
          DateTime day =
        DateFormat.yMd().parse(sp.getString("periodStartDate") ?? '');
        createDate(day);
          
          return responseData['result'];
        }
        return responseData['result'];
      } else {
        // Error
        print('Failed to send data. Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error sending data: $error');
      return false;
    }
  }

  static Future<bool> getUser({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> userEmail = {
      "email": email,
      "password": password
      // Add other fields as needed
    };
    String jsonData = jsonEncode(userEmail);

    // Specify the API endpoint URL
    Uri apiUrl = Uri.parse('http://192.168.43.192:5000/get_user');

    try {
      http.Response response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      // Handle the response as needed
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);

        if (responseData['exists']) {
          Map<String, dynamic> user = responseData['user'];
          final SharedPreferences sp = await SharedPreferences.getInstance();
          print(user['cycleRange']);

          sp.setInt('userID', user['userID']);
          sp.setString('name', user['name']);
          sp.setString('lastname', user['lastname']);
          sp.setString('dob', user['dob']);
          sp.setString('phone', user['phone']);
          sp.setInt("cycleLength", user['cycleRange']);
          sp.setInt("periodrange", user['periodRange']);
          sp.setBool("date", true);
          sp.setBool('isLogin', true);

          sp.setString("periodStartDate", user['periodStartDate']);

          sp.setString("periodEndDate", user['periodEndDate']);
          print(42);
          sp.setString("cycleStartDate", user['cycleDate']);

          sp.setString("pcyclendDate", user['cycleEndDate']);

          if (user['partner']) {
            sp.setString('partnername', user['partnerName']);
            sp.setString('partnerlastname', user['partnerLastName']);
            sp.setString('partneremail', user['partnerEmail']);
            sp.setString('partnerphone', user['partnerMobileno']);
            sp.setBool('partner', true);
          } else {
            sp.setBool('partner', false);
          }
          return responseData['exists'];
        }

        return responseData['exists'];
      } else {
        // Error
        print('Failed to send data. Status code: ${response.statusCode}');
        // Return a different integer value for error cases
        return false;
      }
    } catch (error) {
      // Handle any errors that occurred during the HTTP request
      print('Error sending data: $error');
      // Return a different integer value for error cases
      return false;
    }
  }

   static Future<void> createDate(DateTime today) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
      DateTime cycleEndDate =
      DateFormat.yMd().parse(sp.getString("cycleEndDate") ?? '');
      if (cycleEndDate.isBefore(DateTime.now()) || cycleEndDate.isAtSameMomentAs(DateTime.now())) {
    today = cycleEndDate;
  }
    int? cyclerange = sp.getInt("cycleLength");
    int? periodrange = sp.getInt("periodrange");
    int remainingDays = cyclerange! - periodrange!;
    int follicularPhase = remainingDays ~/ 3;
    int ovulationPhase = remainingDays ~/ 3;
    int lutealPhase = remainingDays ~/ 3; 
    int nextperiods = cyclerange;

    int ovdays;

    DateTime endDate = today.add(Duration(days: cyclerange));

    int? userid = sp.getInt('userID');
    String uid = userid.toString();
    for (int i = 1; i <= cyclerange; i++) {
      if (periodrange! > 0) {
        ovdays = cyclerange - (periodrange + i);
        final response = await http.post(
          Uri.parse('http://192.168.43.192:5000/add_day'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'uid': uid,
            'date': today.toLocal().toIso8601String().split('T')[0],
            "day": "Day ${i}",
            "symptons": "Menstrual cramps, fatigue, mood swings.",
            "cycleUpdate1": "Period Day ${i}",
            "cycleUpdate2": "Reduce Caffeine and Sugary Foods",
            "description":
                "This phase begins with the first day of menstruation (bleeding). The body sheds the uterine lining that was prepared for a potential pregnancy in the previous cycle.",
            "endDate": endDate.toLocal().toIso8601String().split('T')[0],
            "ovdays": ovdays.toString(),
            "nextPeriods": nextperiods.toString()
          }),
        );
        periodrange = periodrange! - 1;
        nextperiods = nextperiods - 1;
        today = today.add(Duration(days: 1));
      } else if (follicularPhase > 0) {
        ovdays = cyclerange - (periodrange + i);
        final response = await http.post(
          Uri.parse('http://192.168.43.192:5000/add_day'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'uid': uid,
            'date': today.toLocal().toIso8601String().split('T')[0],
            "day": "Day ${i}",
            "symptons": "Increased energy, improved mood, cervical mucus ",
            "cycleUpdate1": "Follicular Phase",
            "cycleUpdate2": "Fertile Window",
            "description":
                "The body prepares for ovulation by developing follicles in the ovaries, and one dominant follicle will release an egg.",
            "endDate": endDate.toLocal().toIso8601String().split('T')[0],
            "ovdays": ovdays.toString(),
            "nextPeriods": nextperiods.toString()
          }),
        );
        nextperiods = nextperiods - 1;
        follicularPhase = follicularPhase! - 1;
        today = today.add(Duration(days: 1));
      } else if (ovulationPhase > 0) {
        final response = await http.post(
          Uri.parse('http://192.168.43.192:5000/add_day'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'uid': uid,
            'date': today.toLocal().toIso8601String().split('T')[0],
            "day": "Day ${i}",
            "symptons":
                "Increased libido, mild pelvic pain, changes in cervical mucus.",
            "cycleUpdate1": "Ovulation days",
            "cycleUpdate2": "Good for conception",
            "description":
                "The mature egg is released from the ovary and moves into the fallopian tube, ready for fertilization.",
            "endDate": endDate.toLocal().toIso8601String().split('T')[0],
            "ovdays": "Ovulation Alert",
            "nextPeriods": nextperiods.toString()
          }),
        );
        nextperiods = nextperiods - 1;
        ovulationPhase = ovulationPhase! - 1;
        today = today.add(Duration(days: 1));
      } else if (lutealPhase > 0) {
        final response = await http.post(
          Uri.parse('http://192.168.43.192:5000/add_day'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'uid': uid,
            'date': today.toLocal().toIso8601String().split('T')[0],
            "day": "Day ${i}",
            "symptons":
                " Breast tenderness, bloating, mood swings, premenstrual syndrome (PMS) symptoms.",
            "cycleUpdate1": "Non-Fertile Days",
            "cycleUpdate2": "Fertility Low",
            "description":
                "After ovulation, the ruptured follicle transforms into a structure called the corpus luteum, producing progesterone to prepare the uterus for a potential pregnancy.",
            "endDate": endDate.toLocal().toIso8601String().split('T')[0],
            "ovdays": "Ovulation End",
            "nextPeriods": nextperiods.toString()
          }),
        );
        lutealPhase = lutealPhase! - 1;
        nextperiods = nextperiods - 1;
        today = today.add(Duration(days: 1));
      }
    }

    sp.setBool("date", true);
  }


  static Future<bool> getPartner({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> userEmail = {
      "email": email,
      "password": password
      // Add other fields as needed
    };
    String jsonData = jsonEncode(userEmail);

    // Specify the API endpoint URL
    Uri apiUrl = Uri.parse('http://192.168.43.192:5000/partnerLogin');

    try {
      http.Response response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );
      // Handle the response as needed
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        if (responseData['exists']) {
          Map<String, dynamic> user = responseData['user'];
          final SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setInt('userID', user['userID']);
          sp.setString('name', user['name']);
          sp.setString('lastname', user['lastname']);
          sp.setString('dob', user['dob']);
          sp.setString('phone', user['phone']);
          sp.setInt("cycleLength", user['cycleRange']);
          sp.setInt("periodrange", user['periodRange']);
          sp.setBool("date", true);
          sp.setBool('isLogin', true);
          print(23);
            sp.setString("periodStartDate", user['periodStartDate']);

          sp.setString("periodEndDate", user['periodEndDate']);
          print(42);
          sp.setString("cycleStartDate", user['cycleDate']);

          sp.setString("pcyclendDate", user['cycleEndDate']);

          if (user['partner']) {
          
            sp.setString('partnername', user['partnerName']);
            sp.setString('partnerlastname', user['partnerLastName']);
            sp.setString('partneremail', user['partnerEmail']);
            sp.setString('partnerphone', user['partnerMobileno']);
          
            sp.setBool('partner', true);
             
          } else {
            sp.setBool('partner', false);
          }
         
          return responseData['exists'];
        }

        return responseData['exists'];
      } else {
        // Error
        print('Failed to send data. Status code: ${response.statusCode}');
        // Return a different integer value for error cases
        return false;
      }
    } catch (error) {
      // Handle any errors that occurred during the HTTP request
      print('Error sending data: $error');
      // Return a different integer value for error cases
      return false;
    }
  }

  static Future<void> updateProfile({
    required String name,
    required String lastName,
    required String dob,
    required String phone,
  }) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? userid = sp.getInt('userID');

    // Your API endpoint for updating the profile
    final apiUrl = 'http://192.168.43.192:5000/update_profile';

    // Convert the image file to bytes (optional, depends on your server)

    // Prepare data to be sent to the server
    final Map<String, dynamic> userData = {
      'name': name,
      'lastname': lastName,
      'dob': dob,
      'phone': phone,
      'userID': userid
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Profile updated successfully');
        // Add any additional logic after successful update
      } else {
        // Handle error
        print('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exception
      print('Error updating profile: $error');
    }
  }

  static Future<void> addPartner({
    required String name,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? userid = sp.getInt('userID');

    // Your API endpoint for updating the profile
    final apiUrl = 'http://192.168.43.192:5000/add_partner';

    // Convert the image file to bytes (optional, depends on your server)

    // Prepare data to be sent to the server
    final Map<String, dynamic> userData = {
      'name': name,
      'lastname': lastName,
      'email': email,
      'phone': phone,
      'userID': userid,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Profile updated successfully');
        // Add any additional logic after successful update
      } else {
        // Handle error
        print('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exception
      print('Error updating profile: $error');
    }
  }

  static Future<void> update_partner({
    required String name,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? userid = sp.getInt('userID');

    // Your API endpoint for updating the profile
    final apiUrl = 'http://192.168.43.192:5000/update_partner';

    // Convert the image file to bytes (optional, depends on your server)

    // Prepare data to be sent to the server
    final Map<String, dynamic> userData = {
      'name': name,
      'lastname': lastName,
      'email': email,
      'phone': phone,
      'userID': userid,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Profile updated successfully');
        // Add any additional logic after successful update
      } else {
        // Handle error
        print('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exception
      print('Error updating profile: $error');
    }
  }
}
