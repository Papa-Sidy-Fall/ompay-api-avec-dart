import '../models/models.dart';
import 'api_service.dart';

class DistributeurService extends ApiService {
  DistributeurService(String baseUrl) : super(baseUrl);

  // Lister tous les distributeurs
  Future<DistributeursResponse> getDistributeurs() async {
    final rawResponse = await get('/distributeurs');
    return DistributeursResponse.fromJson(rawResponse);
  }
}