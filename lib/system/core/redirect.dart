import 'package:flutter/material.dart';
import 'request_data.dart';
import 'page.dart';
import 'routers.dart';
import 'routers_animation.dart';

class RedirectData {
  final Controller previousController;
  final dynamic data;
  RedirectData(this.previousController, this.data);
}
extension Redirect on NavigatorState {
  
  //static cb.OnBackPress _onBackPress = RoutersService.callbackOnBackPress;
  
  // static Widget getPageView(String route) {
  //   return Routers.getRoute(route);
  // }

  static void route(BuildContext context, String routeName,
      {RouterAnimationType type, Duration duration, Map<String, dynamic> withData }) {
    var nextPage = Routers.app(routeName);

    RequestInit.currentPage = routeName;
    RequestInit.setPage(withData, isClear: true);

    // if (duration == null) duration = Duration(milliseconds: 200);
    duration = _durationCheck(duration);
    var redirect = RoutersAnimation.type(type, context, nextPage, duration);
    
    Navigator.pushAndRemoveUntil(context, redirect, (route) => false);
  }

  static Future forward(BuildContext context, String routeName,
      {RouterAnimationType type, Duration duration, Map<String, dynamic> withData }) async
  {
    RequestInit.currentPage = routeName;
    RequestInit.setPage(withData, isClear: false);

    var nextPage = Routers.getRoute(routeName,context);

    duration = _durationCheck(duration);

    var redirect = RoutersAnimation.type(type, context, nextPage, duration);
    await Navigator.of(context).push(redirect);
  }

  static Duration _durationCheck(Duration duration) => duration == null ? new Duration(milliseconds: 200) : duration;

  // static void onBackPress(Future<bool> Function() callback) => RoutersService.callbackOnBackPress = callback;

  static void back(BuildContext context, {RedirectData withData}) {
    Navigator.pop(context);
    if(withData != null) {
      withData.previousController.onBackData(withData.data);
    }
  }
}