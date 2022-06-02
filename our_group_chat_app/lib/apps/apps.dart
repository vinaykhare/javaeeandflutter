import 'package:apnavaio/login/login_data.dart';
import 'package:flutter/material.dart';

class Apps extends StatelessWidget {
  final LoginData loginData;
  const Apps({Key? key, required this.loginData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Apne VAIO Ki Apps"),
        ),
        body: Stack(
          children: [
            GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/chatapp',
                          arguments: loginData);
                    },
                    icon: const Icon(
                      Icons.chat,
                      size: 50,
                    )),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              color: Colors.red[100],
                              height: 250,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: const <Widget>[
                                      Icon(Icons.home),
                                      Icon(Icons.hot_tub),
                                      Icon(Icons.hourglass_empty),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: const <Widget>[
                                      Icon(Icons.home),
                                      Icon(Icons.hot_tub),
                                      Icon(Icons.hourglass_empty),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.connected_tv_rounded,
                      size: 50,
                    ))
              ],
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: TextField(
                autofocus: false,
              ),
            )
          ],
        ));
  }
}
