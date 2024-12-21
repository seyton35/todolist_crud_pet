import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todos_crud_pet/domain/auth_api/auth_api.dart';
import 'package:todos_crud_pet/domain/sharedPreferencesApi/shared_preferences_api.dart';

class AuthRepository {
  final _authApi = AuthApi();
  final SharedPreferencesApi _shaPrefApi;
  final FlutterSecureStorage _secureStorage;
  String? jwt;

  AuthRepository(
      {required FlutterSecureStorage secureStorage,
      required SharedPreferencesApi sharedPreferencesApi})
      : _secureStorage = secureStorage,
        _shaPrefApi = sharedPreferencesApi;

  Future<String?> login(String email, String password) async {
    try {
      final token = await _authApi.login(email, password);
      if (token == null) return null;
      jwt = token;
      _secureStorage.write(key: 'jwt', value: token);
      return token;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt');
    jwt = null;
    _shaPrefApi.removeValue(SharedPreferencesKeys.archivedTodos);
  }

  Future<void> getJwt() async {
    jwt = await _secureStorage.read(key: 'jwt');
  }
}
