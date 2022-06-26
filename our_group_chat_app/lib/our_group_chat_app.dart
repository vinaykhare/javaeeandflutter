import 'package:our_group_chat_app/apps/chat/group_chat.dart';
import 'package:our_group_chat_app/login/login.dart';
//import 'package:our_group_chat_app/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:our_group_chat_app/login/login_data.dart';

class OurGroupChatApp extends StatefulWidget {
  const OurGroupChatApp({Key? key}) : super(key: key);

  @override
  State<OurGroupChatApp> createState() => _OurGroupChatAppState();
}

class _OurGroupChatAppState extends State<OurGroupChatApp> {
  LoginData loginData = LoginData(
    username: '',
    url: '',
  );

  void connectSocket(String username, String url) {
    // Navigator.pushNamed(context, '/chatapp',
    //     arguments: LoginData(
    //       username: username,
    //       messages: [],
    //       url: url,
    //     ));

    setState(() {
      loginData.username = username;
      loginData.url = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Our Group Chat App',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        //initialRoute: "/",
        home: loginData.username == '' && loginData.url == ''
            ? LoginPage(connectSocket: connectSocket)
            : GroupChat(loginData: loginData)
        //onGenerateRoute: RouteGenerator.generateRoute,
        );
  }
}
