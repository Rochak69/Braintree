import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:hyperce/utils/app_keys.dart';
import 'package:hyperce/braintree/braintree_helper.dart';
import 'package:hyperce/common/payment_method_tile.dart';
import 'package:hyperce/features/credit_card_detail/credit_card_details_screen.dart';
import 'package:hyperce/features/native_details/native_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Braintree Hyperce'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 31, horizontal: 16),
        child: Column(
          children: [
            PaymentMethodTile(
              title: 'Pay with Native UI',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NativeDetailsScreen(),
                    ));
              },
            ),
            PaymentMethodTile(
              title: 'Pay with Credit Card',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreditCardFormScreen(),
                    ));
              },
            ),
            PaymentMethodTile(
              title: 'PayPal Vault Flow',
              onTap: () async {
                final request = BraintreePayPalRequest(
                  amount: '100',
                  billingAgreementDescription:
                      'I hereby agree that flutter_braintree is great.',
                  displayName: 'Your Company',
                );
                final result = await Braintree.requestPaypalNonce(
                  AppKeys.tokenizationKey,
                  request,
                );
                if (result != null && context.mounted) {
                  BraintreeHelper.showNonce(result, context);
                }
              },
            ),
            PaymentMethodTile(
              title: 'Paypal Checkout Flow',
              onTap: () async {
                final request = BraintreePayPalRequest(amount: '13.37');
                final result = await Braintree.requestPaypalNonce(
                  AppKeys.tokenizationKey,
                  request,
                );
                if (result != null && context.mounted) {
                  BraintreeHelper.showNonce(result, context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
