import 'models/arjunane_model_alerts_widget.dart';
import 'models/arjunane_model_buttons_notifier.dart';
import 'models/arjunane_model_forms.dart';
import 'models/theme_core_model.dart';
import 'models/arjunane_model_expand_panel.dart';
import 'models/arjunane_model_view_widget.dart';


import 'request_data.dart';
import 'package:provider/provider.dart';

import 'routers_services.dart';
import 'package:flutter/material.dart';
import '../../app/config/configs.dart';
import 'models/arjunane_model_alerts_notifier.dart';
import 'page.dart';

typedef FutureCallback = Future Function(String);

class Routers
{
  static Widget getRoute(String? name, BuildContext context) {
    var routes = Configs.routes[name!];

    // throw to 404
    if(routes == null) return RoutersService.errorPage(0, name);
    Pages finalPages = routes as Pages;
    
    return WillPopScope(
      child: routes,
      // onWillPop: () async {
      //   //print("Isi dari ${callbackOnBackPress()}");
      //   finalPages.
      //   return callbackOnBackPress();
      // }
      // onWillPop: () async {
      //   print('============ ini kembali : $finalPages ===========');
      //   return finalPages.onBackPress(context);
      // },
      onWillPop: () async {
        bool isConfirm = await finalPages.onBackPress(context);
        if(isConfirm) RequestInit.onBack();
        return isConfirm;
      },
    );
  }

  static Widget getPage(String nameRoute) {
    var routes = Configs.routes[nameRoute];

    // throw to 404
    if(routes == null) return RoutersService.errorPage(0, nameRoute);

    return routes;
  }

  static Widget app(String? route) {
    
    var providers = Configs.providers;

    providers.add(ChangeNotifierProvider(create: (BuildContext context) => ArjunaneModelAlertsNotifier()));
    providers.add(ChangeNotifierProvider(create: (BuildContext context) => ArjunaneModelAlertsWidget()));
    providers.add(ChangeNotifierProvider(create: (BuildContext context) => ArjunaneModelButtonsNotifier()));
    providers.add(ChangeNotifierProvider(create: (BuildContext context) => ArjunaneModelExpandPanel()));
    providers.add(ChangeNotifierProvider(create: (BuildContext context) => ArjunaneModelForms()));
    providers.add(ChangeNotifierProvider(create: (BuildContext context) => ArjunaneModelViewWidget()));
    providers.add(ChangeNotifierProvider(create: (BuildContext context) => ThemeCoreModel()));
    
    //var page = getRoute(route);
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeCoreModel>(
        builder: (ctx, data, _) {
          return MaterialApp(
            theme: data.themeData,
            initialRoute: route,
            // routes: RoutersService.routes(),
            onGenerateRoute: RoutersService.onGenerateRoute,
          );
        },
      )
    );
  }

}