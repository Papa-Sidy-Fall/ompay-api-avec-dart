import 'api_service.dart';

class TransactionService extends ApiService {
  TransactionService(String baseUrl) : super(baseUrl);

  // Effectuer un paiement (nécessite OTP)
  Future<Map<String, dynamic>> pay({
    required double montant,
    required String description,
  }) async {
    return await post('/transactions/pay', {
      'montant': montant,
      'description': description,
    });
  }

  // Effectuer un transfert (nécessite OTP)
  Future<Map<String, dynamic>> transfer({
    required double montant,
    required String destinataireUuid,
    required String description,
  }) async {
    return await post('/transactions/transfert', {
      'montant': montant,
      'destinataire_uuid': destinataireUuid,
      'description': description,
    });
  }

  // Effectuer un dépôt (via distributeur)
  Future<Map<String, dynamic>> depot({
    required double montant,
    required String description,
  }) async {
    return await post('/transactions/depot', {
      'montant': montant,
      'description': description,
    });
  }

  // Lister toutes les transactions
  Future<Map<String, dynamic>> getTransactions() async {
    return await get('/transactions');
  }

  // Récupérer une transaction spécifique
  Future<Map<String, dynamic>> getTransaction(String uuid) async {
    return await get('/transactions/$uuid');
  }
}