import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'system/core/routers_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  RoutersService.initialRouteSettings((route) async {

    // SharedPreferences shared = await SharedPreferences.getInstance();
    // route.baseRoute = shared.containsKey("isLogin") ? "home" : "login";
    
  });
}
