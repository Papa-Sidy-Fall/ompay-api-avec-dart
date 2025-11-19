// 📥 Modèles de réponses pour les codes OTP
// Basés sur les formats Swagger de l'API OmPay

import '../user.dart';

/// Réponse de vérification de code OTP
class VerifyOtpResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  VerifyOtpResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques à la vérification OTP
  String? get telephone => donnees?['telephone'];
  String? get type => donnees?['type'];
  bool get verifie => donnees?['verifie'] ?? false;
  bool get utilisateurExiste => donnees?['utilisateur_existe'] ?? false;

  User? get utilisateur => donnees?['utilisateur'] != null
      ? User.fromJson(donnees!['utilisateur'])
      : null;

  String? get token => donnees?['token'];

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;
  bool get hasToken => token != null && token!.isNotEmpty;

  @override
  String toString() {
    return 'VerifyOtpResponse(succes: $succes, message: $message, verifie: $verifie, hasToken: $hasToken)';
  }
}

/// Réponse d'envoi de code OTP
class SendOtpResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  SendOtpResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques à l'envoi OTP
  DateTime? get expireAt => donnees?['expire_at'] != null
      ? DateTime.parse(donnees!['expire_at'])
      : null;

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;

  @override
  String toString() {
    return 'SendOtpResponse(succes: $succes, message: $message, expireAt: $expireAt)';
  }
}

/// Réponse de renvoi de code OTP
class ResendOtpResponse extends SendOtpResponse {
  ResendOtpResponse({
    required bool succes,
    required String message,
    Map<String, dynamic>? donnees,
    Map<String, dynamic>? erreurs,
  }) : super(succes: succes, message: message, donnees: donnees, erreurs: erreurs);

  // Constructeur depuis JSON
  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  @override
  String toString() {
    return 'ResendOtpResponse(succes: $succes, message: $message, expireAt: $expireAt)';
  }
}