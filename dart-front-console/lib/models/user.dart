class User {
  final int id;
  final String uuid;
  final String nom;
  final String telephone;
  final String? email;
  final String statut;
  final double solde;
  final String? qrCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.uuid,
    required this.nom,
    required this.telephone,
    this.email,
    required this.statut,
    required this.solde,
    this.qrCode,
    this.createdAt,
    this.updatedAt,
  });

  // Constructeur depuis JSON (API response)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      nom: json['nom'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'],
      statut: json['statut'] ?? 'inactif',
      solde: (json['solde'] ?? 0).toDouble(),
      qrCode: json['qr_code'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Conversion vers JSON (pour les requêtes API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'nom': nom,
      'telephone': telephone,
      if (email != null) 'email': email,
      'statut': statut,
      'solde': solde,
      if (qrCode != null) 'qr_code': qrCode,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Méthodes utilitaires
  bool get isActive => statut == 'actif';
  bool get isInactive => statut == 'inactif';
  bool get isAdmin => statut == 'admin';

  // Copie avec modifications
  User copyWith({
    int? id,
    String? uuid,
    String? nom,
    String? telephone,
    String? email,
    String? statut,
    double? solde,
    String? qrCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      nom: nom ?? this.nom,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      statut: statut ?? this.statut,
      solde: solde ?? this.solde,
      qrCode: qrCode ?? this.qrCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, nom: $nom, telephone: $telephone, statut: $statut, solde: $solde)';
  }
}