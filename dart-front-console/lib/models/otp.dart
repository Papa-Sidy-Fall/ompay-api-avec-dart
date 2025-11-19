class Otp {
  final int id;
  final String telephone;
  final String code;
  final String type; // 'inscription', 'connexion', 'transaction'
  final DateTime expireAt;
  final bool utilise;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Otp({
    required this.id,
    required this.telephone,
    required this.code,
    required this.type,
    required this.expireAt,
    required this.utilise,
    this.createdAt,
    this.updatedAt,
  });

  // Constructeur depuis JSON (API response)
  factory Otp.fromJson(Map<String, dynamic> json) {
    return Otp(
      id: json['id'] ?? 0,
      telephone: json['telephone'] ?? '',
      code: json['code'] ?? '',
      type: json['type'] ?? '',
      expireAt: DateTime.parse(json['expire_at'] ?? DateTime.now().toIso8601String()),
      utilise: json['utilise'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // Conversion vers JSON (pour les requêtes API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'telephone': telephone,
      'code': code,
      'type': type,
      'expire_at': expireAt.toIso8601String(),
      'utilise': utilise,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Méthodes utilitaires
  bool get isExpired => DateTime.now().isAfter(expireAt);
  bool get isValid => !utilise && !isExpired;

  Duration get timeRemaining => expireAt.difference(DateTime.now());
  bool get hasTimeRemaining => timeRemaining > Duration.zero;

  String get timeRemainingFormatted {
    if (!hasTimeRemaining) return 'Expiré';
    final minutes = timeRemaining.inMinutes;
    final seconds = timeRemaining.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  bool get isInscription => type == 'inscription';
  bool get isConnexion => type == 'connexion';
  bool get isTransaction => type == 'transaction';

  // Formatage pour affichage
  String get typeLabel {
    switch (type) {
      case 'inscription':
        return 'Inscription';
      case 'connexion':
        return 'Connexion';
      case 'transaction':
        return 'Transaction';
      default:
        return type;
    }
  }

  String get statusLabel {
    if (utilise) return 'Utilisé';
    if (isExpired) return 'Expiré';
    return 'Valide (${timeRemainingFormatted})';
  }

  // Copie avec modifications
  Otp copyWith({
    int? id,
    String? telephone,
    String? code,
    String? type,
    DateTime? expireAt,
    bool? utilise,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Otp(
      id: id ?? this.id,
      telephone: telephone ?? this.telephone,
      code: code ?? this.code,
      type: type ?? this.type,
      expireAt: expireAt ?? this.expireAt,
      utilise: utilise ?? this.utilise,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'OTP($telephone, $typeLabel, $statusLabel)';
  }
}