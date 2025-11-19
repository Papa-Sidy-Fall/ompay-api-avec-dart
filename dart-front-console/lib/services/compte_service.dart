import 'api_service.dart';

class CompteService extends ApiService {
  CompteService(String baseUrl) : super(baseUrl);

  // Récupérer les informations du compte
  Future<Map<String, dynamic>> getCompte() async {
    return await get('/compte');
  }

  // Récupérer le solde du compte
  Future<Map<String, dynamic>> getSolde(int userId) async {
    return await get('/compte/$userId/solde');
  }

  // Effectuer un paiement marchand
  Future<Map<String, dynamic>> payer({
    required int userId,
    required double montant,
    required String codeMarchand,
  }) async {
    return await post('/compte/$userId/payer', {
      'montant': montant,
      'code_marchand': codeMarchand,
    });
  }

  // Effectuer un transfert
  Future<Map<String, dynamic>> transfert({
    required int userId,
    required double montant,
    required String numeroDestinataire,
  }) async {
    return await post('/compte/$userId/transfert', {
      'montant': montant,
      'numero_destinataire': numeroDestinataire,
    });
  }

  // Récupérer les transactions du compte
  Future<Map<String, dynamic>> getTransactions(int userId, {
    String? type,
    int? perPage,
  }) async {
    String endpoint = '/compte/$userId/transactions';
    Map<String, String> queryParams = {};

    if (type != null) queryParams['type'] = type;
    if (perPage != null) queryParams['per_page'] = perPage.toString();

    if (queryParams.isNotEmpty) {
      endpoint += '?' + queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
    }

    return await get(endpoint);
  }
}