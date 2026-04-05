// lib/features/payment/views/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../data/model/donation_request.dart';
import '../providers/payment_providers.dart';
import 'receipt_screen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String ngoId;
  final String campaignId;

  const PaymentScreen({
    super.key,
    required this.ngoId,
    required this.campaignId,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  late Razorpay _razorpay; // Now recognized
  bool _isLoading = false;
  String? _orderId;

  static const String razorpayKeyId = 'rzp_test_SZ6DCpKntuMM5f'; // Your test key

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _initiatePayment() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final request = InitiateDonationRequest(
      ngoId: widget.ngoId,
      campaignId: widget.campaignId,
      amount: amount,
    );
    try {
      final response = await ref.read(initiateDonationProvider(request).future);
      _orderId = response['orderId'];
      _openRazorpay(amount);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initiate: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  void _openRazorpay(double amount) {
    final options = {
      'key': razorpayKeyId,
      'amount': (amount * 100).toInt(), // Convert to paise
      'order_id': _orderId,
      'name': 'TrustNet',
      'description': 'Donation to NGO',
      'prefill': {
        'contact': '',
        'email': '',
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final verifyRequest = VerifyDonationRequest(
      razorpayOrderId: response.orderId!,
      razorpayPaymentId: response.paymentId!,
      signature: response.signature!,
    );
    try {
      final donation = await ref.read(verifyDonationProvider(verifyRequest).future);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ReceiptScreen(donationId: donation.id),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External wallet: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donate'), backgroundColor: const Color(0xFF7C3AED)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Amount (₹)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _initiatePayment,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white
              ),
              child: const Text('Donate Now',),
            ),
          ],
        ),
      ),
    );
  }
}