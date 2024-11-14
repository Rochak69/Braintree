import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:hyperce/common/app_text_form_field.dart';
import 'package:hyperce/utils/app_keys.dart';
import 'package:hyperce/braintree/braintree_helper.dart';
import 'package:hyperce/utils/app_validators.dart';

class CreditCardFormScreen extends StatefulWidget {
  const CreditCardFormScreen({super.key});

  @override
  State<CreditCardFormScreen> createState() => _CreditCardFormScreenState();
}

class _CreditCardFormScreenState extends State<CreditCardFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController cardNumberController;
  late TextEditingController expirationMonthController;
  late TextEditingController expirationYearController;
  late TextEditingController cvvController;

  @override
  void initState() {
    super.initState();

    cardNumberController = TextEditingController();
    expirationMonthController = TextEditingController();
    expirationYearController = TextEditingController();
    cvvController = TextEditingController();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expirationMonthController.dispose();
    expirationYearController.dispose();
    cvvController.dispose();
    super.dispose();
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
              AppTextFormField(
                controller: cardNumberController,
                labelText: 'Card Number',
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: AppValidators.validateCardNumber,
              ),
              AppTextFormField(
                controller: expirationMonthController,
                labelText: 'Expiration Month (MM)',
                keyboardType: TextInputType.number,
                maxLength: 2,
                validator: AppValidators.validateExpirationMonth,
              ),
              AppTextFormField(
                controller: expirationYearController,
                labelText: 'Expiration Year (YYYY)',
                keyboardType: TextInputType.number,
                maxLength: 4,
                validator: AppValidators.validateExpirationYear,
              ),
              AppTextFormField(
                controller: cvvController,
                labelText: 'CVV',
                keyboardType: TextInputType.number,
                maxLength: 3,
                obscureText: true,
                validator: AppValidators.validateCVV,
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
}
