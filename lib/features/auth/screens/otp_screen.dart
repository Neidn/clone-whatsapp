import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/common/utils/colors.dart';

import '/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const routeName = '/otp-screen';

  final String verificationId;

  const OTPScreen({
    super.key,
    required this.verificationId,
  });

  void _verifyOTP({
    required BuildContext context,
    required WidgetRef ref,
    required String userOTP,
  }) async {
    ref.read(authControllerProvider).verifyOTP(
          context: context,
          verificationId: verificationId,
          userOTP: userOTP,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                if (value.length != 6) {
                  return;
                }
                _verifyOTP(
                  context: context,
                  ref: ref,
                  userOTP: value.trim(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
