import 'package:flutter/material.dart';
import 'package:camara_dos_deputados/routes/router.dart' as routes;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      onGenerateRoute: routes.controller,
      initialRoute: routes.home,
      debugShowCheckedModeBanner: false,
    );
  }
}
