import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // final Future<SharedPreferences> _prefsInstance =
  //     SharedPreferences.getInstance();

  static Future<void> set({required String key, required dynamic value}) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    }
  }

  static Object? get({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static Future<int> getIdAccount() async {
    final prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id_account');
    if (id == null) {
      return 0;
    } else {
      return id;
    }
  }

  static Future<String> getAccountName() async {
    final prefs = await SharedPreferences.getInstance();
    String? accountName = prefs.getString('account_name');
    if (accountName == null) {
      return "";
    } else {
      return accountName;
    }
  }

  static Future<String> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    String? password = prefs.getString('password');
    if (password == null) {
      return "";
    } else {
      return password;
    }
  }
}
