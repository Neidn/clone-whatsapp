import 'package:clone_whatsapp/common/widgets/custom_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import '/common/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Phone Number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
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
                if (_selectedCountry != null)
                  Text('+${_selectedCountry!.phoneCode}'),
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
                onPressed: () {},
                text: 'NEXT',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
