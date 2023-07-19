import 'package:clone_whatsapp/features/call/controller/call_controller.dart';
import 'package:clone_whatsapp/features/call/screens/call_screen.dart';
import 'package:clone_whatsapp/models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallPickupScreen extends ConsumerWidget {
  final Widget scaffold;

  const CallPickupScreen({
    super.key,
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.read(callControllerProvider).getCallStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          final Call call =
              Call.fromMap(snapshot.data!.data()! as Map<String, dynamic>);

          if (!call.hasDialled) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(call.callerPic),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      call.callerName,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 75),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            // TODO: End Call and close other phone's call screen
                            ref.read(callControllerProvider).endCall(
                                  context: context,
                                  callerId: call.callerId,
                                  receiverId: call.receiverId,
                                  isGroupChat: false,
                                  groupId: '',
                                );
                          },
                          icon: const Icon(
                            Icons.call_end,
                            color: Colors.redAccent,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CallScreen(
                                channelId: call.callerId,
                                call: call,
                                isGroupChat: false,
                                groupId: '',
                              ),
                            ));
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.greenAccent,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }

        return scaffold;
      },
    );
  }
}
