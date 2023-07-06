import 'package:flutter/material.dart';

class CreateCommunityScreen extends StatelessWidget {
  static const routeName = '/create-community-screen';

  const CreateCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티 생성'),
        centerTitle: true,
      ),
    );
  }
}
