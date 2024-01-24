import 'package:shared_preferences/shared_preferences.dart';

class AppLocalDataSource {
  final SharedPreferences _sharedPreferences;

  AppLocalDataSource(this._sharedPreferences);

  Future<String?> getFcmToken() async {
    return _sharedPreferences.getString("fcm_token");
  }

  Future<bool> setFcmToken(String token) async {
    return await _sharedPreferences.setString("fcm_token", token);
  }
}
