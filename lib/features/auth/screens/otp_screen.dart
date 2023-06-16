import 'package:flutter/material.dart';

import '/common/utils/colors.dart';

class OTPScreen extends StatefulWidget {
  static const routeName = '/otp-screen';

  final String verificationId;

  const OTPScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying Your Number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.03),
          const Text('We have sent you an SMS with a code to the number'),
          SizedBox(
            width: size.width * 0.5,
            child: TextField(
              maxLines: 1,
              maxLength: 6,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: '- - - - - -',
                hintStyle: TextStyle(
                  fontSize: 30,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {

              },
            ),
          ),
        ],
      ),
    );
  }
}
