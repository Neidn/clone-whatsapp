import 'package:agora_uikit/agora_uikit.dart';
import 'package:clone_whatsapp/config/agora_config.dart';
import 'package:clone_whatsapp/features/call/controller/call_controller.dart';
import 'package:clone_whatsapp/models/call.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;

  const CallScreen({
    super.key,
    required this.channelId,
    required this.call,
    this.isGroupChat = false,
  });

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  late final AgoraClient _agoraClient;

  @override
  void initState() {
    _agoraClient = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
      ),
    );
    _initAgora();
    super.initState();
  }

  @override
  void dispose() {
    _disposeAgora();
    super.dispose();
  }

  void _initAgora() async {
    await _agoraClient.initialize();
  }

  void _disposeAgora() async {
    if (_agoraClient.isInitialized) {
      await _agoraClient.release();
    }
  }

  void _endCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
  }) {
    _agoraClient.engine.leaveChannel().then((_) {
      ref.read(callControllerProvider).endCall(
            context: context,
            callerId: callerId,
            receiverId: receiverId,
          );
    }).then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AgoraVideoViewer(client: _agoraClient),
          AgoraVideoButtons(
            client: _agoraClient,
            disconnectButtonChild: RawMaterialButton(
              onPressed: () => _endCall(
                context: context,
                callerId: widget.call.callerId,
                receiverId: widget.call.receiverId,
              ),
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.redAccent,
              padding: const EdgeInsets.all(15.0),
              child: const Icon(Icons.call_end, color: Colors.white, size: 35),
            ),
          ),
        ],
      ),
    );
  }
}
