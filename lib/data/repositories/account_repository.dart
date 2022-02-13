import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:it_news/core/constants/strings.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/data/store/shared_preferences.dart';

enum AuthenStatus { unknown, authenticated, unauthenticated }

class AccountRepository {
  final http.Client httpClient;
  final _controllerStatus = StreamController<AuthenStatus>();

  AccountRepository({required this.httpClient});

  Stream<AuthenStatus> get status async* {
    final logged = await LocalStorage.isLogged();
    if (!logged) {
      yield AuthenStatus.unauthenticated;
    } else {
      final username = await LocalStorage.getAccountName();
      final password = await LocalStorage.getPassword();

      final response = await login(username: username, password: password);
      if (response?.statusCode == 200) {
        yield AuthenStatus.authenticated;
      } else {
        yield AuthenStatus.unauthenticated;
      }
    }

    yield* _controllerStatus.stream;
  }

  Future<http.Response?> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse(Strings.baseURL + "account/login");
    var response = await http.post(url, body: {
      'account_name': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      LocalStorage.set(
          key: 'id_account', value: body['data']['id_account'] as int);
      LocalStorage.set(
        key: 'account_name',
        value: body['data']['account_name'],
      );
      LocalStorage.set(
        key: 'password',
        value: password,
      );
      LocalStorage.set(key: 'accessToken', value: body['accessToken']);
      print("token: " + body['accessToken']);
      Strings.accessToken = body['accessToken'];

      // Lưu trạng thái đăng nhập
      LocalStorage.set(key: 'logged', value: true);

      _controllerStatus.add(AuthenStatus.authenticated);
      return response;
    } else {
      _controllerStatus.add(AuthenStatus.unauthenticated);
    }
  }

  Future<http.Response?> signup({
    required String accountName,
    required String realName,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Strings.baseURL + "account/");
    var response = await http.post(url, body: {
      'account_name': accountName,
      'real_name': realName,
      'email': email,
      'password': password,
    });

    return response;
  }

  void logout() {
    _controllerStatus.add(AuthenStatus.unauthenticated);
  }

  Future<User?> getUser({required int idAccount}) async {
    final url = Uri.parse(Strings.baseURL + "account/$idAccount");
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${Strings.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      User user = User.fromMap(body['data']);
      // print(user);
      // Utils.user = user;
      return user;
    }
  }

  Future<http.Response> updateProfile({
    String realName = "",
    String birth = "",
    int gender = 0,
    String phone = "",
    String company = "",
  }) async {
    final url = Uri.parse(Strings.baseURL + "account/change/information");
    var response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${Strings.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'real_name': realName,
        'birth': birth,
        'gender': gender,
        'phone': phone,
        'company': company,
        'avatar': Utils.user.avatar,
      }),
    );

    if (response.statusCode == 200) {
      // final body = json.decode(response.body);
      // User updateUser = User.fromMap(body['data']);
      // Utils.user = Utils.user.copyWith(
      //   realName: updateUser.realName,
      //   birth: updateUser.birth,
      //   gender: updateUser.gender,
      //   phone: updateUser.phone,
      //   company: updateUser.company,
      // );

      // print(Utils.user);
      Utils.user = (await getUser(idAccount: Utils.user.idAccount))!;
    }

    return response;
  }

  Future<http.Response> changePassword(String oldPass, String newPass) async {
    final url = Uri.parse(Strings.baseURL + "account/change/password");
    var response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${Strings.accessToken}',
      },
      body: {
        'old_password': oldPass,
        'new_password': newPass,
      },
    );

    if (response.statusCode == 200) {
      LocalStorage.set(
        key: 'password',
        value: newPass,
      );
    }

    return response;
  }

  Future<List<User>?> getAllAuthors() async {
    final url = Uri.parse(Strings.baseURL + "account/all");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<User> authors =
          (body['data'] as List).map((author) => User.fromMap(author)).toList();
      return authors;
    }
  }

  Future<List<User>?> search(
      {required String keyword, required int page}) async {
    final url =
        Uri.parse(Strings.baseURL + "account/search?k=$keyword&page=$page");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<User> authors =
          (body['data'] as List).map((author) => User.fromMap(author)).toList();
      return authors;
    }
  }

  Future<http.Response> followAccount(int idAccount) async {
    final url = Uri.parse(Strings.baseURL + "follow_account/$idAccount");
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    return response;
  }

  Future<http.Response> unFollowAccount(int idAccount) async {
    final url = Uri.parse(Strings.baseURL + "follow_account/$idAccount");
    var response = await http.delete(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    return response;
  }

  Future<List<User>?> getFollowers(int idAccount) async {
    final url = Uri.parse(Strings.baseURL + "account/$idAccount/follower");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<User> authors =
          (body['data'] as List).map((author) => User.fromMap(author)).toList();
      return authors;
    }
  }

  Future<List<User>?> getFollowings(int idAccount) async {
    final url = Uri.parse(Strings.baseURL + "account/$idAccount/following");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<User> authors =
          (body['data'] as List).map((author) => User.fromMap(author)).toList();
      return authors;
    }
  }

  Future<http.Response> changeRole(int idAccount, int idRole) async {
    final url = Uri.parse(Strings.baseURL + "account/$idAccount/role/$idRole");
    var response = await http.put(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }

  Future<http.Response> lockTime(
      int idAccount, String reason, int hoursLock) async {
    final url = Uri.parse(Strings.baseURL + "account/$idAccount/ban");
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    }, body: {
      'reason': reason,
      'hours_lock': hoursLock.toString()
    });
    return response;
  }

  Future<http.Response> lockForever(int idAccount, String reason) async {
    final url = Uri.parse(Strings.baseURL + "account/$idAccount/die");
    var response = await http.patch(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    }, body: {
      'reason': reason,
    });
    return response;
  }

  Future<http.Response> unlock(int idAccount) async {
    final url = Uri.parse(Strings.baseURL + "account/$idAccount/revive");
    var response = await http.patch(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }

  void dispose() {
    _controllerStatus.close();
  }
}
