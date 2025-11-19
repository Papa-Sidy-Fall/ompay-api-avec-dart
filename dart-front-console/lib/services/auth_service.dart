import 'api_service.dart';

class AuthService extends ApiService {
  AuthService(String baseUrl) : super(baseUrl);

  // Inscription d'un utilisateur
  Future<Map<String, dynamic>> register({
    required String nom,
    required String telephone,
    required String pin,
  }) async {
    return await post('/auth/register', {
      'nom': nom,
      'telephone': telephone,
      'pin': pin,
    });
  }

  // Connexion d'un utilisateur
  Future<Map<String, dynamic>> login({
    required String telephone,
    required String pin,
  }) async {
    return await post('/auth/login', {
      'telephone': telephone,
      'pin': pin,
    });
  }
}