import 'arjunane.dart';

import 'helper/flashdata.dart';

import '../app/config/configs.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

typedef CallbackOnBackPress = Future<bool> Function();

class _GetRoute { String baseRoute;}

class RoutersService
{

  static CallbackOnBackPress callbackOnBackPress;

  static Future initialRouteSettings(Function(_GetRoute) callback) async {
    _GetRoute gr = new _GetRoute();
    await callback(gr);
    run(gr.baseRoute);
  }

  static void run(String route)
  {
    if(route == null) route = Configs.baseRoute;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(new App(baseRoute: route));
  }

  static Map<String, WidgetBuilder> routes()
  {
    Map<String, Widget Function(BuildContext)> _routes = new Map<String, Widget Function(BuildContext)>();
    Configs.routes.forEach((key, value) {
      _routes[key] = (context) => value;
    });
    return _routes;
  }

  /// errorPage()
  /// 
  /// type 0 : 404
  static Widget errorPage(int type, dynamic msg) {
    var child;
    if(type == 0) child = _error404(msg);
    return Scaffold(
      appBar: null,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 24),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: child,
            ),
          )
        )
      ),
    );
  }

  static List<Widget> _error404(String route) {
    List<Widget> list = [
      Text("404", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      SizedBox(height: 10),
      Text("The page you are looking for '$route' doesn't exist")
    ];
    return list;
  }

  static Route onGenerateRoute<T>(RouteSettings settings) {
    Route page;

    if(Configs.routes.keys.contains(settings.name)) {
      Widget finalPage;
     // print("-----------ini ter-eksekusi =============");
      if(FlashData.getData("isWillPopScope-data") != null) {
        finalPage = 
          WillPopScope(
            child: Configs.routes[settings.name],
            onWillPop: () async {
              //print("Isi dari ${callbackOnBackPress()}");
              return callbackOnBackPress();
            }
          );
      }
      else {
        finalPage = Configs.routes[settings.name];
      }

      page = MaterialPageRoute(builder: (_) => finalPage);
    }
    return page;
  }
}