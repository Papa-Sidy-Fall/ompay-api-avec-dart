import 'dart:io';
import 'package:ompay_console/services/api_client.dart';
import 'package:ompay_console/models/models.dart';

const String baseUrl = 'http://127.0.0.1:8000/api';

void main() async {
  print('=== Bienvenue sur OmPay Console ===\n');

  final apiClient = ApiClient(baseUrl);
  String? token;

  while (true) {
    if (!apiClient.hasToken()) {
      // Menu d'authentification
      final choice = await showAuthMenu();

      switch (choice) {
        case '1':
          token = await handleRegister(apiClient);
          if (token != null) {
            apiClient.setToken(token);
            print('\n Inscription et connexion réussies !');
          }
          break;
        case '2':
          token = await handleLogin(apiClient);
          if (token != null) {
            apiClient.setToken(token);
            print('\n Connexion réussie !');
          }
          break;
        case '3':
          print('Au revoir !');
          exit(0);
        default:
          print(' Choix invalide');
      }
    } else {
      // Menu principal
      final choice = await showMainMenu();

      switch (choice) {
        case '1':
          await handleGetBalance(apiClient);
          break;
        case '2':
          await handleGetTransactions(apiClient);
          break;
        case '3':
          await handleGetAccountInfo(apiClient);
          break;
        case '4':
          await handlePay(apiClient);
          break;
        case '5':
          await handleTransfer(apiClient);
          break;
        case '6':
          await handleDepot(apiClient);
          break;
        case '7':
          await handleGetDistributeurs(apiClient);
          break;
        case '8':
          apiClient.setToken(''); // Déconnexion
          token = null;
          print(' Déconnexion réussie');
          break;
        case '9':
          print('Au revoir !');
          exit(0);
        default:
          print(' Choix invalide');
      }
    }

    print('\n' + '=' * 40 + '\n');
  }
}

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
  print('2. Voir mes transactions');
  print('3. Voir les informations de mon compte');
  print('4. Effectuer un paiement');
  print('5. Effectuer un transfert');
  print('6. Faire un dépôt');
  print('7. Voir les distributeurs');
  print('8. Se déconnecter');
  print('9. Quitter');
  stdout.write('Votre choix : ');
  return stdin.readLineSync()?.trim() ?? '';
}

Future<String?> handleRegister(ApiClient apiClient) async {
  print('\n=== Inscription ===');

  stdout.write('Nom : ');
  final nom = stdin.readLineSync()?.trim() ?? '';

  stdout.write('Téléphone : ');
  final telephone = stdin.readLineSync()?.trim() ?? '';

  stdout.write('PIN (4 chiffres) : ');
  final pin = stdin.readLineSync()?.trim() ?? '';

  if (nom.isEmpty || telephone.isEmpty || pin.isEmpty) {
    print(' Tous les champs sont obligatoires');
    return null;
  }

  try {
    final request = RegisterRequest(nom: nom, telephone: telephone, pin: pin);
    if (!request.isValid) {
      print('❌ Données invalides');
      return null;
    }

    final response = await apiClient.auth.register(request);

    if (response.isSuccess) {
      print('✅ ${response.message}');
      print('📱 Un code OTP a été envoyé à votre téléphone');

      // Demander le code OTP pour finaliser l'inscription
      stdout.write('Code OTP reçu : ');
      final otpCode = stdin.readLineSync()?.trim() ?? '';

      if (otpCode.isEmpty) {
        print('❌ Code OTP requis pour finaliser l\'inscription');
        return null;
      }

      // Vérifier l'OTP pour l'inscription
      final otpRequest = VerifyOtpRequest(
        telephone: telephone,
        code: otpCode,
        type: 'inscription',
      );

      final otpResponse = await apiClient.otp.verifyOtp(otpRequest);

      if (otpResponse.isSuccess && otpResponse.hasToken) {
        print('✅ Inscription finalisée avec succès !');
        print('🔑 Vous pouvez maintenant vous connecter.');
        return otpResponse.token;
      } else {
        print('❌ ${otpResponse.message}');
        return null;
      }
    } else {
      print('❌ ${response.message}');
      return null;
    }
  } catch (e) {
    print('❌ Erreur lors de l\'inscription: $e');
    return null;
  }
}

Future<String?> handleLogin(ApiClient apiClient) async {
  print('\n=== Connexion ===');

  stdout.write('Téléphone : ');
  final telephone = stdin.readLineSync()?.trim() ?? '';

  stdout.write('PIN (4 chiffres) : ');
  final pin = stdin.readLineSync()?.trim() ?? '';

  if (telephone.isEmpty || pin.isEmpty) {
    print(' Téléphone et PIN sont obligatoires');
    return null;
  }

  try {
    final request = LoginRequest(telephone: telephone, pin: pin);
    if (!request.isValid) {
      print('❌ Téléphone et PIN requis');
      return null;
    }

    final response = await apiClient.auth.login(request);

    if (response.isSuccess) {
      print('✅ ${response.message}');

      // Demander le code OTP
      stdout.write('Code OTP reçu : ');
      final otpCode = stdin.readLineSync()?.trim() ?? '';

      if (otpCode.isEmpty) {
        print('❌ Code OTP requis');
        return null;
      }

      // Vérifier l'OTP
      final otpRequest = VerifyOtpRequest(
        telephone: telephone,
        code: otpCode,
        type: 'connexion',
      );

      final otpResponse = await apiClient.otp.verifyOtp(otpRequest);

      if (otpResponse.isSuccess && otpResponse.hasToken) {
        print('✅ Authentification réussie !');
        return otpResponse.token;
      } else {
        print('❌ ${otpResponse.message}');
        return null;
      }
    } else {
      print('❌ ${response.message}');
      return null;
    }
  } catch (e) {
    print('❌ Erreur lors de la connexion: $e');
    return null;
  }
}

Future<void> handleGetBalance(ApiClient apiClient) async {
  print('\n=== Solde du compte ===');

  try {
    final response = await apiClient.compte.getCompte();

    if (response.isSuccess) {
      final user = response.utilisateur;
      final solde = response.solde;

      print('👤 ${user?['nom']}');
      print('📱 ${user?['telephone']}');
      print('💰 Solde: $solde FCFA');
    } else {
      print('❌ ${response.message}');
    }
  } catch (e) {
    print('❌ Erreur lors de la récupération du solde: $e');
  }
}

Future<void> handleGetTransactions(ApiClient apiClient) async {
  print('\n=== Mes transactions ===');

  try {
    final response = await apiClient.transaction.getTransactions();

    if (response.isSuccess) {
      final transactions = response.transactions;

      if (transactions.isEmpty) {
        print('📝 Aucune transaction trouvée');
        return;
      }

      print('📊 Transactions (${transactions.length}):');
      for (var transactionData in transactions) {
        // Créer un objet Transaction depuis les données JSON
        final transaction = Transaction.fromJson(transactionData);

        print('${transaction.typeIcon} ${transaction.type}: ${transaction.montantFormatted} - ${transaction.description} (${transaction.statut})');
      }
    } else {
      print('❌ ${response.message}');
    }
  } catch (e) {
    print('❌ Erreur lors de la récupération des transactions: $e');
  }
}

Future<void> handlePay(ApiClient apiClient) async {
  print('\n=== Effectuer un paiement ===');

  stdout.write('Montant : ');
  final montantStr = stdin.readLineSync()?.trim() ?? '';
  final montant = double.tryParse(montantStr);

  stdout.write('Code marchand (ex: ORANGE123, WAVE456, FREE789) ou numéro de téléphone : ');
  final inputCode = stdin.readLineSync()?.trim() ?? '';

  if (montant == null || montant <= 0 || inputCode.isEmpty) {
    print(' Montant positif et destinataire requis');
    return;
  }

  try {
    // Déterminer automatiquement si c'est un code marchand ou un numéro de téléphone
    String? codeMarchandPay;
    String? numeroDestinatairePay;

    // Si ça contient "+" ou commence par un chiffre suivi d'autres chiffres, c'est un numéro de téléphone
    if (inputCode.startsWith('+') || RegExp(r'^\d{8,}').hasMatch(inputCode)) {
      numeroDestinatairePay = inputCode;
    } else {
      codeMarchandPay = inputCode;
    }

    final request = PayRequest(
      montant: montant,
      codeMarchand: codeMarchandPay,
      numeroDestinataire: numeroDestinatairePay,
    );

    if (!request.isValid) {
      print('❌ Données invalides');
      return;
    }

    final response = await apiClient.compte.payer(
      userId: 0, // Sera géré par l'API avec le token
      request: request,
    );

    if (response.isSuccess) {
      print('✅ ${response.message}');
      print('💰 Nouveau solde: ${response.nouveauSolde} FCFA');
    } else {
      print('❌ ${response.message}');
    }
  } catch (e) {
    print('❌ Erreur lors du paiement: $e');
  }
}

Future<void> handleTransfer(ApiClient apiClient) async {
  print('\n=== Effectuer un transfert ===');

  stdout.write('Montant : ');
  final montantStr = stdin.readLineSync()?.trim() ?? '';
  final montant = double.tryParse(montantStr);

  stdout.write('Numéro du destinataire : ');
  final numeroDestinataire = stdin.readLineSync()?.trim() ?? '';

  if (montant == null || montant <= 0 || numeroDestinataire.isEmpty) {
    print(' Montant positif et numéro destinataire requis');
    return;
  }

  try {
    final request = TransferRequest(montant: montant, numeroDestinataire: numeroDestinataire);
    if (!request.isValid) {
      print('❌ Données invalides');
      return;
    }

    final response = await apiClient.compte.transfert(
      userId: 0, // Sera géré par l'API avec le token
      request: request,
    );

    if (response.isSuccess) {
      print('✅ ${response.message}');
      print('💰 Nouveau solde: ${response.nouveauSolde} FCFA');
    } else {
      print('❌ ${response.message}');
    }
  } catch (e) {
    print('❌ Erreur lors du transfert: $e');
  }
}

Future<void> handleGetAccountInfo(ApiClient apiClient) async {
  print('\n=== Informations du compte ===');

  try {
    final response = await apiClient.compte.getCompte();

    if (response.isSuccess) {
      final user = response.utilisateur;
      final solde = response.solde;
      final qrCode = response.qrCode;

      print('👤 Informations utilisateur:');
      print('   ID: ${user?['id']}');
      print('   UUID: ${user?['uuid']}');
      print('   Nom: ${user?['nom']}');
      print('   Téléphone: ${user?['telephone']}');
      print('   Statut: ${user?['statut']}');
      print('💰 Solde: $solde FCFA');
      print('📱 QR Code: ${qrCode ?? 'Non disponible'}');
    } else {
      print('❌ ${response.message}');
    }
  } catch (e) {
    print('❌ Erreur lors de la récupération des informations du compte: $e');
  }
}

Future<void> handleDepot(ApiClient apiClient) async {
  print('\n=== Faire un dépôt ===');

  stdout.write('Montant à déposer : ');
  final montantStr = stdin.readLineSync()?.trim() ?? '';
  final montant = double.tryParse(montantStr);

  stdout.write('Description : ');
  final description = stdin.readLineSync()?.trim() ?? '';

  if (montant == null || montant <= 0) {
    print(' Montant positif requis');
    return;
  }

  if (description.isEmpty) {
    print(' Description requise');
    return;
  }

  try {
    final request = TransactionDepotRequest(montant: montant, description: description);
    if (!request.isValid) {
      print('❌ Données invalides');
      return;
    }

    final response = await apiClient.transaction.depot(request);

    if (response.isSuccess) {
      print('✅ ${response.message}');
      print('💰 Nouveau solde: ${response.nouveauSolde} FCFA');
    } else {
      print('❌ ${response.message}');
    }
  } catch (e) {
    print('❌ Erreur lors du dépôt: $e');
  }
}

Future<void> handleGetDistributeurs(ApiClient apiClient) async {
  print('\n=== Distributeurs ===');

  try {
    final response = await apiClient.distributeur.getDistributeurs();

    if (response.isSuccess) {
      final distributeurs = response.distributeurs;

      if (distributeurs.isEmpty) {
        print('🏪 Aucun distributeur trouvé');
        return;
      }

      print('🏪 Distributeurs (${distributeurs.length}):');
      for (var distributeur in distributeurs) {
        print('📍 ${distributeur['nom']} - ${distributeur['adresse']}');
      }
    } else {
      print('❌ ${response.message}');
    }
  } catch (e) {
    print('❌ Erreur lors de la récupération des distributeurs: $e');
  }
}