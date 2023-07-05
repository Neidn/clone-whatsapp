import 'dart:io';

import 'package:clone_whatsapp/features/status/controller/status_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmStatusScreen extends ConsumerStatefulWidget {
  static const String routeName = '/confirm-status-screen';
  final File file;

  const ConfirmStatusScreen({
    super.key,
    required this.file,
  });

  @override
  ConsumerState<ConfirmStatusScreen> createState() =>
      _ConfirmStatusScreenState();
}

class _ConfirmStatusScreenState extends ConsumerState<ConfirmStatusScreen> {
  void _addStatus({
    required BuildContext context,
    required WidgetRef ref,
  }) =>
      ref
          .read(statusControllerProvider)
          .addStatus(
            context: context,
            file: widget.file,
          )
          .then((_) {
        Navigator.of(context).pop();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Image.file(widget.file),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addStatus(
          context: context,
          ref: ref,
        ),
        child: const Icon(
          Icons.send,
        ),
      ),
    );
  }
}
