import '../models/models.dart';
import 'api_service.dart';

class CompteService extends ApiService {
  CompteService(String baseUrl) : super(baseUrl);

  // Récupérer les informations du compte
  Future<CompteInfoResponse> getCompte() async {
    final rawResponse = await get('/compte');
    return CompteInfoResponse.fromJson(rawResponse);
  }

  // Récupérer le solde du compte
  Future<SoldeResponse> getSolde(int userId) async {
    final rawResponse = await get('/compte/$userId/solde');
    return SoldeResponse.fromJson(rawResponse);
  }

  // Effectuer un paiement marchand avec modèle de requête
  Future<PayResponse> payer({
    required int userId,
    required PayRequest request,
  }) async {
    final rawResponse = await post('/compte/$userId/payer', request.toJson());
    return PayResponse.fromJson(rawResponse);
  }

  // Effectuer un transfert avec modèle de requête
  Future<TransferResponse> transfert({
    required int userId,
    required TransferRequest request,
  }) async {
    final rawResponse = await post('/compte/$userId/transfert', request.toJson());
    return TransferResponse.fromJson(rawResponse);
  }

  // Récupérer les transactions du compte
  Future<TransactionsResponse> getTransactions(int userId, {
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

    final rawResponse = await get(endpoint);
    return TransactionsResponse.fromJson(rawResponse);
  }
}