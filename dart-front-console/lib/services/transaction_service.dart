import '../models/models.dart';
import 'api_service.dart';

class TransactionService extends ApiService {
  TransactionService(String baseUrl) : super(baseUrl);

  // Effectuer un paiement avec modèle de requête (nécessite OTP)
  Future<TransactionPayResponse> pay(TransactionPayRequest request) async {
    final rawResponse = await post('/transactions/pay', request.toJson());
    return TransactionPayResponse.fromJson(rawResponse);
  }

  // Effectuer un transfert avec modèle de requête (nécessite OTP)
  Future<TransactionTransferResponse> transfer(TransactionTransferRequest request) async {
    final rawResponse = await post('/transactions/transfert', request.toJson());
    return TransactionTransferResponse.fromJson(rawResponse);
  }

  // Effectuer un dépôt avec modèle de requête
  Future<TransactionDepotResponse> depot(TransactionDepotRequest request) async {
    final rawResponse = await post('/transactions/depot', request.toJson());
    return TransactionDepotResponse.fromJson(rawResponse);
  }

  // Lister toutes les transactions
  Future<TransactionListResponse> getTransactions() async {
    final rawResponse = await get('/transactions');
    return TransactionListResponse.fromJson(rawResponse);
  }

  // Récupérer une transaction spécifique
  Future<TransactionDetailResponse> getTransaction(String uuid) async {
    final rawResponse = await get('/transactions/$uuid');
    return TransactionDetailResponse.fromJson(rawResponse);
  }
}