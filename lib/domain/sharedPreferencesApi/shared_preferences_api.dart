import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesKeys {
  static const archivedTodos = 'arcived_todos_list';
}

class SharedPreferencesApi {
  final SharedPreferences _shaPref;

  SharedPreferencesApi({required SharedPreferences shaPref})
      : _shaPref = shaPref;

  String? getValue(String key) => _shaPref.getString(key);

  Future<void> setValut(String key, String value) =>
      _shaPref.setString(key, value);

  Future<bool> removeValue(String key) => _shaPref.remove(key);
}
