import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:hyperce/app_keys.dart';
import 'package:hyperce/braintree/braintree_helper.dart';

class CreditCardFormScreen extends StatefulWidget {
  const CreditCardFormScreen({super.key});

  @override
  State<CreditCardFormScreen> createState() => _CreditCardFormScreenState();
}

class _CreditCardFormScreenState extends State<CreditCardFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for credit card details
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expirationMonthController =
      TextEditingController();
  final TextEditingController expirationYearController =
      TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  // Method to tokenize credit card
  Future<void> tokenizeCreditCard() async {
    if (_formKey.currentState?.validate() ?? false) {
      final request = BraintreeCreditCardRequest(
        cardNumber: cardNumberController.text,
        expirationMonth: expirationMonthController.text,
        expirationYear: expirationYearController.text,
        cvv: cvvController.text,
      );

      final result = await Braintree.tokenizeCreditCard(
        AppKeys.tokenizationKey,
        request,
      );

      if (result != null) {
        BraintreeHelper.showNonce(result, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Card Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Card Number Field
              TextFormField(
                controller: cardNumberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  } else if (value.length < 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              // Expiration Month Field
              TextFormField(
                controller: expirationMonthController,
                decoration:
                    const InputDecoration(labelText: 'Expiration Month (MM)'),
                keyboardType: TextInputType.number,
                maxLength: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiration month';
                  } else if (int.tryParse(value) == null ||
                      int.parse(value) < 1 ||
                      int.parse(value) > 12) {
                    return 'Invalid month';
                  }
                  return null;
                },
              ),
              // Expiration Year Field
              TextFormField(
                controller: expirationYearController,
                decoration:
                    const InputDecoration(labelText: 'Expiration Year (YYYY)'),
                keyboardType: TextInputType.number,
                maxLength: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expiration year';
                  } else if (int.tryParse(value) == null || value.length != 4) {
                    return 'Invalid year';
                  }
                  return null;
                },
              ),
              // CVV Field
              TextFormField(
                controller: cvvController,
                decoration: const InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                maxLength: 3,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CVV';
                  } else if (value.length != 3) {
                    return 'CVV must be 3 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: tokenizeCreditCard,
                child: const Text('TOKENIZE CREDIT CARD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
