import 'package:flutter/material.dart';
import 'package:camara_dos_deputados/screens/commissions.dart';
import 'package:camara_dos_deputados/screens/parliamentarians.dart';

import '../models/parliamentarian.dart';
import '../screens/home.dart';
import '../screens/parliamentarian_details.dart';

const String home = '/';
const String parliamentarians = '/parliamentarians';
const String parliamentarian = '/parliamentarian';
const String commissions = '/commissions';

Route controller(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const Home());
    case '/parliamentarians':
      return MaterialPageRoute(builder: (context) => const Parliamentarians());
    case '/parliamentarian':
      return MaterialPageRoute(
          builder: (context) => ParliamentarianDetails(
              parliamentarian: settings.arguments as Parliamentarian));
    case '/commissions':
      return MaterialPageRoute(builder: (context) => Commissions());
    default:
      return MaterialPageRoute(builder: (context) => const Home());
  }
}
