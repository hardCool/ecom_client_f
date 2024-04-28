import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PurchaseController extends GetxController {
  TextEditingController addressController = TextEditingController();
  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';
  late Razorpay _razorpay;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void submitOrder({
    required double price,
    required String item,
    required String description,
  }) {
    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;
    print('$orderPrice, $itemName, $orderAddress');

    var options = {
      'key': 'rzp_test_GKRdYcSKqY1qb8', // Replace with your actual Razorpay key
      'amount': (price * 100).toInt(),
      'name': item,
      'description': description,
      // Add additional options as needed
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error initiating payment: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    print('Payment Successful: ${response.paymentId}');
    Get.snackbar("Success!", "Payment Completed Successfully",
        snackPosition: SnackPosition.BOTTOM); // Show a Getx Snackbar
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print('Payment Failed: ${response.message}');
    Get.snackbar("Error!", "Payment Failed: ${response.message}",
        snackPosition: SnackPosition.BOTTOM); // Show a Getx Snackbar
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection
    print('External Wallet: ${response.walletName}');
  }
}
