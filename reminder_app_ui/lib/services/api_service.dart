import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/reminder.dart';

class ApiService {
  Future<List<Reminder>> fetchReminders() async {
    final response = await http.get(Uri.parse('${baseUrl}reminders/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Reminder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reminders');
    }
  }

  Future<Reminder> createReminder(Reminder reminder) async {
    final response = await http.post(
      Uri.parse('${baseUrl}reminders/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reminder.toJson()),
    );

    if (response.statusCode == 201) {
      return Reminder.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create reminder');
    }
  }
}
