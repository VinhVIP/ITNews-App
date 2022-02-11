import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:it_news/core/constants/strings.dart';
import 'package:it_news/data/models/notification.dart';

class NotificationRepository {
  final http.Client httpClient;

  NotificationRepository(this.httpClient);

  Future<List<Notifications>?> getNotifications() async {
    final url = Uri.parse(Strings.baseURL + "notification/list");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<Notifications> notifications = (body['data'] as List)
          .map((notification) => Notifications.fromMap(notification))
          .toList();
      return notifications;
    }
  }

  Future<int> countUnreadNotification() async {
    final url = Uri.parse(Strings.baseURL + "notification/count");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final count = int.parse(body['data']);
      return count;
    }
    return 0;
  }

  Future<http.Response> readNotification(int idNotification) async {
    final url =
        Uri.parse(Strings.baseURL + "notification/$idNotification/read");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }

  Future<http.Response> deleteNotification(int idNotification) async {
    final url = Uri.parse(Strings.baseURL + "notification/$idNotification");
    var response = await http.delete(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }

  Future<http.Response> readAllNotification() async {
    final url = Uri.parse(Strings.baseURL + "notification/read_all");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }

  Future<http.Response> deleteAllNotification() async {
    final url = Uri.parse(Strings.baseURL + "notification/delete_all");
    var response = await http.delete(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }
}
