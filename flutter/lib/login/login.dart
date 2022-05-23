import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';

import 'login_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController urlController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  late WebSocketChannel channel;
  late String username;
  late String url;

  void _connectSocket() {
    channel = WebSocketChannel.connect(Uri.parse('ws://' +
            urlController.text +
            '/socket/websocketserver/' +
            usernameController
                .text) //192.168.1.250:8080 //122.175.208.221:8080 //localhost:8080/socket/sayhello //
        );
    username = usernameController.text;
    url = urlController.text;
    usernameController.clear();
    urlController.clear();
    Navigator.pushNamed(context, '/chatapp',
        arguments: LoginData(username: username, messages: [], url: url));
  }

  void logout() {
    setState(() {
      username = "";
    });
    channel.sink.close();
  }

  Center buildUserInputForm() {
    return Center(
      child: Column(
        children: [
          const Text(
            "Let's connect with VAIO First by inserting the username...",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 15,
          ),
          SizedBox(
            width: 500,
            child: TextField(
              controller: usernameController,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              onSubmitted: (value) {
                _connectSocket();
              },
            ),
          ),
          IconButton(
              onPressed: _connectSocket,
              icon: const Icon(
                Icons.connected_tv,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Column(
        children: [
          TextField(
            controller: urlController,
            decoration: const InputDecoration(hintText: "Insert WebSocket URL"),
          ),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(hintText: "Insert Username"),
          ),
          MaterialButton(
            onPressed: _connectSocket,
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}
