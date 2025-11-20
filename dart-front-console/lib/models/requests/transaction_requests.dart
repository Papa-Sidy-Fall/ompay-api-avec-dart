//  Modèles de requêtes pour les transactions
// Basés sur les formats Swagger de l'API OmPay

/// Requête de paiement (nécessite OTP)
class TransactionPayRequest {
  final double montant;
  final String description;

  TransactionPayRequest({
    required this.montant,
    required this.description,
  });

  // Validation selon Swagger
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
    return 'TransactionPayRequest(montant: $montant, description: $description)';
  }
}

/// Requête de transfert (nécessite OTP)
class TransactionTransferRequest {
  final double montant;
  final String destinataireUuid;
  final String description;

  TransactionTransferRequest({
    required this.montant,
    required this.destinataireUuid,
    required this.description,
  });

  // Validation selon Swagger
  bool get isValid =>
      montant > 0 &&
      destinataireUuid.trim().isNotEmpty &&
      description.trim().isNotEmpty;

  // Conversion vers JSON pour l'API
  Map<String, dynamic> toJson() {
    return {
      'montant': montant,
      'destinataire_uuid': destinataireUuid.trim(),
      'description': description.trim(),
    };
  }

  @override
  String toString() {
    return 'TransactionTransferRequest(montant: $montant, destinataireUuid: $destinataireUuid)';
  }
}

/// Requête de dépôt d'argent
class TransactionDepotRequest {
  final double montant;
  final String description;

  TransactionDepotRequest({
    required this.montant,
    required this.description,
  });

  // Validation selon Swagger
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
    return 'TransactionDepotRequest(montant: $montant, description: $description)';
  }
}