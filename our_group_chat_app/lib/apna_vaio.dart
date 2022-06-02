import 'package:apnavaio/route_generator.dart';
import 'package:flutter/material.dart';

class ApnaVaio extends StatelessWidget {
  const ApnaVaio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apna VAIO',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
