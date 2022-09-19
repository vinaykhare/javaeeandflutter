//import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function connectSocket;

  const LoginPage({
    Key? key,
    required this.connectSocket,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController urlController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: urlController,
                  decoration:
                      const InputDecoration(hintText: "Insert WebSocket URL"),
                  onSubmitted: (data) {
                    widget.connectSocket(
                        usernameController.text, urlController.text);
                  },
                  keyboardType: TextInputType.url,
                ),
                TextField(
                  controller: usernameController,
                  decoration:
                      const InputDecoration(hintText: "Insert Username"),
                  onSubmitted: (data) {
                    widget.connectSocket(
                        usernameController.text, urlController.text);
                  },
                ),
                MaterialButton(
                  onPressed: () {
                    widget.connectSocket(
                        usernameController.text, urlController.text);
                  },
                  child: const Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
