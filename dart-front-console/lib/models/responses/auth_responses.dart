//  Modèles de réponses pour l'authentification
// Basés sur les formats Swagger de l'API OmPay

import '../user.dart';

/// Réponse de base API (commune à toutes les réponses)
class ApiResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  ApiResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON (API response)
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;
  bool get hasData => donnees != null;

  @override
  String toString() {
    return 'ApiResponse(succes: $succes, message: $message, hasData: $hasData, hasErrors: $hasErrors)';
  }
}

/// Réponse d'inscription utilisateur
class RegisterResponse extends ApiResponse {
  RegisterResponse({
    required bool succes,
    required String message,
    Map<String, dynamic>? donnees,
    Map<String, dynamic>? erreurs,
  }) : super(succes: succes, message: message, donnees: donnees, erreurs: erreurs);

  // Constructeur depuis JSON
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques à l'inscription
  User? get utilisateur => donnees?['utilisateur'] != null
      ? User.fromJson(donnees!['utilisateur'])
      : null;

  String? get messageComplementaire => donnees?['message_complementaire'];

  @override
  String toString() {
    return 'RegisterResponse(succes: $succes, message: $message, utilisateur: ${utilisateur?.nom ?? 'null'})';
  }
}

/// Réponse de connexion utilisateur
class LoginResponse extends ApiResponse {
  LoginResponse({
    required bool succes,
    required String message,
    Map<String, dynamic>? donnees,
    Map<String, dynamic>? erreurs,
  }) : super(succes: succes, message: message, donnees: donnees, erreurs: erreurs);

  // Constructeur depuis JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques à la connexion
  User? get utilisateur => donnees?['utilisateur'] != null
      ? User.fromJson(donnees!['utilisateur'])
      : null;

  String? get messageComplementaire => donnees?['message_complementaire'];

  @override
  String toString() {
    return 'LoginResponse(succes: $succes, message: $message, utilisateur: ${utilisateur?.nom ?? 'null'})';
  }
}