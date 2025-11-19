import 'api_service.dart';

class DistributeurService extends ApiService {
  DistributeurService(String baseUrl) : super(baseUrl);

  // Lister tous les distributeurs
  Future<Map<String, dynamic>> getDistributeurs() async {
    return await get('/distributeurs');
  }
}