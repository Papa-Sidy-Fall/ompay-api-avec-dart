# OmPay Console - Application Dart Client

## 📋 Vue d'ensemble

**OmPay Console** est une application cliente en Dart qui consomme l'API OmPay (Laravel). Cette application console permet aux utilisateurs d'interagir avec le système de paiement mobile OmPay via une interface en ligne de commande.

### 🎯 Objectif
Créer un client Dart qui communique avec l'API OmPay en respectant une architecture modulaire et extensible, permettant de changer facilement de bibliothèque HTTP si nécessaire.

---

## 🏗️ Architecture du projet

### 📁 Structure des dossiers

```
dart-front-console/
├── bin/
│   └── main.dart              # Point d'entrée de l'application console
├── lib/
│   ├── models/                # Modèles de données (DTOs)
│   │   ├── models.dart        # Export de tous les modèles
│   │   ├── user.dart          # Modèle User
│   │   ├── transaction.dart   # Modèle Transaction
│   │   ├── distributeur.dart  # Modèle Distributeur
│   │   └── otp.dart           # Modèle Otp
│   └── services/              # Couche d'accès aux données (API)
│       ├── api_service.dart   # Classe abstraite de base pour les appels HTTP
│       ├── api_client.dart    # Gestionnaire centralisé de tous les services
│       ├── auth_service.dart  # Service d'authentification
│       ├── otp_service.dart   # Service de gestion des codes OTP
│       ├── compte_service.dart # Service de gestion du compte
│       ├── transaction_service.dart # Service des transactions
│       └── distributeur_service.dart # Service des distributeurs
└── pubspec.yaml               # Configuration du projet Dart
```

### 🏛️ Principes architecturaux

#### 1. **Séparation des responsabilités**
- **Models (DTOs)** : Structures de données typées pour les entités API
- **ApiService** : Gère uniquement les appels HTTP de base
- **Services spécialisés** : Chaque service gère un domaine métier spécifique
- **ApiClient** : Orchestre tous les services
- **Main** : Interface utilisateur et logique applicative

#### 2. **Modèles de données (DTOs)**
Les modèles dans `lib/models/` représentent les entités de l'API :
- **Sérialisation/Désérialisation** : Conversion automatique JSON ↔ objets Dart
- **Type safety** : Propriétés typées au lieu de `Map<String, dynamic>`
- **Méthodes utilitaires** : Logique métier et formatage inclus
- **Relations** : Gestion des liens entre entités (ex: Transaction → User)

#### 3. **Héritage et polymorphisme**
Tous les services spécialisés héritent d'`ApiService`, garantissant :
- Une interface commune pour les appels HTTP
- Une gestion centralisée des tokens d'authentification
- Une facilité de maintenance et d'extension

#### 4. **Programmation asynchrone**
- Utilisation systématique de `Future<T>` pour les opérations I/O
- `async/await` pour un code plus lisible
- Gestion d'erreur appropriée avec `try/catch`

---

## 🔧 Installation et configuration

### Prérequis
- **Dart SDK** (version >= 2.19.0)
- **API OmPay** en cours d'exécution sur `http://127.0.0.1:8000`

### Installation

```bash
# Cloner ou accéder au projet
cd dart-front-console

# Installer les dépendances
dart pub get

# Vérifier que tout compile
dart analyze
```

### Configuration
L'URL de base de l'API est configurée dans `bin/main.dart` :
```dart
const String baseUrl = 'http://127.0.0.1:8000/api';
```

---

## 🚀 Utilisation

### Lancement de l'application

```bash
dart run bin/main.dart
```

### Workflow utilisateur

#### 1. **Authentification**
```
=== Menu d'authentification ===
1. S'inscrire
2. Se connecter
3. Quitter
```

#### 2. **Inscription** (Option 1)
- Saisie du nom, téléphone et PIN
- Appel API : `POST /auth/register` (crée l'utilisateur et envoie automatiquement l'OTP)
- Saisie du code OTP reçu par SMS
- Vérification OTP : `POST /otp/verify` avec `type="inscription"`
- Activation du compte et connexion automatique

#### 3. **Connexion** (Option 2)
- Saisie du téléphone et PIN
- Réception automatique d'un code OTP par SMS
- Vérification du code OTP pour obtenir un token JWT

#### 4. **Menu principal** (après authentification)
```
=== Menu principal ===
1. Consulter mon solde
2. Voir mes transactions
3. Voir les informations de mon compte
4. Effectuer un paiement
5. Effectuer un transfert
6. Faire un dépôt
7. Voir les distributeurs
8. Se déconnecter
9. Quitter
```

---

## 📚 Explication détaillée des composants

### 1. **ApiService** (`lib/services/api_service.dart`)

Classe abstraite qui définit l'interface de base pour tous les appels HTTP :

```dart
abstract class ApiService {
  final String baseUrl;
  String? _token;

  // Méthodes HTTP de base
  Future<Map<String, dynamic>> get(String endpoint);
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data);
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data);
  Future<Map<String, dynamic>> delete(String endpoint);

  // Gestion des tokens
  void setToken(String token);
  String? get token => _token;
}
```

**Rôle :**
- Fournir une interface uniforme pour les appels HTTP
- Gérer automatiquement l'ajout du token Bearer dans les headers
- Centraliser la gestion des erreurs HTTP

### 2. **Services spécialisés**

#### **AuthService** - Gestion de l'authentification
```dart
class AuthService extends ApiService {
  Future<Map<String, dynamic>> register({...});
  Future<Map<String, dynamic>> login({...});
}
```
- **register()** : Inscription d'un nouvel utilisateur
- **login()** : Connexion avec vérification des identifiants

#### **OtpService** - Gestion des codes OTP
```dart
class OtpService extends ApiService {
  Future<Map<String, dynamic>> verifyOtp({...});
  Future<Map<String, dynamic>> resendOtp({...});
}
```
- **verifyOtp()** : Vérification d'un code OTP (retourne un token JWT)
- **resendOtp()** : Renvoi d'un nouveau code OTP

#### **CompteService** - Gestion du compte utilisateur
```dart
class CompteService extends ApiService {
  Future<Map<String, dynamic>> getCompte();
  Future<Map<String, dynamic>> getSolde(int userId);
  Future<Map<String, dynamic>> payer({...});
  Future<Map<String, dynamic>> transfert({...});
  Future<Map<String, dynamic>> getTransactions(int userId, {...});
}
```

#### **TransactionService** - Gestion des transactions
```dart
class TransactionService extends ApiService {
  Future<Map<String, dynamic>> pay({...});
  Future<Map<String, dynamic>> transfer({...});
  Future<Map<String, dynamic>> depot({...});
  Future<Map<String, dynamic>> getTransactions();
  Future<Map<String, dynamic>> getTransaction(String uuid);
}
```

#### **DistributeurService** - Gestion des distributeurs
```dart
class DistributeurService extends ApiService {
  Future<Map<String, dynamic>> getDistributeurs();
}
```

### 5. **Modèles de données (DTOs)**

Les modèles dans `lib/models/` sont des classes Dart typées qui représentent les entités de l'API OmPay :

#### **User** - Utilisateur du système
```dart
class User {
  final int id;
  final String uuid;
  final String nom;
  final String telephone;
  final String statut; // 'actif', 'inactif', 'admin'
  final double solde;
  final String? qrCode;

  // Méthodes utilitaires
  bool get isActive => statut == 'actif';
  bool get isAdmin => statut == 'admin';

  // Sérialisation
  factory User.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

#### **Transaction** - Opération financière
```dart
class Transaction {
  final String uuid;
  final String utilisateurUuid;
  final String type; // 'payer', 'transfert', 'depot'
  final double montant;
  final String description;
  final String statut; // 'en_attente', 'confirmee', 'annulee'
  final User? destinataire; // Relation optionnelle

  // Méthodes utilitaires
  bool get isDebit => montant < 0;
  bool get isCredit => montant > 0;
  String get typeIcon => type == 'payer' ? '💳' : '💸';
  String get montantFormatted; // Formatage automatique

  // Sérialisation
  factory Transaction.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

#### **Distributeur** - Point de dépôt/distribution
```dart
class Distributeur {
  final int id;
  final String nom;
  final String adresse;
  final String statut; // 'actif', 'inactif'

  // Méthodes utilitaires
  bool get isActive => statut == 'actif';
  String get displayInfo => '$nom - $adresse';

  // Sérialisation
  factory Distributeur.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

#### **Otp** - Code de vérification
```dart
class Otp {
  final int id;
  final String telephone;
  final String code;
  final String type; // 'inscription', 'connexion', 'transaction'
  final DateTime expireAt;
  final bool utilise;

  // Méthodes utilitaires
  bool get isExpired => DateTime.now().isAfter(expireAt);
  bool get isValid => !utilise && !isExpired;
  String get timeRemainingFormatted; // "2:45"

  // Sérialisation
  factory Otp.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

### 3. **ApiClient** (`lib/services/api_client.dart`)

Gestionnaire centralisé qui instancie et orchestre tous les services :

```dart
class ApiClient {
  final String baseUrl;
  late final AuthService auth;
  late final OtpService otp;
  late final CompteService compte;
  late final TransactionService transaction;
  late final DistributeurService distributeur;

  ApiClient(this.baseUrl) {
    // Initialisation de tous les services
  }

  void setToken(String token) {
    // Définit le token sur tous les services
  }
}
```

### 4. **Main** (`bin/main.dart`)

Interface utilisateur console avec menus interactifs :

- **Boucle principale** : Gère l'état d'authentification
- **Menus** : Authentification et fonctionnalités principales
- **Handlers** : Traitement des actions utilisateur
- **Gestion d'erreurs** : Affichage des messages d'erreur de l'API

---

## 🔄 Flux d'authentification

### Inscription
1. **Saisie des données** : Nom, téléphone, PIN
2. **Création utilisateur** : `POST /auth/register` (utilisateur créé avec statut "inactif", OTP envoyé automatiquement)
3. **Saisie OTP** : Code reçu par SMS
4. **Vérification OTP** : `POST /otp/verify` avec `type="inscription"`
5. **Activation compte** : Statut passe à "actif", token JWT retourné
6. **Connexion automatique** : Utilisateur connecté immédiatement

### Connexion
1. **Saisie des données** : Téléphone, PIN
2. **Vérification** : `POST /auth/login`
3. **Réception OTP** : Code envoyé automatiquement par SMS
4. **Vérification** : `POST /otp/verify` avec type="connexion"
5. **Authentification** : Token JWT retourné pour les futures requêtes

---

## 💡 Avantages de l'architecture

### 1. **Type Safety avec les DTOs**
- **Modèles typés** : Remplacement de `Map<String, dynamic>` par des classes structurées
- **Détection d'erreurs** : Erreurs de compilation pour les propriétés manquantes
- **IntelliSense** : Autocomplétion et navigation dans le code
- **Réfactoring sécurisé** : Changements d'API propagés automatiquement

### 2. **Extensibilité**
- **Ajout de nouveaux services** : Héritage simple d'ApiService
- **Nouveaux endpoints** : Ajout direct dans le service approprié
- **Nouveaux modèles** : Création indépendante des DTOs
- **Changement de bibliothèque HTTP** : Modification uniquement d'ApiService

### 3. **Maintenabilité**
- **Séparation claire** : Services, modèles et UI clairement séparés
- **Code réutilisable** : Services et modèles indépendants
- **Tests facilités** : Chaque composant testable individuellement
- **Documentation vivante** : Modèles comme contrat d'API

### 4. **Robustesse**
- **Gestion d'erreurs centralisée** : ApiService gère tous les cas d'erreur HTTP
- **Authentification automatique** : Token géré de manière transparente
- **Validation des données** : Vérifications côté API et côté client
- **Sérialisation sécurisée** : Conversion JSON gérée par les modèles

### 5. **Performance**
- **Connexions HTTP optimisées** : Utilisation du package `http` officiel
- **Programmation asynchrone** : Interface non-bloquante
- **Réutilisation des connexions** : Gestion automatique par Dart
- **Parsing efficace** : Désérialisation directe vers objets typés

---

## 🔧 Personnalisation et extension

### Changer l'URL de l'API
```dart
const String baseUrl = 'https://votre-api-ompay.com/api';
```

### Ajouter un nouveau modèle (DTO)
```dart
// Créer le modèle dans lib/models/
class NouveauModele {
  final int id;
  final String nom;
  final DateTime? createdAt;

  NouveauModele({
    required this.id,
    required this.nom,
    this.createdAt,
  });

  // Constructeur depuis JSON
  factory NouveauModele.fromJson(Map<String, dynamic> json) {
    return NouveauModele(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}

// L'exporter dans lib/models/models.dart
export 'nouveau_modele.dart';
```

### Ajouter un nouveau service
```dart
// Créer le service
class NouveauService extends ApiService {
  NouveauService(String baseUrl) : super(baseUrl);

  Future<Map<String, dynamic>> nouvelleMethode() async {
    return await get('/nouveau-endpoint');
  }
}

// L'ajouter à ApiClient
class ApiClient {
  late final NouveauService nouveau;

  ApiClient(this.baseUrl) {
    nouveau = NouveauService(baseUrl);
    // ... autres services
  }

  void setToken(String token) {
    nouveau.setToken(token);
    // ... autres services
  }
}
```

### Changer de bibliothèque HTTP
Si vous voulez utiliser `dio` au lieu de `http` :

1. Ajouter `dio` dans `pubspec.yaml`
2. Modifier uniquement `ApiService` pour utiliser `dio`
3. Tous les services existants fonctionneront automatiquement

---

## 📋 API Endpoints utilisés

| Endpoint | Méthode | Description | Service |
|----------|---------|-------------|---------|
| `/auth/register` | POST | Inscription utilisateur | AuthService |
| `/auth/login` | POST | Connexion utilisateur | AuthService |
| `/otp/verify` | POST | Vérification OTP | OtpService |
| `/otp/resend` | POST | Renvoi OTP | OtpService |
| `/compte` | GET | Infos compte | CompteService |
| `/compte/{id}/solde` | GET | Solde du compte | CompteService |
| `/compte/{id}/payer` | POST | Paiement marchand | CompteService |
| `/compte/{id}/transfert` | POST | Transfert d'argent | CompteService |
| `/compte/{id}/transactions` | GET | Historique transactions | CompteService |
| `/transactions/pay` | POST | Paiement (avec OTP) | TransactionService |
| `/transactions/transfert` | POST | Transfert (avec OTP) | TransactionService |
| `/transactions/depot` | POST | Dépôt d'argent | TransactionService |
| `/transactions` | GET | Liste transactions | TransactionService |
| `/transactions/{uuid}` | GET | Détail transaction | TransactionService |
| `/distributeurs` | GET | Liste distributeurs | DistributeurService |

---

## 🐛 Dépannage

### Erreur de connexion à l'API
- Vérifier que l'API OmPay est démarrée sur le port 8000
- Vérifier l'URL dans `bin/main.dart`

### Erreur d'authentification
- Vérifier que le token n'est pas expiré
- Se reconnecter si nécessaire

### Erreur de compilation
```bash
dart pub get  # Réinstaller les dépendances
dart analyze  # Vérifier les erreurs
```

---

## 🎯 Conclusion

Ce projet démontre une architecture Dart robuste et maintenable pour consommer une API REST. L'approche par héritage et séparation des responsabilités permet :

- **Une évolutivité facile** : Ajout de nouvelles fonctionnalités sans casser l'existant
- **Une maintenabilité optimale** : Code organisé et documenté
- **Une réutilisabilité maximale** : Services indépendants et testables
- **Une adaptabilité parfaite** : Changement de bibliothèque HTTP en un seul endroit

L'application console fournit une interface complète pour interagir avec l'API OmPay, couvrant tous les cas d'usage principaux du système de paiement mobile.