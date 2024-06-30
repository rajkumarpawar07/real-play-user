import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home.dart';

class HomeScreensList extends StatelessWidget {
  const HomeScreensList({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: GlobalKey<NavigatorState>(), // Important for unique identification
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) =>
                const HomeScreen(); // Your tab's main screen
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
