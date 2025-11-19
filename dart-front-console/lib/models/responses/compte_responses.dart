// 📥 Modèles de réponses pour les opérations de compte
// Basés sur les formats Swagger de l'API OmPay

/// Réponse d'informations du compte
class CompteInfoResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  CompteInfoResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory CompteInfoResponse.fromJson(Map<String, dynamic> json) {
    return CompteInfoResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques au compte
  Map<String, dynamic>? get utilisateur => donnees?['utilisateur'];
  double get solde => donnees?['solde'] ?? 0.0;
  String? get qrCode => donnees?['qr_code'];

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;

  @override
  String toString() {
    return 'CompteInfoResponse(succes: $succes, message: $message, solde: $solde)';
  }
}

/// Réponse de solde du compte
class SoldeResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  SoldeResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory SoldeResponse.fromJson(Map<String, dynamic> json) {
    return SoldeResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques au solde
  double get solde => donnees?['solde'] ?? 0.0;

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;

  @override
  String toString() {
    return 'SoldeResponse(succes: $succes, message: $message, solde: $solde)';
  }
}

/// Réponse de paiement marchand
class PayResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  PayResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory PayResponse.fromJson(Map<String, dynamic> json) {
    return PayResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques au paiement
  String get type => donnees?['type'] ?? '';
  double get montant => donnees?['montant'] ?? 0.0;
  String get marchand => donnees?['marchand'] ?? '';
  double get nouveauSolde => donnees?['nouveau_solde'] ?? 0.0;

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;

  @override
  String toString() {
    return 'PayResponse(succes: $succes, message: $message, montant: $montant, nouveauSolde: $nouveauSolde)';
  }
}

/// Réponse de transfert d'argent
class TransferResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  TransferResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory TransferResponse.fromJson(Map<String, dynamic> json) {
    return TransferResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques au transfert
  String get type => donnees?['type'] ?? '';
  double get montant => donnees?['montant'] ?? 0.0;
  String get destinataire => donnees?['destinataire'] ?? '';
  String get numeroDestinataire => donnees?['numero_destinataire'] ?? '';
  double get nouveauSolde => donnees?['nouveau_solde'] ?? 0.0;

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;

  @override
  String toString() {
    return 'TransferResponse(succes: $succes, message: $message, montant: $montant, destinataire: $destinataire)';
  }
}

/// Réponse de liste des transactions
class TransactionsResponse {
  final bool succes;
  final String message;
  final Map<String, dynamic>? donnees;
  final Map<String, dynamic>? erreurs;

  TransactionsResponse({
    required this.succes,
    required this.message,
    this.donnees,
    this.erreurs,
  });

  // Constructeur depuis JSON
  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsResponse(
      succes: json['succes'] ?? false,
      message: json['message'] ?? '',
      donnees: json['donnees'],
      erreurs: json['erreurs'],
    );
  }

  // Données spécifiques aux transactions
  List<Map<String, dynamic>> get transactions =>
      List<Map<String, dynamic>>.from(donnees?['transactions'] ?? []);

  Map<String, dynamic>? get pagination => donnees?['pagination'];

  // Informations de pagination
  int get currentPage => pagination?['current_page'] ?? 1;
  int get perPage => pagination?['per_page'] ?? 15;
  int get total => pagination?['total'] ?? 0;
  int get lastPage => pagination?['last_page'] ?? 1;

  // Vérifications de statut
  bool get isSuccess => succes;
  bool get hasErrors => erreurs != null && erreurs!.isNotEmpty;
  bool get hasTransactions => transactions.isNotEmpty;

  @override
  String toString() {
    return 'TransactionsResponse(succes: $succes, message: $message, count: ${transactions.length})';
  }
}