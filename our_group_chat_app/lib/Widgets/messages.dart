import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:our_group_chat_app/Model/chat_message.dart';
import 'package:our_group_chat_app/Model/server_connection.dart';
import 'package:our_group_chat_app/Widgets/message_bubble.dart';
import 'package:our_group_chat_app/splash_screen.dart';
import 'package:provider/provider.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ServerConnection serverConnection = Provider.of<ServerConnection>(context);
    return StreamBuilder(
      stream: serverConnection.channel!.stream, //channel.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const SplashScreen();
        }

        String event = snapshot.data as String;
        if (snapshot.hasData) {
          if (event.toString().startsWith("[")) {
            List<dynamic> receivedMessages = jsonDecode(event) as List<dynamic>;

            for (var jsonMessage in receivedMessages) {
              serverConnection.messages.insert(
                0,
                ChatMessage(
                  content: jsonMessage["content"],
                  from: jsonMessage["from"],
                  images: [],
                  videos: [],
                ),
              );
            }
          } else {
            Map<String, dynamic> receivedMessage =
                jsonDecode(event) as Map<String, dynamic>;
            serverConnection.messages.insert(
              0,
              ChatMessage(
                content: receivedMessage["content"],
                from: receivedMessage["from"],
                images: [],
                videos: [],
              ),
            );
          }
        }
        return ListView.builder(
          reverse: true,
          itemCount: serverConnection.messages.length,
          itemBuilder: (context, index) => MessageBubble(
            message: serverConnection.messages[index].content,
            isMe: serverConnection.messages[index].from ==
                serverConnection.username,
            username: serverConnection.messages[index].from,
            imageUrl: "",
          ),
        );
      },
    );
  }
}
