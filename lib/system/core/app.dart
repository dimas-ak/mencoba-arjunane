import 'routers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final String baseRoute;

  const App({Key key, this.baseRoute}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Routers.app(baseRoute);
    // return new MaterialApp(
    //   onGenerateRoute: ServiceRoute.onGenerateRoute,
    //   routes: ServiceRoute.routes(),
    //   initialRoute: baseRoute,
    // );
  }
}