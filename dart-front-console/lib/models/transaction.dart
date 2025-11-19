import 'user.dart';

class Transaction {
  final String uuid;
  final String utilisateurUuid;
  final String type; // 'payer', 'transfert', 'depot'
  final double montant;
  final String description;
  final String? destinataireUuid;
  final String statut; // 'en_attente', 'confirmee', 'annulee'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relations (optionnelles, remplies par l'API)
  final User? destinataire;

  Transaction({
    required this.uuid,
    required this.utilisateurUuid,
    required this.type,
    required this.montant,
    required this.description,
    this.destinataireUuid,
    required this.statut,
    this.createdAt,
    this.updatedAt,
    this.destinataire,
  });

  // Constructeur depuis JSON (API response)
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      uuid: json['uuid'] ?? '',
      utilisateurUuid: json['utilisateur_uuid'] ?? '',
      type: json['type'] ?? '',
      montant: (json['montant'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      destinataireUuid: json['destinataire_uuid'],
      statut: json['statut'] ?? 'en_attente',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      destinataire: json['destinataire'] != null ? User.fromJson(json['destinataire']) : null,
    );
  }

  // Conversion vers JSON (pour les requêtes API)
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'utilisateur_uuid': utilisateurUuid,
      'type': type,
      'montant': montant,
      'description': description,
      if (destinataireUuid != null) 'destinataire_uuid': destinataireUuid,
      'statut': statut,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Méthodes utilitaires
  bool get isDebit => montant < 0;
  bool get isCredit => montant > 0;
  double get montantAbsolu => montant.abs();

  bool get isPayee => type == 'payer';
  bool get isTransfert => type == 'transfert';
  bool get isDepot => type == 'depot';

  bool get isEnAttente => statut == 'en_attente';
  bool get isConfirmee => statut == 'confirmee';
  bool get isAnnulee => statut == 'annulee';

  // Formatage pour affichage
  String get typeIcon {
    switch (type) {
      case 'payer':
        return '💳';
      case 'transfert':
        return '💸';
      case 'depot':
        return '📥';
      default:
        return '❓';
    }
  }

  String get montantFormatted {
    final sign = montant < 0 ? '' : '+';
    return '$sign${montant.toStringAsFixed(2)} FCFA';
  }

  // Copie avec modifications
  Transaction copyWith({
    String? uuid,
    String? utilisateurUuid,
    String? type,
    double? montant,
    String? description,
    String? destinataireUuid,
    String? statut,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? destinataire,
  }) {
    return Transaction(
      uuid: uuid ?? this.uuid,
      utilisateurUuid: utilisateurUuid ?? this.utilisateurUuid,
      type: type ?? this.type,
      montant: montant ?? this.montant,
      description: description ?? this.description,
      destinataireUuid: destinataireUuid ?? this.destinataireUuid,
      statut: statut ?? this.statut,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      destinataire: destinataire ?? this.destinataire,
    );
  }

  @override
  String toString() {
    return '$typeIcon $type: $montantFormatted - $description ($statut)';
  }
}