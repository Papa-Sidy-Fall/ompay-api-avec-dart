import '../models/models.dart';
import 'api_service.dart';

class OtpService extends ApiService {
  OtpService(String baseUrl) : super(baseUrl);

  // Vérifier un code OTP avec modèle de requête
  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) async {
    final rawResponse = await post('/otp/verify', request.toJson());
    return VerifyOtpResponse.fromJson(rawResponse);
  }

  // Renvoyer un code OTP avec modèle de requête
  Future<ResendOtpResponse> resendOtp(ResendOtpRequest request) async {
    final rawResponse = await post('/otp/resend', request.toJson());
    return ResendOtpResponse.fromJson(rawResponse);
  }
}