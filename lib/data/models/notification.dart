import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:markdown_widget/markdown_helper.dart';

class Notifications extends Equatable {
  static const Notifications empty = Notifications();

  final int idNotification;
  final int idAccount;
  final String content;
  final String link;
  final int status;
  final String notificationTime;

  const Notifications({
    this.idNotification = 0,
    this.idAccount = 0,
    this.content = "",
    this.link = "",
    this.status = 0,
    this.notificationTime = "",
  });

  @override
  List<Object> get props {
    return [
      idNotification,
      idAccount,
      content,
      link,
      status,
      notificationTime,
    ];
  }

  Notifications copyWith({
    int? idNotification,
    int? idAccount,
    String? content,
    String? link,
    int? status,
    String? notificationTime,
  }) {
    return Notifications(
      idNotification: idNotification ?? this.idNotification,
      idAccount: idAccount ?? this.idAccount,
      content: content ?? this.content,
      link: link ?? this.link,
      status: status ?? this.status,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_notification': idNotification,
      'id_account': idAccount,
      'content': content,
      'link': link,
      'status': status,
      'notification_time': notificationTime,
    };
  }

  factory Notifications.fromMap(Map<String, dynamic> map) {
    return Notifications(
      idNotification: map['id_notification']?.toInt() ?? 0,
      idAccount: map['id_account']?.toInt() ?? 0,
      content: map['content'] ?? '',
      link: map['link'] ?? '',
      status: map['status']?.toInt() ?? 0,
      notificationTime: map['notification_time'] != null
          ? Utils.convertDatetime(map['notification_time'])
          : "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Notifications.fromJson(String source) =>
      Notifications.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Notification(idNotification: $idNotification, idAccount: $idAccount, content: $content, status: $status, notificationTime: $notificationTime)';
  }
}
