// lib/features/payment/services/payment_service.dart


import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../model/donation_request.dart';
import '../model/donation_response.dart';

class PaymentService {
  final DioClient _dio = DioClient();

  Future<Map<String, dynamic>> initiateDonation(InitiateDonationRequest request) async {
    final response = await _dio.post(ApiConstants.donationsInitiate, data: request.toJson());
    return response.data; // { orderId: "order_xyz" }
  }

  Future<DonationModel> verifyDonation(VerifyDonationRequest request) async {
    final response = await _dio.post(ApiConstants.donationsVerify, data: request.toJson());
    return DonationModel.fromJson(response.data);
  }

  Future<DonationModel> getReceipt(String donationId) async {
    final response = await _dio.get('${ApiConstants.donationReceipt}/$donationId/receipt');
    return DonationModel.fromJson(response.data);
  }
}