import '../../../core/network/api_client.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiClient.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    final response = await ApiClient.dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'name': name,
    });
    return response.data;
  }
}
