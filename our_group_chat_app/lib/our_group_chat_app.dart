import 'package:our_group_chat_app/route_generator.dart';
import 'package:flutter/material.dart';

class OurGroupChatApp extends StatelessWidget {
  const OurGroupChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Group Chat App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
