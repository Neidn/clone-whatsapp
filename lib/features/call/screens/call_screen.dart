import 'package:agora_uikit/agora_uikit.dart';
import 'package:clone_whatsapp/config/agora_config.dart';
import 'package:clone_whatsapp/features/call/controller/call_controller.dart';
import 'package:clone_whatsapp/models/call.dart';
import 'package:clone_whatsapp/widgets/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;
  final String groupId;

  const CallScreen({
    super.key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
    required this.groupId,
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
    initAgora();
    super.initState();
  }

  @override
  void dispose() {
    _disposeAgora();
    super.dispose();
  }

  void initAgora() async {
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
    required bool isGroupChat,
    required String groupId,
  }) {
    _agoraClient.engine.leaveChannel().then((_) {
      ref.read(callControllerProvider).endCall(
            context: context,
            callerId: callerId,
            receiverId: receiverId,
            isGroupChat: isGroupChat,
            groupId: groupId,
          );
    }).then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final streamProvider = ref.watch(callStreamProvider);

    streamProvider.whenData((value) {
      if (value.data() == null) {
        _endCall(
          context: context,
          callerId: widget.call.callerId,
          receiverId: widget.call.receiverId,
          isGroupChat: widget.isGroupChat,
          groupId: widget.groupId,
        );
      }
    });

    return Stack(
      children: [
        AgoraVideoViewer(client: _agoraClient),
        AgoraVideoButtons(
          client: _agoraClient,
          disconnectButtonChild: RawMaterialButton(
            onPressed: () => _endCall(
              context: context,
              callerId: widget.call.callerId,
              receiverId: widget.call.receiverId,
              isGroupChat: widget.isGroupChat,
              groupId: widget.groupId,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(Icons.call_end, color: Colors.white, size: 35),
          ),
        ),
      ],
    );
  }
}
