import 'package:flutter/material.dart';

import '/common/utils/colors.dart';
import '/common/widgets/custom_button.dart';
import '/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void _navigateToLoginScreen(BuildContext context) async {
    await Navigator.of(context).pushNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // Whatsapp clone
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to WhatsApp',
                style: TextStyle(
                  fontSize: size.width * 0.08,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.07),
              Image.asset(
                'assets/images/bg.png',
                height: size.height * 0.4,
                width: size.width * 0.8,
                color: tabColor,
              ),
              SizedBox(height: size.height * 0.07),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Read Our Privacy Policy. Tap "Agree And Continue" to accept the Terms of Service.',
                  style: TextStyle(color: greyColor),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              SizedBox(
                width: size.width * 0.8,
                child: CustomButton(
                  onPressed: () => _navigateToLoginScreen(context),
                  text: 'AGREE AND CONTINUE',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
