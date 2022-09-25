import 'package:flutter/material.dart';
import 'package:our_group_chat_app/Model/server_connection.dart';
import 'package:our_group_chat_app/Widgets/messages.dart';
import 'package:our_group_chat_app/Widgets/send_message.dart';
import 'package:provider/provider.dart';

class GroupChat extends StatelessWidget {
  const GroupChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var channel = WebSocketChannel.connect(
    //   Uri.parse(
    //     'ws://${serverConnection.url}/socket/websocketserver/${serverConnection.username}/${serverConnection.token}',
    //   ), //192.168.1.250:8080 //122.175.208.221:8080 //localhost:8080/socket/sayhello //
    // );
    return Scaffold(
        appBar: AppBar(
          title:
              Text("Hello ${Provider.of<ServerConnection>(context).username}"),
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<ServerConnection>(context, listen: false).logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Column(
          children: [
            const Expanded(
              child: Messages(),
            ),
            SendMessage(),
          ],
        ));
  }
}
