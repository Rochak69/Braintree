import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:hyperce/app_keys.dart';
import 'package:hyperce/braintree/braintree_helper.dart';

class NativeDetailsScreen extends StatefulWidget {
  const NativeDetailsScreen({super.key});

  @override
  State<NativeDetailsScreen> createState() => _NativeDetailsScreenState();
}

class _NativeDetailsScreenState extends State<NativeDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController givenNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController extendedAddressController =
      TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  // Method to launch Braintree Drop-In
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
          countryCodeAlpha2:
              'US', // Default country code, you can make it dynamic
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
              // Email Field
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value != null && value.isNotEmpty
                    ? null
                    : 'Email is required',
              ),
              // Given Name
              TextFormField(
                controller: givenNameController,
                decoration: const InputDecoration(labelText: 'Given Name'),
                validator: (value) => value != null && value.isNotEmpty
                    ? null
                    : 'Given name is required',
              ),
              // Surname
              TextFormField(
                controller: surnameController,
                decoration: const InputDecoration(labelText: 'Surname'),
                validator: (value) => value != null && value.isNotEmpty
                    ? null
                    : 'Surname is required',
              ),
              // Phone Number
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              // Street Address
              TextFormField(
                controller: streetAddressController,
                decoration: const InputDecoration(labelText: 'Street Address'),
              ),
              // Extended Address
              TextFormField(
                controller: extendedAddressController,
                decoration:
                    const InputDecoration(labelText: 'Extended Address'),
              ),
              // Locality (City)
              TextFormField(
                controller: localityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              // Region (State)
              TextFormField(
                controller: regionController,
                decoration: const InputDecoration(labelText: 'State'),
              ),
              // Postal Code
              TextFormField(
                controller: postalCodeController,
                decoration: const InputDecoration(labelText: 'Postal Code'),
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
}
