import 'dart:io';
import 'package:ompay_console/services/api_client.dart';

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
    final response = await apiClient.auth.register(
      nom: nom,
      telephone: telephone,
      pin: pin,
    );

    if (response['succes'] == true) {
      print(' ${response['message']}');
      print('📱 Un code OTP a été envoyé à votre téléphone');

      // Demander le code OTP pour finaliser l'inscription
      stdout.write('Code OTP reçu : ');
      final otpCode = stdin.readLineSync()?.trim() ?? '';

      if (otpCode.isEmpty) {
        print(' Code OTP requis pour finaliser l\'inscription');
        return null;
      }

      // Vérifier l'OTP pour l'inscription
      final otpResponse = await apiClient.otp.verifyOtp(
        telephone: telephone,
        code: otpCode,
        type: 'inscription',
      );

      if (otpResponse['succes'] == true) {
        final token = otpResponse['donnees']['token'];
        print(' Inscription finalisée avec succès !');
        print(' Vous pouvez maintenant vous connecter.');
        return token;
      } else {
        print(' ${otpResponse['message']}');
        return null;
      }
    } else {
      print(' ${response['message']}');
      return null;
    }
  } catch (e) {
    print(' Erreur lors de l\'inscription: $e');
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
    final response = await apiClient.auth.login(
      telephone: telephone,
      pin: pin,
    );

    if (response['succes'] == true) {
      print(' ${response['message']}');

      // Demander le code OTP
      stdout.write('Code OTP reçu : ');
      final otpCode = stdin.readLineSync()?.trim() ?? '';

      if (otpCode.isEmpty) {
        print(' Code OTP requis');
        return null;
      }

      // Vérifier l'OTP
      final otpResponse = await apiClient.otp.verifyOtp(
        telephone: telephone,
        code: otpCode,
        type: 'connexion',
      );

      if (otpResponse['succes'] == true) {
        final token = otpResponse['donnees']['token'];
        print(' Authentification réussie !');
        return token;
      } else {
        print(' ${otpResponse['message']}');
        return null;
      }
    } else {
      print(' ${response['message']}');
      return null;
    }
  } catch (e) {
    print(' Erreur lors de la connexion: $e');
    return null;
  }
}

Future<void> handleGetBalance(ApiClient apiClient) async {
  print('\n=== Solde du compte ===');

  try {
    final response = await apiClient.compte.getCompte();

    if (response['succes'] == true) {
      final user = response['donnees']['utilisateur'];
      final solde = response['donnees']['solde'];

      print('👤 ${user['nom']}');
      print('📱 ${user['telephone']}');
      print(' Solde: $solde FCFA');
    } else {
      print(' ${response['message']}');
    }
  } catch (e) {
    print(' Erreur lors de la récupération du solde: $e');
  }
}

Future<void> handleGetTransactions(ApiClient apiClient) async {
  print('\n=== Mes transactions ===');

  try {
    final response = await apiClient.compte.getTransactions(0); // userId sera géré par l'API

    if (response['succes'] == true) {
      final transactions = response['donnees']['transactions'] as List;

      if (transactions.isEmpty) {
        print('📝 Aucune transaction trouvée');
        return;
      }

      print('📊 Transactions (${transactions.length}):');
      for (var transaction in transactions) {
        final type = transaction['type'];
        final montant = transaction['montant'];
        final description = transaction['description'];
        final statut = transaction['statut'];
        final date = transaction['created_at'];

        final typeIcon = type == 'payer' ? '💳' : type == 'transfert' ? '💸' : '📥';
        final montantStr = montant < 0 ? '$montant' : '+$montant';

        print('$typeIcon $type: $montantStr FCFA - $description ($statut) - $date');
      }
    } else {
      print(' ${response['message']}');
    }
  } catch (e) {
    print(' Erreur lors de la récupération des transactions: $e');
  }
}

Future<void> handlePay(ApiClient apiClient) async {
  print('\n=== Effectuer un paiement ===');

  stdout.write('Montant : ');
  final montantStr = stdin.readLineSync()?.trim() ?? '';
  final montant = double.tryParse(montantStr);

  stdout.write('Code marchand : ');
  final codeMarchand = stdin.readLineSync()?.trim() ?? '';

  if (montant == null || montant <= 0 || codeMarchand.isEmpty) {
    print(' Montant positif et code marchand requis');
    return;
  }

  try {
    final response = await apiClient.compte.payer(
      userId: 0, // Sera géré par l'API avec le token
      montant: montant,
      codeMarchand: codeMarchand,
    );

    if (response['succes'] == true) {
      print(' ${response['message']}');
      print(' Nouveau solde: ${response['donnees']['nouveau_solde']} FCFA');
    } else {
      print(' ${response['message']}');
    }
  } catch (e) {
    print(' Erreur lors du paiement: $e');
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
    final response = await apiClient.compte.transfert(
      userId: 0, // Sera géré par l'API avec le token
      montant: montant,
      numeroDestinataire: numeroDestinataire,
    );

    if (response['succes'] == true) {
      print(' ${response['message']}');
      print(' Nouveau solde: ${response['donnees']['nouveau_solde']} FCFA');
    } else {
      print(' ${response['message']}');
    }
  } catch (e) {
    print(' Erreur lors du transfert: $e');
  }
}

Future<void> handleGetAccountInfo(ApiClient apiClient) async {
  print('\n=== Informations du compte ===');

  try {
    final response = await apiClient.compte.getCompte();

    if (response['succes'] == true) {
      final user = response['donnees']['utilisateur'];
      final solde = response['donnees']['solde'];
      final qrCode = response['donnees']['qr_code'];

      print('👤 Informations utilisateur:');
      print('   ID: ${user['id']}');
      print('   UUID: ${user['uuid']}');
      print('   Nom: ${user['nom']}');
      print('   Téléphone: ${user['telephone']}');
      print('   Statut: ${user['statut']}');
      print(' Solde: $solde FCFA');
      print('📱 QR Code: ${qrCode ?? 'Non disponible'}');
    } else {
      print(' ${response['message']}');
    }
  } catch (e) {
    print(' Erreur lors de la récupération des informations du compte: $e');
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
    final response = await apiClient.transaction.depot(
      montant: montant,
      description: description,
    );

    if (response['succes'] == true) {
      print(' ${response['message']}');
      print(' Nouveau solde: ${response['donnees']['nouveau_solde']} FCFA');
    } else {
      print(' ${response['message']}');
    }
  } catch (e) {
    print(' Erreur lors du dépôt: $e');
  }
}

Future<void> handleGetDistributeurs(ApiClient apiClient) async {
  print('\n=== Distributeurs ===');

  try {
    final response = await apiClient.distributeur.getDistributeurs();

    if (response['succes'] == true) {
      final distributeurs = response['donnees'] as List;

      if (distributeurs.isEmpty) {
        print('🏪 Aucun distributeur trouvé');
        return;
      }

      print('🏪 Distributeurs (${distributeurs.length}):');
      for (var distributeur in distributeurs) {
        print('📍 ${distributeur['nom']} - ${distributeur['adresse']}');
      }
    } else {
      print(' ${response['message']}');
    }
  } catch (e) {
    print(' Erreur lors de la récupération des distributeurs: $e');
  }
}