import 'package:provider/provider.dart';

import '../system/routers_services.dart';
import 'package:flutter/material.dart';
import '../app/config/configs.dart';
import 'arjunane_model.dart';

typedef FutureCallback = Future Function(String);

class Routers
{
  static Widget getRoute(String name) {
    return Configs.routes[name];
  }

  static Widget app(String route) {
    
    var providers = Configs.providers;

    providers.add(ChangeNotifierProvider(create: (BuildContext context) => ArjunaneModel()));
    
    //var page = getRoute(route);
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        initialRoute: route,
        // routes: RoutersService.routes(),
        onGenerateRoute: RoutersService.onGenerateRoute,
      )
    );
  }

}