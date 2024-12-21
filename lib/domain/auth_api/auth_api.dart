import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum ApiClientExeptionType { network, apiKey, other, emptyResponse }

class AuthApi {
  final Dio _client = Dio();
  final _host = dotenv.env['HOST'] ?? '';

  AuthApi();

  late final _authHost = '${_host}members/';

  Future<String?> login(String email, String password) async {
    try {
      final res = await _client.post(
        '${_authHost}login',
        queryParameters: {
          'email': email,
          'password': password,
        },
      );
      final String token = res.data['data'];
      return token;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
