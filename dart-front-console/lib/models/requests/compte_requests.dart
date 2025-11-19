// 📨 Modèles de requêtes pour les opérations de compte
// Basés sur les formats Swagger de l'API OmPay

/// Requête de paiement marchand
class PayRequest {
  final double montant;
  final String codeMarchand;

  PayRequest({
    required this.montant,
    required this.codeMarchand,
  });

  // Validation selon Swagger
  bool get isValid =>
      montant > 0 &&
      codeMarchand.trim().isNotEmpty;

  // Conversion vers JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'montant': montant,
      'code_marchand': codeMarchand.trim(),
    };
  }

  @override
  String toString() {
    return 'PayRequest(montant: $montant, codeMarchand: $codeMarchand)';
  }
}

/// Requête de transfert d'argent
class TransferRequest {
  final double montant;
  final String numeroDestinataire;

  TransferRequest({
    required this.montant,
    required this.numeroDestinataire,
  });

  // Validation selon Swagger
  bool get isValid =>
      montant > 0 &&
      numeroDestinataire.trim().isNotEmpty;

  // Conversion vers JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'montant': montant,
      'numero_destinataire': numeroDestinataire.trim(),
    };
  }

  @override
  String toString() {
    return 'TransferRequest(montant: $montant, numeroDestinataire: $numeroDestinataire)';
  }
}

/// Requête de dépôt d'argent
class DepotRequest {
  final double montant;
  final String description;

  DepotRequest({
    required this.montant,
    required this.description,
  });

  // Validation basique
  bool get isValid =>
      montant > 0 &&
      description.trim().isNotEmpty;

  // Conversion vers JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'montant': montant,
      'description': description.trim(),
    };
  }

  @override
  String toString() {
    return 'DepotRequest(montant: $montant, description: $description)';
  }
}