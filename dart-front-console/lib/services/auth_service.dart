import '../models/models.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  AuthService(String baseUrl) : super(baseUrl);

  // Inscription d'un utilisateur avec modèle de requête
  Future<RegisterResponse> register(RegisterRequest request) async {
    final rawResponse = await post('/auth/register', request.toJson());
    return RegisterResponse.fromJson(rawResponse);
  }

  // Connexion d'un utilisateur avec modèle de requête
  Future<LoginResponse> login(LoginRequest request) async {
    final rawResponse = await post('/auth/login', request.toJson());
    return LoginResponse.fromJson(rawResponse);
  }
}