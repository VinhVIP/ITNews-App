import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:it_news/core/constants/strings.dart';
import 'package:it_news/data/models/tag.dart';

class TagRepository {
  final http.Client httpClient;

  TagRepository({required this.httpClient});

  get idPost => null;

  Future<List<Tag>?> getAllTags(int idAccount) async {
    final url = Uri.parse(Strings.baseURL + "tag/all");
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

  Future<List<Tag>?> getTags() async {
    final url = Uri.parse(Strings.baseURL + "tag/all");
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

  Future<List<Tag>?> getSearch(String keyword) async {
    final url = Uri.parse(Strings.baseURL + "tag/search?k=$keyword");
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

  Future<List<Tag>?> getFolowingTags(int idAccount) async {
    final url = Uri.parse(Strings.baseURL + "account/$idAccount/follow_tag");
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

  Future<http.StreamedResponse> addTag(String name, File logo) async {
    var uri = Uri.parse(Strings.baseURL + "tag");
    var request = http.MultipartRequest("POST", uri);

    request.headers.addAll({
      'Authorization': 'Bearer ${Strings.accessToken}',
      'Content-Type': 'application/json',
    });

    if (logo != null) {
      var stream = http.ByteStream(DelegatingStream.typed(logo.openRead()));
      var length = await logo.length();

      var multipartFile = http.MultipartFile('logo', stream, length,
          filename: basename(logo.path));

      request.files.add(multipartFile);
    }

    request.fields['name'] = name;

    // send
    var response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> updateTag(int idTag, String name,
      {File? logo}) async {
    var uri = Uri.parse(Strings.baseURL + "tag/$idTag");
    var request = http.MultipartRequest("PUT", uri);

    request.headers.addAll({
      'Authorization': 'Bearer ${Strings.accessToken}',
      'Content-Type': 'application/json',
    });

    if (logo != null) {
      var stream = http.ByteStream(DelegatingStream.typed(logo.openRead()));
      var length = await logo.length();

      var multipartFile = http.MultipartFile('logo', stream, length,
          filename: basename(logo.path));

      request.files.add(multipartFile);
    }

    request.fields['name'] = name;

    // send
    var response = await request.send();

    return response;
  }

  Future<http.Response> deleteTag(int idTag) async {
    final url = Uri.parse(Strings.baseURL + "tag/$idTag");
    var response = await http.delete(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    return response;
  }
}
