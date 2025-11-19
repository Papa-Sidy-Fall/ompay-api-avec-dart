import 'api_service.dart';

class OtpService extends ApiService {
  OtpService(String baseUrl) : super(baseUrl);

  // Vérifier un code OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String telephone,
    required String code,
    required String type,
  }) async {
    return await post('/otp/verify', {
      'telephone': telephone,
      'code': code,
      'type': type,
    });
  }

  // Renvoyer un code OTP
  Future<Map<String, dynamic>> resendOtp({
    required String telephone,
  }) async {
    return await post('/otp/resend', {
      'telephone': telephone,
    });
  }
}