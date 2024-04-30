import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:io' show Platform;

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
    // Check if the platform is Android before initiating payment
    if (Platform.isAndroid) {
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
    } else {
      // Show an error message or handle unsupported platform scenario
      print('Razorpay payment is not supported on this platform.');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment Successful: ${response.paymentId}');
    Get.snackbar(
      "Success!",
      "Payment Completed Successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Failed: ${response.message}');
    Get.snackbar(
      "Error!",
      "Payment Failed: ${response.message}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }
}
