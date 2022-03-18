import 'dart:convert';

import 'package:equatable/equatable.dart';

class MyFeedback extends Equatable {
  final int idFeedback;
  final int idAccount;
  final String subject;
  final String content;
  final int status;
  final String email;
  final String accountName;
  final String realName;
  final String day;
  final String time;

  const MyFeedback(
      this.idFeedback,
      this.idAccount,
      this.subject,
      this.content,
      this.status,
      this.email,
      this.accountName,
      this.realName,
      this.day,
      this.time);

  @override
  List<Object> get props {
    return [
      idFeedback,
      idAccount,
      subject,
      content,
      status,
      email,
      accountName,
      realName,
      day,
      time,
    ];
  }

  MyFeedback copyWith({
    int? idFeedback,
    int? idAccount,
    String? subject,
    String? content,
    int? status,
    String? email,
    String? accountName,
    String? realName,
    String? day,
    String? time,
  }) {
    return MyFeedback(
      idFeedback ?? this.idFeedback,
      idAccount ?? this.idAccount,
      subject ?? this.subject,
      content ?? this.content,
      status ?? this.status,
      email ?? this.email,
      accountName ?? this.accountName,
      realName ?? this.realName,
      day ?? this.day,
      time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_feedback': idFeedback,
      'id_account': idAccount,
      'subject': subject,
      'content': content,
      'status': status,
      'email': email,
      'account_name': accountName,
      'real_name': realName,
      'day': day,
      'time': time,
    };
  }

  factory MyFeedback.fromMap(Map<String, dynamic> map) {
    return MyFeedback(
      map['id_feedback']?.toInt() ?? 0,
      map['id_account']?.toInt() ?? 0,
      map['subject'] ?? '',
      map['content'] ?? '',
      map['status']?.toInt() ?? 0,
      map['email'] ?? '',
      map['account_name'] ?? '',
      map['real_name'] ?? '',
      map['day'] ?? '',
      map['time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MyFeedback.fromJson(String source) =>
      MyFeedback.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Feedback(idFeedback: $idFeedback, idAccount: $idAccount, subject: $subject, content: $content, status: $status, email: $email, account_name: $accountName, real_name: $realName, day: $day, time: $time)';
  }
}
