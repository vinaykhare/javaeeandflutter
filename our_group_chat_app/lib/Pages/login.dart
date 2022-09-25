import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:our_group_chat_app/Model/server_connection.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String fmToken;

  const LoginPage({
    Key? key,
    required this.fmToken,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? url, username;

  void _connect() async {
    bool isValid = formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      formKey.currentState?.save();
      ServerConnection connection =
          Provider.of<ServerConnection>(context, listen: false);
      connection.username = username ?? "";
      connection.url = url ?? "";
      connection.token = widget.fmToken;
      connection.login();
      connection.connectWebSocket();
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("serverConnection", jsonEncode(connection));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      key: const ValueKey("URL"),
                      keyboardType: TextInputType.url,
                      keyboardAppearance: Brightness.light,
                      decoration: const InputDecoration(
                        label: Text("URL"),
                      ),
                      onSaved: (newValue) => url = newValue,
                    ),
                    TextFormField(
                      key: const ValueKey("username"),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text("Username"),
                      ),
                      validator: (value) => value != null && value.length < 7
                          ? "Enter Valid Username"
                          : null,
                      onSaved: (newValue) => username = newValue,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: _connect,
                      child: const Text("Connet"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
