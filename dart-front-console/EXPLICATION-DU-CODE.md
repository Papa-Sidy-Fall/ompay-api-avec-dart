# 📚 EXPLICATION COMPLÈTE DU CODE - OmPay Console

## 🎯 Vue d'ensemble du projet

**OmPay Console** est une application cliente Dart qui consomme l'API OmPay (Laravel) via une interface console. Cette application permet aux utilisateurs d'interagir avec le système de paiement mobile OmPay.

---

## 🚀 GUIDE DE CRÉATION DU PROJET (De A à Z)

### 📋 Prérequis
- **Dart SDK** installé (version >= 2.19.0)
- **API OmPay** en cours d'exécution sur `http://127.0.0.1:8000`

### 🛠️ Commandes de création du projet

```bash
# 1. Créer le projet Dart
dart create ompay_console
cd ompay_console

# 2. Renommer le dossier (optionnel)
cd ..
mv ompay_console dart-front-console
cd dart-front-console

# 3. Installer les dépendances
dart pub add http

# 4. Créer la structure des dossiers
mkdir -p lib/services lib/models bin

# 5. Vérifier l'installation
dart analyze
dart run bin/main.dart  # Test de base
```

---

## 🏗️ ARCHITECTURE COMPLÈTE DU PROJET

### 📁 Structure finale des dossiers

```
dart-front-console/
├── 📄 pubspec.yaml              # Configuration du projet
├── 📁 bin/
│   └── 📄 main.dart            # 🔥 POINT D'ENTRÉE PRINCIPAL
├── 📁 lib/
│   ├── 📁 models/              # 🏗️ DTOs (Data Transfer Objects)
│   │   ├── 📄 models.dart      # Export centralisé des modèles
│   │   ├── 📄 user.dart        # Modèle User
│   │   ├── 📄 transaction.dart # Modèle Transaction
│   │   ├── 📄 distributeur.dart# Modèle Distributeur
│   │   └── 📄 otp.dart         # Modèle Otp
│   └── 📁 services/            # 🔧 Couche d'accès API
│       ├── 📄 api_service.dart # Classe abstraite HTTP de base
│       ├── 📄 api_client.dart  # Orchestrateur de tous les services
│       ├── 📄 auth_service.dart# Service d'authentification
│       ├── 📄 otp_service.dart # Service des codes OTP
│       ├── 📄 compte_service.dart# Service du compte utilisateur
│       ├── 📄 transaction_service.dart# Service des transactions
│       └── 📄 distributeur_service.dart# Service des distributeurs
└── 📄 README.md                # Documentation générale
```

---

## 🎨 SCHÉMA VISUEL DU FONCTIONNEMENT

```
┌─────────────────────────────────────────────────────────────────┐
│                    APPLICATION CONSOLE                           │
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │   INTERFACE     │    │    SERVICES     │    │    MODELS   │ │
│  │   UTILISATEUR   │◄──►│     API         │◄──►│     DTOs    │ │
│  │   (main.dart)   │    │   (services/)   │    │  (models/)  │ │
│  └─────────────────┘    └─────────────────┘    └─────────────┘ │
│                                                                 │
│  🔄 MENU AUTH ───► INSCRIPTION ───► OTP ───► CONNEXION ───► MENU PRINCIPAL
│                                                                 │
│  📱 API OmPay (Laravel)                                         │
│  ════════════════════════════════════════════════════════════════ │
│  📡 HTTP Requests/Responses                                     │
└─────────────────────────────────────────────────────────────────┘
```

### 🔄 Flux d'exécution détaillé

```
1. DÉMARRAGE
   ↓
2. main() dans bin/main.dart
   ↓
3. Création ApiClient
   ↓
4. Boucle principale while(true)
   ↓
5. SI pas de token → Menu d'authentification
   │   ├── Inscription → handleRegister()
   │   │   ├── Saisie données utilisateur
   │   │   ├── Appel AuthService.register()
   │   │   ├── Saisie code OTP
   │   │   ├── Appel OtpService.verifyOtp()
   │   │   └── Retour token + connexion auto
   │   └── Connexion → handleLogin()
   │       ├── Saisie téléphone + PIN
   │       ├── Appel AuthService.login()
   │       ├── Saisie code OTP
   │       ├── Appel OtpService.verifyOtp()
   │       └── Stockage token
   ↓
6. SI token présent → Menu principal
   ├── Consulter solde → handleGetBalance()
   ├── Voir transactions → handleGetTransactions()
   ├── Voir compte → handleGetAccountInfo()
   ├── Payer → handlePay()
   ├── Transférer → handleTransfer()
   ├── Déposer → handleDepot()
   ├── Voir distributeurs → handleGetDistributeurs()
   └── Se déconnecter → Suppression token
   ↓
7. Répétition de la boucle
```

---

## 📋 EXPLICATION DÉTAILLÉE PAR FICHIER

### 🔥 1. POINT D'ENTRÉE : `bin/main.dart`

#### **Rôle** : Interface utilisateur console et orchestration principale

#### **Constantes globales**
```dart
const String baseUrl = 'http://127.0.0.1:8000/api';  // URL de l'API OmPay
```

#### **Fonction main()** - Point d'entrée principal
```dart
void main() async {
  print('=== Bienvenue sur OmPay Console ===\n');

  final apiClient = ApiClient(baseUrl);  // 🔥 Création du client API
  String? token;  // Stockage du token JWT

  while (true) {  // 🔄 Boucle principale infinie
    if (!apiClient.hasToken()) {
      // 📱 Menu d'authentification (pas connecté)
      final choice = await showAuthMenu();
      switch (choice) {
        case '1': token = await handleRegister(apiClient); break;
        case '2': token = await handleLogin(apiClient); break;
        case '3': exit(0); break;
      }
      if (token != null) apiClient.setToken(token);
    } else {
      // 🏠 Menu principal (connecté)
      final choice = await showMainMenu();
      switch (choice) {
        case '1': await handleGetBalance(apiClient); break;
        case '2': await handleGetTransactions(apiClient); break;
        // ... autres options
        case '8': apiClient.setToken(''); token = null; break;  // Déconnexion
        case '9': exit(0); break;
      }
    }
    print('\n' + '=' * 40 + '\n');
  }
}
```

#### **Fonctions d'affichage des menus**
```dart
Future<String> showAuthMenu() async {
  print('=== Menu d\'authentification ===');
  print('1. S\'inscrire');
  print('2. Se connecter');
  print('3. Quitter');
  stdout.write('Votre choix : ');
  return stdin.readLineSync()?.trim() ?? '';
}

Future<String> showMainMenu() async {
  print('=== Menu principal ===');
  print('1. Consulter mon solde');
  // ... autres options
  stdout.write('Votre choix : ');
  return stdin.readLineSync()?.trim() ?? '';
}
```

#### **Gestion de l'inscription** - `handleRegister()`
```dart
Future<String?> handleRegister(ApiClient apiClient) async {
  print('\n=== Inscription ===');

  // 📝 Saisie des données utilisateur
  stdout.write('Nom : ');
  final nom = stdin.readLineSync()?.trim() ?? '';

  stdout.write('Téléphone : ');
  final telephone = stdin.readLineSync()?.trim() ?? '';

  stdout.write('PIN (4 chiffres) : ');
  final pin = stdin.readLineSync()?.trim() ?? '';

  // ✅ Validation basique
  if (nom.isEmpty || telephone.isEmpty || pin.isEmpty) {
    print('❌ Tous les champs sont obligatoires');
    return null;
  }

  try {
    // 📡 1. Création du compte utilisateur
    final response = await apiClient.auth.register(
      nom: nom,
      telephone: telephone,
      pin: pin,
    );

    if (response['succes'] == true) {
      print('✅ ${response['message']}');
      print('📱 Un code OTP a été envoyé à votre téléphone');

      // 🔐 2. Saisie du code OTP
      stdout.write('Code OTP reçu : ');
      final otpCode = stdin.readLineSync()?.trim() ?? '';

      if (otpCode.isEmpty) {
        print('❌ Code OTP requis pour finaliser l\'inscription');
        return null;
      }

      // 🔍 3. Vérification du code OTP
      final otpResponse = await apiClient.otp.verifyOtp(
        telephone: telephone,
        code: otpCode,
        type: 'inscription',
      );

      if (otpResponse['succes'] == true) {
        final token = otpResponse['donnees']['token'];
        print('✅ Inscription finalisée avec succès !');
        print('Vous pouvez maintenant vous connecter.');
        return token;  // 🔑 Retour du token JWT
      } else {
        print('❌ ${otpResponse['message']}');
        return null;
      }
    } else {
      print('❌ ${response['message']}');
      return null;
    }
  } catch (e) {
    print('❌ Erreur lors de l\'inscription: $e');
    return null;
  }
}
```

#### **Gestion de la connexion** - `handleLogin()`
```dart
Future<String?> handleLogin(ApiClient apiClient) async {
  print('\n=== Connexion ===');

  // 📱 Saisie téléphone + PIN
  stdout.write('Téléphone : ');
  final telephone = stdin.readLineSync()?.trim() ?? '';

  stdout.write('PIN (4 chiffres) : ');
  final pin = stdin.readLineSync()?.trim() ?? '';

  if (telephone.isEmpty || pin.isEmpty) {
    print('❌ Téléphone et PIN sont obligatoires');
    return null;
  }

  try {
    // 🔐 1. Tentative de connexion
    final response = await apiClient.auth.login(
      telephone: telephone,
      pin: pin,
    );

    if (response['succes'] == true) {
      print('✅ ${response['message']}');

      // 🔐 2. Saisie du code OTP
      stdout.write('Code OTP reçu : ');
      final otpCode = stdin.readLineSync()?.trim() ?? '';

      if (otpCode.isEmpty) {
        print('❌ Code OTP requis');
        return null;
      }

      // 🔍 3. Vérification du code OTP
      final otpResponse = await apiClient.otp.verifyOtp(
        telephone: telephone,
        code: otpCode,
        type: 'connexion',
      );

      if (otpResponse['succes'] == true) {
        final token = otpResponse['donnees']['token'];
        print('✅ Authentification réussie !');
        return token;  // 🔑 Retour du token JWT
      } else {
        print('❌ ${otpResponse['message']}');
        return null;
      }
    } else {
      print('❌ ${response['message']}');
      return null;
    }
  } catch (e) {
    print('❌ Erreur lors de la connexion: $e');
    return null;
  }
}
```

#### **Autres fonctions de gestion**
- `handleGetBalance()` - Consultation du solde
- `handleGetTransactions()` - Historique des transactions
- `handleGetAccountInfo()` - Informations complètes du compte
- `handlePay()` - Effectuer un paiement marchand
- `handleTransfer()` - Effectuer un transfert d'argent
- `handleDepot()` - Faire un dépôt d'argent
- `handleGetDistributeurs()` - Lister les distributeurs

---

## 🏗️ 2. COUCHE MODÈLES (DTOs) : `lib/models/`

### 📄 `models.dart` - Export centralisé
```dart
// Export de tous les modèles pour import facile
export 'user.dart';
export 'transaction.dart';
export 'distributeur.dart';
export 'otp.dart';
```

### 📄 `user.dart` - Modèle Utilisateur
```dart
class User {
  final int id;
  final String uuid;
  final String nom;
  final String telephone;
  final String? email;
  final String statut;  // 'actif', 'inactif', 'admin'
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

  // 🏗️ Constructeur depuis JSON (API response)
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

  // 📤 Conversion vers JSON (pour requêtes API)
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

  // 🔧 Méthodes utilitaires
  bool get isActive => statut == 'actif';
  bool get isInactive => statut == 'inactif';
  bool get isAdmin => statut == 'admin';

  // 🔄 Copie avec modifications (pour updates)
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
```

### 📄 `transaction.dart` - Modèle Transaction
```dart
import 'user.dart';

class Transaction {
  final String uuid;
  final String utilisateurUuid;
  final String type;  // 'payer', 'transfert', 'depot'
  final double montant;
  final String description;
  final String? destinataireUuid;
  final String statut;  // 'en_attente', 'confirmee', 'annulee'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // 🔗 Relation optionnelle (remplie par l'API)
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

  // 🏗️ Constructeur depuis JSON
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

  // 📤 Conversion vers JSON
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

  // 🔧 Méthodes utilitaires
  bool get isDebit => montant < 0;
  bool get isCredit => montant > 0;
  double get montantAbsolu => montant.abs();

  bool get isPayee => type == 'payer';
  bool get isTransfert => type == 'transfert';
  bool get isDepot => type == 'depot';

  bool get isEnAttente => statut == 'en_attente';
  bool get isConfirmee => statut == 'confirmee';
  bool get isAnnulee => statut == 'annulee';

  // 🎨 Formatage pour affichage
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

  // 🔄 Copie avec modifications
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
```

---

## 🔧 3. COUCHE SERVICES (API) : `lib/services/`

### 📄 `api_service.dart` - Classe abstraite HTTP de base

#### **Rôle** : Fournir les méthodes HTTP de base à tous les services

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ApiService {
  final String baseUrl;
  String? _token;  // 🔑 Token JWT stocké en privé

  ApiService(this.baseUrl);

  // 🔑 Setter pour le token
  void setToken(String token) {
    _token = token;
  }

  // 🔑 Getter pour le token
  String? get token => _token;

  // 📋 Headers HTTP de base
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',  // 🔐 Authentification
  };

  // 🌐 Méthode GET
  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url, headers: _headers);
    return _handleResponse(response);
  }

  // 🌐 Méthode POST
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(data),  // 📤 Encodage JSON
    );
    return _handleResponse(response);
  }

  // 🌐 Méthode PUT
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      url,
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // 🌐 Méthode DELETE
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url, headers: _headers);
    return _handleResponse(response);
  }

  // 🔍 Gestion centralisée des réponses HTTP
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      // ✅ Succès
      if (body.isEmpty) {
        return {'success': true};
      }
      try {
        return jsonDecode(body);  // 📥 Décodage JSON
      } catch (e) {
        throw Exception('Erreur de parsing JSON: $e');
      }
    } else {
      // ❌ Erreur
      try {
        final errorData = jsonDecode(body);
        throw Exception(errorData['message'] ?? 'Erreur HTTP $statusCode');
      } catch (e) {
        throw Exception('Erreur HTTP $statusCode: $body');
      }
    }
  }
}
```

### 📄 `api_client.dart` - Orchestrateur de tous les services

#### **Rôle** : Point d'entrée unique pour tous les services API

```dart
import 'api_service.dart';
import 'auth_service.dart';
import 'otp_service.dart';
import 'compte_service.dart';
import 'transaction_service.dart';
import 'distributeur_service.dart';

class ApiClient {
  final String baseUrl;

  // 🎯 Instances de tous les services
  late final AuthService auth;
  late final OtpService otp;
  late final CompteService compte;
  late final TransactionService transaction;
  late final DistributeurService distributeur;

  ApiClient(this.baseUrl) {
    // 🏗️ Initialisation de tous les services
    auth = AuthService(baseUrl);
    otp = OtpService(baseUrl);
    compte = CompteService(baseUrl);
    transaction = TransactionService(baseUrl);
    distributeur = DistributeurService(baseUrl);
  }

  // 🔑 Méthode pour définir le token sur TOUS les services
  void setToken(String token) {
    auth.setToken(token);
    otp.setToken(token);
    compte.setToken(token);
    transaction.setToken(token);
    distributeur.setToken(token);
  }

  // 🔍 Vérifier si un token est défini
  bool hasToken() {
    return auth.token != null;
  }
}
```

### 📄 `auth_service.dart` - Service d'authentification

```dart
import 'api_service.dart';

class AuthService extends ApiService {
  AuthService(String baseUrl) : super(baseUrl);

  // 👤 Inscription d'un utilisateur
  Future<Map<String, dynamic>> register({
    required String nom,
    required String telephone,
    required String pin,
  }) async {
    return await post('/auth/register', {
      'nom': nom,
      'telephone': telephone,
      'pin': pin,
    });
  }

  // 🔐 Connexion d'un utilisateur
  Future<Map<String, dynamic>> login({
    required String telephone,
    required String pin,
  }) async {
    return await post('/auth/login', {
      'telephone': telephone,
      'pin': pin,
    });
  }
}
```

### 📄 `otp_service.dart` - Service des codes OTP

```dart
import 'api_service.dart';

class OtpService extends ApiService {
  OtpService(String baseUrl) : super(baseUrl);

  // 🔍 Vérifier un code OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String telephone,
    required String code,
    required String type,  // 'inscription', 'connexion', 'transaction'
  }) async {
    return await post('/otp/verify', {
      'telephone': telephone,
      'code': code,
      'type': type,
    });
  }

  // 📱 Renvoyer un code OTP
  Future<Map<String, dynamic>> resendOtp({
    required String telephone,
  }) async {
    return await post('/otp/resend', {
      'telephone': telephone,
    });
  }
}
```

---

## 🎬 SCÉNARIO COMPLET D'EXÉCUTION

### 📱 Scénario : Inscription d'un nouvel utilisateur

```
1. LANCEMENT
   Commande: dart run bin/main.dart
   └── main() s'exécute

2. AFFICHAGE MENU AUTH
   "=== Menu d'authentification ==="
   "1. S'inscrire"
   "2. Se connecter"
   "3. Quitter"

3. CHOIX UTILISATEUR
   Utilisateur tape: "1"
   └── handleRegister(apiClient) appelée

4. SAISIE DONNÉES
   Nom: "Papa Sidy Fall"
   Téléphone: "771234567"
   PIN: "1234"

5. APPEL API INSCRIPTION
   apiClient.auth.register(nom, telephone, pin)
   ├── AuthService.register() → ApiService.post()
   ├── URL: http://127.0.0.1:8000/api/auth/register
   ├── Body: {"nom":"Papa Sidy Fall","telephone":"771234567","pin":"1234"}
   └── Réponse API: {"succes":true,"message":"Utilisateur créé..."}

6. SAISIE CODE OTP
   "Code OTP reçu: " → Utilisateur tape: "1234"

7. VÉRIFICATION OTP
   apiClient.otp.verifyOtp(telephone, code, "inscription")
   ├── OtpService.verifyOtp() → ApiService.post()
   ├── URL: http://127.0.0.1:8000/api/otp/verify
   ├── Body: {"telephone":"771234567","code":"1234","type":"inscription"}
   └── Réponse API: {"succes":true,"donnees":{"token":"eyJ0eXAi..."}}

8. CONNEXION AUTOMATIQUE
   token = otpResponse['donnees']['token']
   apiClient.setToken(token)  // Définit le token sur tous les services
   └── "✅ Inscription et connexion réussies !"

9. MENU PRINCIPAL
   Utilisateur maintenant connecté, accès au menu principal
```

---

## 🔧 COMMANDES UTILES POUR LE DÉVELOPPEMENT

```bash
# Installation et setup
dart pub get                    # Installer les dépendances
dart analyze                    # Vérifier les erreurs de code
dart format .                   # Formatter le code

# Tests et exécution
dart run bin/main.dart          # Lancer l'application
dart test                       # Exécuter les tests (si présents)

# Debugging
dart run --observe bin/main.dart # Mode debug avec observateur
dart run --enable-asserts bin/main.dart # Assertions activées

# API testing (avec l'API OmPay démarrée)
curl http://127.0.0.1:8000/api/documentation  # Docs API
curl http://127.0.0.1:8000/api/admin/reset-database?secret=ompay-admin-2025  # Reset DB
```

---

## 🐛 DÉPANNAGE COURANT

### **Erreur : "Connection refused"**
```bash
# Vérifier que l'API OmPay est démarrée
curl http://127.0.0.1:8000/api/documentation
# Si ça ne marche pas, démarrer l'API Laravel
cd ompay-api && php artisan serve
```

### **Erreur : "Invalid token"**
```bash
# Le token a expiré, se reconnecter
# Dans l'application : Option 8 "Se déconnecter" puis se reconnecter
```

### **Erreur : "Code OTP invalide"**
```bash
# Vérifier dans les logs Laravel
cd ompay-api && tail -f storage/logs/laravel.log
# Ou vérifier dans la DB
php artisan tinker
>>> Otp::where('telephone', '771234567')->latest()->first()
```

---

## 🎯 CONCLUSION

### **Flux complet résumé** :

1. **Démarrage** : `dart run bin/main.dart`
2. **Interface** : `main()` → `showAuthMenu()` / `showMainMenu()`
3. **Authentification** : `handleRegister()` ou `handleLogin()`
4. **API Calls** : `ApiClient` → `Services` → `ApiService` → HTTP
5. **Modèles** : JSON → `fromJson()` → Objets typés
6. **Actions** : `handleGetBalance()`, `handlePay()`, etc.
7. **Boucle** : Répétition infinie jusqu'à `exit(0)`

### **Architecture en couches** :
- **Interface** (`main.dart`) : Interaction utilisateur
- **Services** (`api_client.dart` + services) : Logique métier API
- **Modèles** (`models/`) : Structures de données typées
- **Base HTTP** (`api_service.dart`) : Communication réseau

Cette architecture assure **maintenabilité**, **évolutivité** et **robustesse** du code ! 🚀