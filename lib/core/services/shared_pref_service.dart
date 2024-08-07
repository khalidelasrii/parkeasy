import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String firstUse = 'FIRST_USE';
  static const String appMode = 'APP_MODE';
  static const String appLang = 'app_lang';
  late final SharedPreferences _pref;

  SharedPrefService(this._pref);

  static Future<SharedPrefService> initializeService() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return SharedPrefService(pref);
  }

  void putValue(String key, dynamic value) {
    switch (value) {
      case int():
        _pref.setInt(key, value);
      case bool():
        _pref.setBool(key, value);
      case String():
        _pref.setString(key, value);
      case double():
        _pref.setDouble(key, value);
      default:
        throw Exception('Unhandled type: ${value.runtimeType}');
    }
  }

  T getValue<T>(String key, T defVal) {
    return ((_pref.get(key) ?? defVal) as T);
  }

  bool contains(String key) {
    return _pref.containsKey(key);
  }

  void removeRecord(String key) {
    if (contains(key)) {
      _pref.remove(key);
    }
  }
}
