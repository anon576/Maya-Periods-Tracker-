import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeApi {
  static Future<void> createNote(DateTime today, String note) async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      int? userid = sp.getInt('userID');
      String uid = userid.toString();

      final response = await http.post(
        Uri.parse('http://192.168.43.192:5000/create_note'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'uid': uid,
          'date': today.toLocal().toIso8601String().split('T')[0],
          'note': note,
        }),
      );

      if (response.statusCode == 201) {
        // Request was successful, you might want to handle the response data if needed
        print('Note created successfully');
      } else {
        // Handle unsuccessful response (non-200 status code)
        print('Failed to create note. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions that might occur during the request
      print('Error creating note: $e');
    }
  }

  // static Future<void> createDate(DateTime today) async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //     DateTime cycleEndDate =
  //     DateFormat.yMd().parse(sp.getString("cycleEndDate") ?? '');
  //     if (cycleEndDate.isBefore(DateTime.now()) || cycleEndDate.isAtSameMomentAs(DateTime.now())) {
  //   today = cycleEndDate;
  // }
  //   int? cyclerange = sp.getInt("cycleLength");
  //   int? periodrange = sp.getInt("periodrange");
  //   int remainingDays = cyclerange! - periodrange!;
  //   int follicularPhase = remainingDays ~/ 3;
  //   int ovulationPhase = remainingDays ~/ 3;
  //   int lutealPhase = remainingDays ~/ 3; 
  //   int nextperiods = cyclerange;

  //   int ovdays;

  //   DateTime endDate = today.add(Duration(days: cyclerange));

  //   int? userid = sp.getInt('userID');
  //   String uid = userid.toString();
  //   for (int i = 1; i <= cyclerange; i++) {
  //     if (periodrange! > 0) {
  //       ovdays = cyclerange - (periodrange + i);
  //       final response = await http.post(
  //         Uri.parse('http://192.168.43.192:5000/add_day'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(<String, String>{
  //           'uid': uid,
  //           'date': today.toLocal().toIso8601String().split('T')[0],
  //           "day": "Day ${i}",
  //           "symptons": "Menstrual cramps, fatigue, mood swings.",
  //           "cycleUpdate1": "Period Day ${i}",
  //           "cycleUpdate2": "Reduce Caffeine and Sugary Foods",
  //           "description":
  //               "This phase begins with the first day of menstruation (bleeding). The body sheds the uterine lining that was prepared for a potential pregnancy in the previous cycle.",
  //           "endDate": endDate.toLocal().toIso8601String().split('T')[0],
  //           "ovdays": ovdays.toString(),
  //           "nextPeriods": nextperiods.toString()
  //         }),
  //       );
  //       periodrange = periodrange! - 1;
  //       nextperiods = nextperiods - 1;
  //       today = today.add(Duration(days: 1));
  //     } else if (follicularPhase > 0) {
  //       ovdays = cyclerange - (periodrange + i);
  //       final response = await http.post(
  //         Uri.parse('http://192.168.43.192:5000/add_day'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(<String, String>{
  //           'uid': uid,
  //           'date': today.toLocal().toIso8601String().split('T')[0],
  //           "day": "Day ${i}",
  //           "symptons": "Increased energy, improved mood, cervical mucus ",
  //           "cycleUpdate1": "Follicular Phase",
  //           "cycleUpdate2": "Fertile Window",
  //           "description":
  //               "The body prepares for ovulation by developing follicles in the ovaries, and one dominant follicle will release an egg.",
  //           "endDate": endDate.toLocal().toIso8601String().split('T')[0],
  //           "ovdays": ovdays.toString(),
  //           "nextPeriods": nextperiods.toString()
  //         }),
  //       );
  //       nextperiods = nextperiods - 1;
  //       follicularPhase = follicularPhase! - 1;
  //       today = today.add(Duration(days: 1));
  //     } else if (ovulationPhase > 0) {
  //       final response = await http.post(
  //         Uri.parse('http://192.168.43.192:5000/add_day'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(<String, String>{
  //           'uid': uid,
  //           'date': today.toLocal().toIso8601String().split('T')[0],
  //           "day": "Day ${i}",
  //           "symptons":
  //               "Increased libido, mild pelvic pain, changes in cervical mucus.",
  //           "cycleUpdate1": "Ovulation days",
  //           "cycleUpdate2": "Good for conception",
  //           "description":
  //               "The mature egg is released from the ovary and moves into the fallopian tube, ready for fertilization.",
  //           "endDate": endDate.toLocal().toIso8601String().split('T')[0],
  //           "ovdays": "Ovulation Alert",
  //           "nextPeriods": nextperiods.toString()
  //         }),
  //       );
  //       nextperiods = nextperiods - 1;
  //       ovulationPhase = ovulationPhase! - 1;
  //       today = today.add(Duration(days: 1));
  //     } else if (lutealPhase > 0) {
  //       final response = await http.post(
  //         Uri.parse('http://192.168.43.192:5000/add_day'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode(<String, String>{
  //           'uid': uid,
  //           'date': today.toLocal().toIso8601String().split('T')[0],
  //           "day": "Day ${i}",
  //           "symptons":
  //               " Breast tenderness, bloating, mood swings, premenstrual syndrome (PMS) symptoms.",
  //           "cycleUpdate1": "Non-Fertile Days",
  //           "cycleUpdate2": "Fertility Low",
  //           "description":
  //               "After ovulation, the ruptured follicle transforms into a structure called the corpus luteum, producing progesterone to prepare the uterus for a potential pregnancy.",
  //           "endDate": endDate.toLocal().toIso8601String().split('T')[0],
  //           "ovdays": "Ovulation End",
  //           "nextPeriods": nextperiods.toString()
  //         }),
  //       );
  //       lutealPhase = lutealPhase! - 1;
  //       nextperiods = nextperiods - 1;
  //       today = today.add(Duration(days: 1));
  //     }
  //   }

  //   sp.setBool("date", true);
  // }

  static Future<List<dynamic>> getNotes(DateTime today) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? userid = sp.getInt('userID');

    final response = await http.get(
      Uri.parse(
          'http://192.168.43.192:5000/get_notes?uID=$userid&date=${today.toLocal().toIso8601String().split('T')[0]}'),
    );

    dynamic responseData = jsonDecode(response.body);
    return responseData['notes'];
  }

  static Future<void> deleteNote(DateTime today, String note) async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      int? userid = sp.getInt('userID');
      String uid = userid.toString();
      final response = await http.post(
        Uri.parse('http://192.168.43.192:5000/delete_note'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'uid': uid,
          'date': today.toLocal().toIso8601String().split('T')[0],
          'note': note,
        }),
      );

      if (response.statusCode == 201) {
        // Request was successful, you might want to handle the response data if needed
        print('symptons deleted successfully');
      } else {
        // Handle unsuccessful response (non-200 status code)
        print('Failed to create symptons. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions that might occur during the request
      print('Error creating note: $e');
    }
  }

  static Future<Map<String, dynamic>> getDate(DateTime today) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? userid = sp.getInt('userID');

    final response = await http.get(
      Uri.parse(
          'http://192.168.43.192:5000/get_date?uID=$userid&date=${today.toLocal().toIso8601String().split('T')[0]}'),
    );

    dynamic responseData = jsonDecode(response.body);
    if (responseData['day'] == null) {
      return {};
    }
    return responseData['day'];
  }

  static Future<void> createSymptons(DateTime today, String symptom) async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      int? userid = sp.getInt('userID');
      String uid = userid.toString();
      final response = await http.post(
        Uri.parse('http://192.168.43.192:5000/add_symptoms'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'uid': uid,
          'date': today.toLocal().toIso8601String().split('T')[0],
          'sympton': symptom,
        }),
      );

      if (response.statusCode == 201) {
        // Request was successful, you might want to handle the response data if needed
        print('symptons created successfully');
      } else {
        // Handle unsuccessful response (non-200 status code)
        print('Failed to create symptons. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions that might occur during the request
      print('Error creating note: $e');
    }
  }

  static Future<List<dynamic>> getSymptons(DateTime today) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? userid = sp.getInt('userID');

    final response = await http.get(
      Uri.parse(
          'http://192.168.43.192:5000/get_symptoms?uID=$userid&date=${today.toLocal().toIso8601String().split('T')[0]}'),
    );

    dynamic responseData = jsonDecode(response.body);
    return responseData['symptoms'];
  }

  static Future<void> deleteSymptons(DateTime today, String symptom) async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      int? userid = sp.getInt('userID');
      String uid = userid.toString();
      final response = await http.post(
        Uri.parse('http://192.168.43.192:5000/delete_symptoms'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'uid': uid,
          'date': today.toLocal().toIso8601String().split('T')[0],
          'sympton': symptom,
        }),
      );

      if (response.statusCode == 201) {
        // Request was successful, you might want to handle the response data if needed
        print('symptons deleted successfully');
      } else {
        // Handle unsuccessful response (non-200 status code)
        print('Failed to create symptons. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions that might occur during the request
      print('Error creating note: $e');
    }
  }

  static Future<void> createSleep(DateTime today, String sleep) async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      int? userid = sp.getInt('userID');
      String uid = userid.toString();
      final response = await http.post(
        Uri.parse('http://192.168.43.192:5000/add_sleep'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'uid': uid,
          'date': today.toLocal().toIso8601String().split('T')[0],
          'sleep': sleep,
        }),
      );

      if (response.statusCode == 201) {
        // Request was successful, you might want to handle the response data if needed
        print('symptons created successfully');
      } else {
        // Handle unsuccessful response (non-200 status code)
        print('Failed to create symptons. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions that might occur during the request
      print('Error creating note: $e');
    }
  }

    static Future<List<dynamic>> getSleep(DateTime today) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    int? userid = sp.getInt('userID');

    final response = await http.get(
      Uri.parse(
          'http://192.168.43.192:5000/get_sleep?uID=$userid&date=${today.toLocal().toIso8601String().split('T')[0]}'),
    );

    dynamic responseData = jsonDecode(response.body);
    return responseData['symptoms'];
  }

  static Future<void> deleteSleep(DateTime today, String symptom) async {
    try {
      final SharedPreferences sp = await SharedPreferences.getInstance();
      int? userid = sp.getInt('userID');
      String uid = userid.toString();
      final response = await http.post(
        Uri.parse('http://192.168.43.192:5000/delete_sleep'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'uid': uid,
          'date': today.toLocal().toIso8601String().split('T')[0],
          'sympton': symptom,
        }),
      );

      if (response.statusCode == 201) {
        // Request was successful, you might want to handle the response data if needed
        print('symptons deleted successfully');
      } else {
        // Handle unsuccessful response (non-200 status code)
        print('Failed to create symptons. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions that might occur during the request
      print('Error creating note: $e');
    }
  }

}
