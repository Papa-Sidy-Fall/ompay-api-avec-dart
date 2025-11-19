// 📨 Modèles de requêtes pour les codes OTP
// Basés sur les formats Swagger de l'API OmPay

/// Requête de vérification de code OTP
class VerifyOtpRequest {
  final String telephone;
  final String code;
  final String type; // 'inscription', 'connexion', 'transaction'

  VerifyOtpRequest({
    required this.telephone,
    required this.code,
    required this.type,
  });

  // Validation selon Swagger
  bool get isValid =>
      telephone.trim().isNotEmpty &&
      code.trim().length == 4 &&
      RegExp(r'^\d{4}$').hasMatch(code) &&
      ['inscription', 'connexion', 'transaction'].contains(type);

  // Conversion vers JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'telephone': telephone.trim(),
      'code': code.trim(),
      'type': type,
    };
  }

  @override
  String toString() {
    return 'VerifyOtpRequest(telephone: $telephone, code: ****, type: $type)';
  }
}

/// Requête de renvoi de code OTP
class ResendOtpRequest {
  final String telephone;
  final String type; // 'inscription', 'connexion', 'transaction'

  ResendOtpRequest({
    required this.telephone,
    required this.type,
  });

  // Validation basique
  bool get isValid =>
      telephone.trim().isNotEmpty &&
      ['inscription', 'connexion', 'transaction'].contains(type);

  // Conversion vers JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'telephone': telephone.trim(),
      'type': type,
    };
  }

  @override
  String toString() {
    return 'ResendOtpRequest(telephone: $telephone, type: $type)';
  }
}