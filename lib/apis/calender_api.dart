import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarApi{
   static Future<List<PickerDateRange>> fetchPeriods() async {
     final SharedPreferences sp = await SharedPreferences.getInstance();
    int? userid = sp.getInt('userID');

 final response = await http.get(
  Uri.parse('http://192.168.43.192:5000/get_periods?uID=$userid'),
);

  if (response.statusCode == 200) {
    List<dynamic> periodsData = json.decode(response.body);

    List<PickerDateRange> periods = [];
for (var periodData in periodsData) {
  DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
  
  DateTime startDate = dateFormat.parse(periodData['startdate']);
  DateTime endDate = dateFormat.parse(periodData['enddate']);
  periods.add(PickerDateRange(startDate, endDate));
}

    return periods;
  } else {
    throw Exception('Failed to load periods');
  }
}

  static Future<Map<String, dynamic>> getCurrentMonthData() async {
      final SharedPreferences sp = await SharedPreferences.getInstance();
    int? userid = sp.getInt('userID');
    try {
      final response = await http.get(Uri.parse('http://192.168.43.192:5000/cycle_range?uID=$userid'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return {'error': 'Failed to load data'};
      }
    } catch (error) {
      print('Error fetching data: $error');
      return {'error': 'Internal Server Error'};
    }
  }

  static Future<bool> updatePeriod({
  required DateTime? periodStartDate,
  required DateTime? periodEndDate,
  required String? periodRange,
}) async {

 final SharedPreferences sp = await SharedPreferences.getInstance();
    int? userid = sp.getInt('userID');


  String formattedPeriodStartDate = periodStartDate?.toIso8601String() ?? "";
  String formattedPeriodEndDate = periodEndDate?.toIso8601String() ?? "";

  // Prepare data in JSON format
  Map<String, dynamic> userData = {
    "periodStartDate": formattedPeriodStartDate,
    "periodEndDate": formattedPeriodEndDate,
    "periodRange": periodRange,
    'userID':userid
  };

  // Convert the data to JSON
  String jsonData = jsonEncode(userData);

    // Specify the API endpoint URL
    Uri apiUrl = Uri.parse('http://192.168.43.192:5000/updateperiods');

    try {
      http.Response response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      if (response.statusCode == 201) {
        dynamic responseData = jsonDecode(response.body);
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

}