import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:our_group_chat_app/Model/server_connection.dart';
import 'package:our_group_chat_app/Pages/group_chat.dart';
import 'package:our_group_chat_app/Pages/login.dart';
import 'package:our_group_chat_app/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const OurGroupChatApp());
}

class OurGroupChatApp extends StatelessWidget {
  const OurGroupChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, appSnapshot) => MaterialApp(
          title: 'Our Group Chat App',
          theme: ThemeData(
            primarySwatch: Colors.brown,
          ),
          //initialRoute: "/",
          home: appSnapshot.connectionState != ConnectionState.done
              ? const SplashScreen()
              : MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => ServerConnection(),
                    ),
                  ],
                  child: FutureBuilder(
                    future: FirebaseMessaging.instance.getToken(),
                    builder: (context, tokenSnapshot) => FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: (context, pref) {
                        if (pref.connectionState == ConnectionState.waiting) {
                          return const SplashScreen();
                        }
                        if (pref.hasData) {
                          ServerConnection connection =
                              Provider.of<ServerConnection>(context,
                                  listen: false);
                          SharedPreferences prefData =
                              pref.data as SharedPreferences;
                          var sharedServerConnection =
                              prefData.getString("serverConnection");
                          if (sharedServerConnection != null) {
                            Map<String, dynamic> prefConnection =
                                jsonDecode(sharedServerConnection);
                            connection.username = prefConnection["username"];
                            connection.url = prefConnection["url"];
                            connection.token = tokenSnapshot.data.toString();
                            connection.loggedIn = true;
                            connection.connectWebSocket(false);
                          }
                        }
                        return Container(
                          child: Provider.of<ServerConnection>(context).loggedIn
                              ? const GroupChat()
                              : LoginPage(
                                  fmToken: tokenSnapshot.data.toString(),
                                ),
                        );
                      },
                    ),
                  ),
                )
          //onGenerateRoute: RouteGenerator.generateRoute,
          ),
    );
  }
}
