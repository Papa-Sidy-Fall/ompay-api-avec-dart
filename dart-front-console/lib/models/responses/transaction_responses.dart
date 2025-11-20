// Modèles de réponses pour les transactions
// Basés sur les formats Swagger de l'API OmPay

/// Réponse de paiement (nécessite OTP)
class TransactionPayResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  TransactionPayResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory TransactionPayResponse.fromJson(Map<String, dynamic> json) {
    return TransactionPayResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques au paiement
  String? get transactionId => donnees?['transaction_id'];

  double? get montant {
    final montantValue = donnees?['montant'];
    if (montantValue is double) return montantValue;
    if (montantValue is int) return montantValue.toDouble();
    if (montantValue is String) return double.tryParse(montantValue);
    return null;
  }

  String? get description => donnees?['description'];
  bool get otpRequired => donnees?['otp_required'] ?? false;
  DateTime? get expireAt => donnees?['expire_at'] != null
      ? DateTime.parse(donnees!['expire_at'])
      : null;

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;

  @override
  String toString() {
    return 'TransactionPayResponse(succes: $succes, message: $message, transactionId: $transactionId)';
  }
}

/// Réponse de transfert (nécessite OTP)
class TransactionTransferResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  TransactionTransferResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory TransactionTransferResponse.fromJson(Map<String, dynamic> json) {
    return TransactionTransferResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques au transfert
  String? get transactionId => donnees?['transaction_id'];

  double? get montant {
    final montantValue = donnees?['montant'];
    if (montantValue is double) return montantValue;
    if (montantValue is int) return montantValue.toDouble();
    if (montantValue is String) return double.tryParse(montantValue);
    return null;
  }

  String? get destinataireUuid => donnees?['destinataire_uuid'];
  String? get description => donnees?['description'];
  bool get otpRequired => donnees?['otp_required'] ?? false;
  DateTime? get expireAt => donnees?['expire_at'] != null
      ? DateTime.parse(donnees!['expire_at'])
      : null;

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;

  @override
  String toString() {
    return 'TransactionTransferResponse(succes: $succes, message: $message, transactionId: $transactionId)';
  }
}

/// Réponse de dépôt d'argent
class TransactionDepotResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  TransactionDepotResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory TransactionDepotResponse.fromJson(Map<String, dynamic> json) {
    return TransactionDepotResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques au dépôt
  double? get nouveauSolde {
    final soldeValue = donnees?['nouveau_solde'];
    if (soldeValue is double) return soldeValue;
    if (soldeValue is int) return soldeValue.toDouble();
    if (soldeValue is String) return double.tryParse(soldeValue);
    return null;
  }

  double? get montantDepose {
    final montantValue = donnees?['montant_depose'];
    if (montantValue is double) return montantValue;
    if (montantValue is int) return montantValue.toDouble();
    if (montantValue is String) return double.tryParse(montantValue);
    return null;
  }

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;

  @override
  String toString() {
    return 'TransactionDepotResponse(succes: $succes, message: $message, nouveauSolde: $nouveauSolde)';
  }
}

/// Réponse de liste des transactions
class TransactionListResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  TransactionListResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory TransactionListResponse.fromJson(Map<String, dynamic> json) {
    return TransactionListResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques à la liste
  List<Map<String, dynamic>> get transactions =>
      List<Map<String, dynamic>>.from(donnees?['transactions'] ?? []);

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;
  bool get hasTransactions => transactions.isNotEmpty;

  @override
  String toString() {
    return 'TransactionListResponse(succes: $succes, message: $message, count: ${transactions.length})';
  }
}

/// Réponse de détail d'une transaction
class TransactionDetailResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  TransactionDetailResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory TransactionDetailResponse.fromJson(Map<String, dynamic> json) {
    return TransactionDetailResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques à la transaction
  Map<String, dynamic>? get transaction => donnees?['transaction'];

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;
  bool get hasTransaction => transaction != null;

  @override
  String toString() {
    return 'TransactionDetailResponse(succes: $succes, message: $message, hasTransaction: $hasTransaction)';
  }
}