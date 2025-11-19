// 📨 Modèles de requêtes pour l'authentification
// Basés sur les formats Swagger de l'API OmPay

/// Requête d'inscription utilisateur
class RegisterRequest {
  final String nom;
  final String telephone;
  final String pin;

  RegisterRequest({
    required this.nom,
    required this.telephone,
    required this.pin,
  });

  // Validation basique
  bool get isValid =>
      nom.trim().isNotEmpty &&
      telephone.trim().isNotEmpty &&
      pin.trim().length == 4 &&
      RegExp(r'^\d{4}$').hasMatch(pin);

  // Conversion vers JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'nom': nom.trim(),
      'telephone': telephone.trim(),
      'pin': pin.trim(),
    };
  }

  @override
  String toString() {
    return 'RegisterRequest(nom: $nom, telephone: $telephone, pin: ****)';
  }
}

/// Requête de connexion utilisateur
class LoginRequest {
  final String telephone;
  final String pin;

  LoginRequest({
    required this.telephone,
    required this.pin,
  });

  // Validation basique
  bool get isValid =>
      telephone.trim().isNotEmpty &&
      pin.trim().length == 4 &&
      RegExp(r'^\d{4}$').hasMatch(pin);

  // Conversion vers JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'telephone': telephone.trim(),
      'pin': pin.trim(),
    };
  }

  @override
  String toString() {
    return 'LoginRequest(telephone: $telephone, pin: ****)';
  }
}