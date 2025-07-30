class Reminder {
  final int? id;
  final String message;
  final DateTime datetimeToRemind;
  final String recurrence;
  final String email;
  final bool isSent;
  final int user;

  Reminder({
    this.id,
    required this.message,
    required this.datetimeToRemind,
    required this.recurrence,
    required this.email,
    required this.isSent,
    required this.user,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      message: json['message'],
      datetimeToRemind: DateTime.parse(json['datetime_to_remind']),
      recurrence: json['recurrence'],
      email: json['email'],
      isSent: json['is_sent'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'datetime_to_remind': datetimeToRemind.toIso8601String(),
      'recurrence': recurrence,
      'email': email,
      'is_sent': isSent,
      'user': user,
    };
  }
}
