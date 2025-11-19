import 'auth_service.dart';
import 'otp_service.dart';
import 'compte_service.dart';
import 'transaction_service.dart';
import 'distributeur_service.dart';

class ApiClient {
  final String baseUrl;
  late final AuthService auth;
  late final OtpService otp;
  late final CompteService compte;
  late final TransactionService transaction;
  late final DistributeurService distributeur;

  ApiClient(this.baseUrl) {
    auth = AuthService(baseUrl);
    otp = OtpService(baseUrl);
    compte = CompteService(baseUrl);
    transaction = TransactionService(baseUrl);
    distributeur = DistributeurService(baseUrl);
  }

  // Méthode pour définir le token sur tous les services
  void setToken(String token) {
    auth.setToken(token);
    otp.setToken(token);
    compte.setToken(token);
    transaction.setToken(token);
    distributeur.setToken(token);
  }

  // Méthode pour vérifier si un token est défini
  bool hasToken() {
    return auth.token != null;
  }
}