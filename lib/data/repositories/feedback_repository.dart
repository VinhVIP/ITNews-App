import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:it_news/core/constants/strings.dart';
import 'package:it_news/data/models/feedback.dart';

class FeedbackRepository {
  final http.Client httpClient;

  FeedbackRepository(this.httpClient);

  Future<List<MyFeedback>?> getAllFeedbacks() async {
    final url = Uri.parse(Strings.baseURL + "feedback/all");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<MyFeedback> feedbacks = (body['data'] as List)
          .map((feedback) => MyFeedback.fromMap(feedback))
          .toList();
      return feedbacks;
    }
  }

  Future<MyFeedback?> getFeedback(int idFeedback) async {
    final url = Uri.parse(Strings.baseURL + "feedback/$idFeedback");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final MyFeedback feedback = MyFeedback.fromMap(body['data']);
      return feedback;
    }
  }

  Future<http.Response> readFeedback(int idFeedback) async {
    final url = Uri.parse(Strings.baseURL + "feedback/$idFeedback/read");
    var response = await http.put(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }

  Future<http.Response> deletFeedback(int idFeedback) async {
    final url = Uri.parse(Strings.baseURL + "feedback/$idFeedback");
    var response = await http.delete(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }
}
