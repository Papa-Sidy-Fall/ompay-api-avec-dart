//  Modèle pour gérer le solde du compte utilisateur
// Le solde est calculé dynamiquement par l'API OmPay en sommant toutes les transactions

class Solde {
  final double montant;
  final String devise;
  final DateTime derniereMiseAJour;
  final int nombreTransactions;

  Solde({
    required this.montant,
    this.devise = 'FCFA',
    DateTime? derniereMiseAJour,
    this.nombreTransactions = 0,
  }) : derniereMiseAJour = derniereMiseAJour ?? DateTime.now();

  // Constructeur depuis JSON (API response)
  factory Solde.fromJson(Map<String, dynamic> json) {
    return Solde(
      montant: (json['solde'] ?? json['montant'] ?? 0).toDouble(),
      devise: json['devise'] ?? 'FCFA',
      derniereMiseAJour: json['derniere_mise_a_jour'] != null
          ? DateTime.parse(json['derniere_mise_a_jour'])
          : DateTime.now(),
      nombreTransactions: json['nombre_transactions'] ?? 0,
    );
  }

  // Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'solde': montant,
      'devise': devise,
      'derniere_mise_a_jour': derniereMiseAJour.toIso8601String(),
      'nombre_transactions': nombreTransactions,
    };
  }

  // 🧮 Méthodes utilitaires pour le solde
  bool get isPositif => montant > 0;
  bool get isNegatif => montant < 0;
  bool get isZero => montant == 0;

  // Formatage du solde
  String get formatted => '${montant.toStringAsFixed(2)} $devise';
  String get formattedSigned => '${montant >= 0 ? '+' : ''}${montant.toStringAsFixed(2)} $devise';

  // Couleur/type pour affichage
  String get status {
    if (montant > 0) return 'positif';
    if (montant < 0) return 'negatif';
    return 'zero';
  }

  // Vérifications de seuils
  bool hasMinimum(double minimum) => montant >= minimum;
  bool hasMaximum(double maximum) => montant <= maximum;
  bool isBetween(double min, double max) => montant >= min && montant <= max;

  // Opérations sur le solde
  Solde add(double amount) {
    return Solde(
      montant: montant + amount,
      devise: devise,
      derniereMiseAJour: DateTime.now(),
      nombreTransactions: nombreTransactions + 1,
    );
  }

  Solde subtract(double amount) {
    return Solde(
      montant: montant - amount,
      devise: devise,
      derniereMiseAJour: DateTime.now(),
      nombreTransactions: nombreTransactions + 1,
    );
  }

  // Copie avec modifications
  Solde copyWith({
    double? montant,
    String? devise,
    DateTime? derniereMiseAJour,
    int? nombreTransactions,
  }) {
    return Solde(
      montant: montant ?? this.montant,
      devise: devise ?? this.devise,
      derniereMiseAJour: derniereMiseAJour ?? this.derniereMiseAJour,
      nombreTransactions: nombreTransactions ?? this.nombreTransactions,
    );
  }

  @override
  String toString() {
    return 'Solde(montant: $formatted, devise: $devise, transactions: $nombreTransactions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Solde &&
        other.montant == montant &&
        other.devise == devise;
  }

  @override
  int get hashCode => montant.hashCode ^ devise.hashCode;
}

// 📊 Extension pour calculer le solde depuis une liste de transactions
extension SoldeCalculator on List<double> {
  Solde calculateSolde({
    String devise = 'FCFA',
    DateTime? derniereMiseAJour,
  }) {
    final total = fold<double>(0, (sum, montant) => sum + montant);
    return Solde(
      montant: total,
      devise: devise,
      derniereMiseAJour: derniereMiseAJour,
      nombreTransactions: length,
    );
  }
}

// 🔄 Classe utilitaire pour les calculs de solde
class SoldeUtils {
  // Calculer le solde depuis une liste de transactions
  static Solde fromTransactions(List<Map<String, dynamic>> transactions) {
    double total = 0;
    for (final transaction in transactions) {
      total += (transaction['montant'] ?? 0).toDouble();
    }

    return Solde(
      montant: total,
      nombreTransactions: transactions.length,
      derniereMiseAJour: DateTime.now(),
    );
  }

  // Vérifier si un montant peut être débité
  static bool canDebit(Solde solde, double montant) {
    return solde.montant >= montant;
  }

  // Calculer le nouveau solde après une opération
  static Solde afterOperation(Solde currentSolde, double montant, bool isDebit) {
    final newAmount = isDebit
        ? currentSolde.montant - montant
        : currentSolde.montant + montant;

    return currentSolde.copyWith(
      montant: newAmount,
      nombreTransactions: currentSolde.nombreTransactions + 1,
      derniereMiseAJour: DateTime.now(),
    );
  }
}