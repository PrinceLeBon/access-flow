import '../../../core/network/api_client.dart';

class AdminRepository {
  Future<List<dynamic>> getAllRequests() async {
    final response = await ApiClient.dio.get('/requests');
    return response.data['requests'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> updateRequest(
      String id, Map<String, dynamic> data) async {
    final response = await ApiClient.dio.patch('/requests/$id', data: data);
    return response.data;
  }
}
