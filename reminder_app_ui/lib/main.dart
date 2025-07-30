import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/reminder_list_screen.dart';
import 'screens/create_reminder_screen.dart';


Future<void> main() async {
  await dotenv.load(fileName: 'assets/.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      home: ReminderListScreen(),
    );
  }
}
