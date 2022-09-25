import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:our_group_chat_app/Model/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerConnection with ChangeNotifier {
  late String url, username, token;
  bool loggedIn = false;
  WebSocketChannel? channel;
  List<ChatMessage> messages = [];

  ServerConnection();

  Map<String, dynamic> toJson() => {
        "url": url,
        "username": username,
      };

  ServerConnection.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        url = json['url'];

  connectWebSocket([bool notify = true]) {
    channel = WebSocketChannel.connect(
      Uri.parse(
        'ws://$url/socket/websocketserver/$username/$token',
      ), //192.168.1.250:8080 //122.175.208.221:8080 //localhost:8080/socket/sayhello //
    );

    if (notify) {
      notifyListeners();
    }
  }

  login() {
    loggedIn = true;
    notifyListeners();
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    username = "";
    url = "";
    loggedIn = false;
    channel = null;
    notifyListeners();
  }

  void sendMessage(String content, List<String>? images, List<String>? videos) {
    ChatMessage msg = ChatMessage(
      content: content,
      from: username,
      images: images ?? [],
      videos: videos ?? [],
    );
    // msg.images = [];
    // msg.videos = [];

    channel!.sink.add(jsonEncode(msg));
  }
}
