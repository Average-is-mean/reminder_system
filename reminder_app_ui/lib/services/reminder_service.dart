import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reminder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReminderService {
  static String baseUrl = dotenv.env['API_BASE_URL']!;

  static Future<List<Reminder>> fetchReminders() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body); // ← this is the correct type
      return data.map((json) => Reminder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reminders: ${response.statusCode}');
    }
  }
}
