import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:it_news/core/constants/strings.dart';
import 'package:it_news/data/models/tag.dart';

class TagRepository {
  final http.Client httpClient;

  TagRepository({required this.httpClient});

  get idPost => null;

  Future<List<Tag>?> getAllTags(int idAccount) async {
    final url = Uri.parse(Strings.baseURL + "tag/$idAccount/all");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<Tag> tags =
          (body['data'] as List).map((tag) => Tag.fromMap(tag)).toList();
      return tags;
    }
  }

  Future<http.Response> followTag(int idTag) async {
    final url = Uri.parse(Strings.baseURL + "follow_tag/$idTag");
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    return response;
  }

  Future<http.Response> unFollowTag(int idTag) async {
    final url = Uri.parse(Strings.baseURL + "follow_tag/$idTag");
    var response = await http.delete(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    return response;
  }
}
