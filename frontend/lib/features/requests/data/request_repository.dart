import '../../../core/network/api_client.dart';

class RequestRepository {
  Future<List<dynamic>> getMyRequests() async {
    final response = await ApiClient.dio.get('/requests/my');
    return response.data['requests'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createRequest(Map<String, dynamic> data) async {
    final response = await ApiClient.dio.post('/requests', data: data);
    return response.data;
  }
}
