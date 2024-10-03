import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:quick_shop_customer/consts.dart'; // Make sure this has your stripeSecretKey defined.

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  // Method to initiate payment
  Future<void> makePayment() async {
    try {
      // Step 1: Create a payment intent on Stripe
      String? paymentIntentClientSecret =
          await _createPaymentIntent(100, "usd");

      if (paymentIntentClientSecret == null) {
        print('Failed to create payment intent');
        return;
      }

      // Step 2: Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'Quick Shop',
          // You can add more configuration like Apple Pay and Google Pay
        ),
      );

      // Step 3: Present the payment sheet to the user
      await _processPayment();
    } catch (e) {
      print('Payment error: $e');
    }
  }

  // Method to create a payment intent by calling Stripe API
  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();

      Map<String, dynamic> data = {
        'amount': _calculateAmount(amount), // amount in cents
        'currency': currency,
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization":
                "Bearer $stripeSecretKey", // Your Stripe Secret Key
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null) {
        return response
            .data['client_secret']; // Return the client secret from Stripe
      }
    } catch (e) {
      print('Error creating payment intent: $e');
    }
    return null;
  }

  // Method to process the payment after payment sheet is presented
  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Payment completed successfully!");
    } catch (e) {
      print('Error presenting payment sheet: $e');
    }
  }

  // Utility method to calculate the amount in cents
  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100; // Stripe expects the amount in cents
    return calculatedAmount.toString();
  }
}
