import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reminder.dart';
import '../services/api_service.dart';

class CreateReminderScreen extends StatefulWidget {
  const CreateReminderScreen({Key? key}) : super(key: key);

  @override
  State<CreateReminderScreen> createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends State<CreateReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  DateTime? _selectedDateTime;
  String _recurrence = 'once';

  final ApiService _apiService = ApiService();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedDateTime != null) {
      final reminder = Reminder(
        message: _messageController.text,
        datetimeToRemind: _selectedDateTime!,
        recurrence: _recurrence,
        email: _emailController.text,
        isSent: false,
        user: 1, // TEMP: Hardcoded user ID, will improve later
      );

      try {
        await _apiService.createReminder(reminder);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder created!')),
        );
        _formKey.currentState!.reset();
        setState(() => _selectedDateTime = null);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(minutes: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Message'),
                validator: (value) => value == null || value.isEmpty ? 'Enter message' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value == null || !value.contains('@') ? 'Enter valid email' : null,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(_selectedDateTime == null
                    ? 'Select Reminder Time'
                    : DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDateTime,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _recurrence,
                items: ['once', 'daily', 'monthly', 'yearly']
                    .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                    .toList(),
                onChanged: (val) => setState(() => _recurrence = val!),
                decoration: const InputDecoration(labelText: 'Recurrence'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
