import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:hyperce/common/app_text_form_field.dart';
import 'package:hyperce/utils/app_keys.dart';
import 'package:hyperce/braintree/braintree_helper.dart';
import 'package:hyperce/utils/app_validators.dart';

class NativeDetailsScreen extends StatefulWidget {
  const NativeDetailsScreen({super.key});

  @override
  State<NativeDetailsScreen> createState() => _NativeDetailsScreenState();
}

class _NativeDetailsScreenState extends State<NativeDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController givenNameController;
  late TextEditingController surnameController;
  late TextEditingController phoneController;
  late TextEditingController streetAddressController;
  late TextEditingController extendedAddressController;
  late TextEditingController localityController;
  late TextEditingController regionController;
  late TextEditingController postalCodeController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    givenNameController = TextEditingController();
    surnameController = TextEditingController();
    phoneController = TextEditingController();
    streetAddressController = TextEditingController();
    extendedAddressController = TextEditingController();
    localityController = TextEditingController();
    regionController = TextEditingController();
    postalCodeController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    givenNameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    streetAddressController.dispose();
    extendedAddressController.dispose();
    localityController.dispose();
    regionController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Braintree Payment Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AppTextFormField(
                controller: emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: AppValidators.validateEmail,
              ),
              AppTextFormField(
                controller: givenNameController,
                labelText: 'Given Name',
                validator: AppValidators.validateNotEmpty,
              ),
              AppTextFormField(
                controller: surnameController,
                labelText: 'Surname',
                validator: AppValidators.validateNotEmpty,
              ),
              AppTextFormField(
                controller: phoneController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
              AppTextFormField(
                controller: streetAddressController,
                labelText: 'Street Address',
              ),
              AppTextFormField(
                controller: extendedAddressController,
                labelText: 'Extended Address',
              ),
              AppTextFormField(
                controller: localityController,
                labelText: 'City',
              ),
              AppTextFormField(
                controller: regionController,
                labelText: 'State',
              ),
              AppTextFormField(
                controller: postalCodeController,
                labelText: 'Postal Code',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: launchBraintreeDropIn,
                child: const Text('LAUNCH NATIVE DROP-IN'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchBraintreeDropIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      var request = BraintreeDropInRequest(
        tokenizationKey: AppKeys.tokenizationKey,
        collectDeviceData: true,
        vaultManagerEnabled: true,
        requestThreeDSecureVerification: true,
        email: emailController.text,
        billingAddress: BraintreeBillingAddress(
          givenName: givenNameController.text,
          surname: surnameController.text,
          phoneNumber: phoneController.text,
          streetAddress: streetAddressController.text,
          extendedAddress: extendedAddressController.text,
          locality: localityController.text,
          region: regionController.text,
          postalCode: postalCodeController.text,
          countryCodeAlpha2: 'US', // Default country code
        ),
        googlePaymentRequest: BraintreeGooglePaymentRequest(
          totalPrice: '4.20',
          currencyCode: 'USD',
          billingAddressRequired: false,
        ),
        applePayRequest: BraintreeApplePayRequest(
          currencyCode: 'USD',
          supportedNetworks: [
            ApplePaySupportedNetworks.visa,
            ApplePaySupportedNetworks.masterCard,
            ApplePaySupportedNetworks.amex,
            ApplePaySupportedNetworks.discover,
          ],
          countryCode: 'US',
          merchantIdentifier: '',
          displayName: '',
          paymentSummaryItems: [],
        ),
        paypalRequest: BraintreePayPalRequest(
          amount: '4.20',
          displayName: 'Example company',
        ),
        cardEnabled: true,
      );
      final result = await BraintreeDropIn.start(request);
      if (result != null) {
        BraintreeHelper.showNonce(result.paymentMethodNonce, context);
      }
    }
  }
}
