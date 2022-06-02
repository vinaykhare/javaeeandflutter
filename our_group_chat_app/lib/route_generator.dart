import 'package:our_group_chat_app/apps/apps.dart';
import 'package:our_group_chat_app/login/login.dart';
import 'package:our_group_chat_app/login/login_data.dart';
import 'package:flutter/material.dart';
//import 'chatapp/chat_app.dart';
import 'apps/chat/group_chat.dart';
import 'apps/chat/group_chat_old.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    //final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case '/apps':
        final loginData = settings.arguments as LoginData;
        return MaterialPageRoute(
            builder: (_) => Apps(
                  loginData: loginData,
                ));
      case '/chatapp':
        final loginData = settings.arguments as LoginData;
        return MaterialPageRoute(
          //builder: (context) => const ChatDetailPage(title: 'Home Chat Group'),
          builder: (context) => GroupChat(loginData: loginData),
        );
      case '/chatappold':
        return MaterialPageRoute(
          //builder: (context) => const ChatDetailPage(title: 'Home Chat Group'),
          builder: (context) => const GroupChatOld(title: 'Our Group Chat App'),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
