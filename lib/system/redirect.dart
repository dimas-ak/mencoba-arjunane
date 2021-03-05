import 'package:flutter/material.dart';
import 'helper/flashdata.dart';
import 'routers_services.dart';
import 'routers.dart';
import 'routers_animation.dart';

extension Redirect on NavigatorState {
  
  //static cb.OnBackPress _onBackPress = RoutersService.callbackOnBackPress;
  
  static Widget getPageView(String route) {
    return Routers.getRoute(route);
  }

  static void route(BuildContext context, String route,
      {RouterAnimationType type, Duration duration, bool isWillPopScope = false}) {
    var nextPage = Routers.app(route);

    if(isWillPopScope) FlashData.setData("isWillPopScope-data", true);

    // if (duration == null) duration = Duration(milliseconds: 200);
    duration = _durationCheck(duration);
    var redirect = RoutersAnimation.type(type, context, nextPage, duration);
    
    Navigator.pushAndRemoveUntil(context, redirect, (route) => false);
  }

  static Future forward(BuildContext context, String route,
      {RouterAnimationType type, Duration duration}) async
  {
    var nextPage = Routers.getRoute(route);

    duration = _durationCheck(duration);

    var redirect = RoutersAnimation.type(type, context, nextPage, duration);
    await Navigator.of(context).push(redirect);
  }

  static Duration _durationCheck(Duration duration) => duration == null ? new Duration(milliseconds: 200) : duration;

  static void onBackPress(Future<bool> Function() callback) => RoutersService.callbackOnBackPress = callback;

  static void back(BuildContext context, {dynamic sendDataToBack}) {
    Navigator.pop(context, sendDataToBack);
  }
}