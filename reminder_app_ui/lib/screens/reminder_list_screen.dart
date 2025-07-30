import 'package:flutter/material.dart';
import '../models/reminder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  late Future<List<Reminder>> _reminders;

  @override
  void initState() {
    super.initState();
    _reminders = fetchReminders();
  }

  Future<List<Reminder>> fetchReminders() async {
    final url = '${dotenv.env['API_BASE_URL']}reminders/';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body); // ✅ Correct
      return data.map((json) => Reminder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reminders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Reminders")),
      body: FutureBuilder<List<Reminder>>(
        future: _reminders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reminders found."));
          }

          final reminders = snapshot.data!;
          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final r = reminders[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  title: Text(r.message),
                  subtitle: Text("🕒 ${r.datetimeToRemind} | 🔁 ${r.recurrence}"),
                  trailing: Icon(
                    r.isSent ? Icons.check_circle : Icons.schedule,
                    color: r.isSent ? Colors.green : Colors.orange,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
