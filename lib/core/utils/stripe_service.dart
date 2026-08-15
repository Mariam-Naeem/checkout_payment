import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_model/payment_model.dart';
import 'package:checkout_payment_ui/core/utils/api_keys.dart';
import 'package:checkout_payment_ui/core/utils/api_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  final ApiService apiService = ApiService();
  Future<PaymentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    var response = await apiService.post(
      url: 'https://api.stripe.com/v1/payment_intents',
      body: paymentIntentInputModel.toJson(),
      token: ApiKeys.secretKey,
    );
    var paymentIntentmodel = PaymentModel.fromJson(response.data);
    return paymentIntentmodel;
  }

Future initPaymentSheet(String paymentIntentClientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'mariam ',
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> displaypaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      rethrow;
    }
  }
Future makePayment({required PaymentIntentInputModel paymentIntentInputModel}) async {
    try {
      PaymentModel paymentIntent =
          await createPaymentIntent(paymentIntentInputModel);
      await initPaymentSheet(paymentIntent.clientSecret!);
      await displaypaymentSheet();
    } catch (e) {
      rethrow;
    }
  }

}
