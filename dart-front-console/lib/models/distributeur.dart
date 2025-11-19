class Distributeur {
  final int id;
  final String nom;
  final String adresse;
  final String statut; // 'actif', 'inactif'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Distributeur({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.statut,
    this.createdAt,
    this.updatedAt,
  });

  // Constructeur depuis JSON (API response)
  factory Distributeur.fromJson(Map<String, dynamic> json) {
    return Distributeur(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      adresse: json['adresse'] ?? '',
      statut: json['statut'] ?? 'inactif',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Conversion vers JSON (pour les requêtes API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'adresse': adresse,
      'statut': statut,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Méthodes utilitaires
  bool get isActive => statut == 'actif';
  bool get isInactive => statut == 'inactif';

  // Formatage pour affichage
  String get displayInfo => '$nom - $adresse';

  // Copie avec modifications
  Distributeur copyWith({
    int? id,
    String? nom,
    String? adresse,
    String? statut,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Distributeur(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      adresse: adresse ?? this.adresse,
      statut: statut ?? this.statut,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return '🏪 $nom - $adresse (${isActive ? "Actif" : "Inactif"})';
  }
}