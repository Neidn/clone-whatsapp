import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/common/utils/utils.dart';
import '/common/utils/colors.dart';

import '../../../widgets/custom_button.dart';

import '/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _phoneController;
  Country? _selectedCountry;

  @override
  void initState() {
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _pickCountry() => showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      });

  void _sendPhoneNumber() async {
    final String phoneNumber = _phoneController.text.trim();

    if (_selectedCountry == null || phoneNumber.isEmpty) {
      showSnackBar(
        context: context,
        content: 'Please enter a valid phone number!',
      );
      return;
    }

    ref.read(authControllerProvider).signInWithPhone(
          context: context,
          phoneNumber: '+${_selectedCountry!.phoneCode}$phoneNumber',
        );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Phone Number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('WhatsApp will need to verify your phone number.'),
              SizedBox(height: size.height * 0.05),
              TextButton(
                onPressed: () => _pickCountry(),
                child: const Text('Choose a country'),
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.1,
                    child: (_selectedCountry != null)
                        ? Text('+${_selectedCountry!.phoneCode}')
                        : const Text(''),
                  ),
                  SizedBox(width: size.width * 0.03),
                  SizedBox(
                    width: size.width * 0.7,
                    child: TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.50),
              SizedBox(
                width: size.width * 0.3,
                child: CustomButton(
                  onPressed: () => _sendPhoneNumber(),
                  text: 'NEXT',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
