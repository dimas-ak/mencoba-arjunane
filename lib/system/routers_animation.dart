import 'package:flutter/material.dart';

class RoutersAnimation {

  static Route<bool> type(RouterAnimationType type, BuildContext context, Widget nextPage, Duration duration)
  {
    var redirect;
    switch (type) {
      case RouterAnimationType.fadeIn:
        redirect = _CustomRoute.fadeIn(context.widget, nextPage, duration);
        break;
      case RouterAnimationType.scaleIn:
        redirect = _CustomRoute.scaleIn(context.widget, nextPage, duration);
        break;
      case RouterAnimationType.fromLeft:
        redirect = _CustomRoute.fromLeft(context.widget, nextPage, duration);
        break;
      case RouterAnimationType.fromTop:
        redirect = _CustomRoute.fromTop(context.widget, nextPage, duration);
        break;
      case RouterAnimationType.fromRight:
        redirect = _CustomRoute.fromRight(context.widget, nextPage, duration);
        break;
      case RouterAnimationType.fromBottom:
        redirect = _CustomRoute.fromBottom(context.widget, nextPage, duration);
        break;
      case RouterAnimationType.toLeft:
        redirect = _CustomRoute.toLeft(context.widget, nextPage, duration);
        break;
      case RouterAnimationType.toTop:
        redirect = _CustomRoute.toTop(context.widget, nextPage, duration);
        break;
      case RouterAnimationType.toRight:
        redirect = _CustomRoute.toRight(context.widget, nextPage, duration);
        break;
      case RouterAnimationType.toBottom:
        redirect = _CustomRoute.toBottom(context.widget, nextPage, duration);
        break;
      default:
        redirect = _CustomRoute.fadeIn(context.widget, nextPage, duration);
    }
    return redirect;
  }
}

class _CustomRoute {
  static Route<bool> fadeIn(
      Widget currentPage, Widget nextPage, Duration duration) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => nextPage,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondAnimation, child) =>
            FadeTransition(opacity: animation, child: child));
  }

  static Route<bool> scaleIn(
      Widget currentPage, Widget nextPage, Duration duration) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => nextPage,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondAnimation, child) =>
            ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                ),
              ),
              child: child,
            ));
  }

  static SlideTransition _from(double x, double y, Animation animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(x, y),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Route<bool> fromLeft(
      Widget currentPage, Widget nextPage, Duration duration) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => nextPage,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondAnimation, child) =>
            _from(-1, 0, animation, child));
  }

  static Route<bool> fromTop(
      Widget currentPage, Widget nextPage, Duration duration) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => nextPage,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondAnimation, child) =>
            _from(0, -1, animation, child));
  }

  static Route<bool> fromRight(
      Widget currentPage, Widget nextPage, Duration duration) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => nextPage,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondAnimation, child) =>
            _from(1, 0, animation, child));
  }

  static Route<bool> fromBottom(
      Widget currentPage, Widget nextPage, Duration duration) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => nextPage,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondAnimation, child) =>
            _from(0, 1, animation, child));
  }

  static Stack _to(double currentX, double currentY, double nextX, double nextY,
      Animation animation, Widget currentPage, Widget nextPage) {
    return Stack(
      children: <Widget>[
        SlideTransition(
          position: new Tween<Offset>(
            begin: Offset(0.0, 0.0),
            end: Offset(currentX, currentY),
          ).animate(animation),
          child: currentPage,
        ),
        SlideTransition(
          position: new Tween<Offset>(
            begin: Offset(nextX, nextY),
            end: Offset.zero,
          ).animate(animation),
          child: nextPage,
        )
      ],
    );
  }

  static Route<bool> toLeft(
      Widget currentPage, Widget nextPage, Duration duration) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => currentPage,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondAnimation, child) =>
            _to(-1, 0, 1, 0, animation, currentPage, nextPage));
  }

  static Route<bool> toTop(
      Widget currentPage, Widget nextPage, Duration duration) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => currentPage,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondAnimation, child) =>
            _to(0, -1, 0, 1, animation, currentPage, nextPage));
  }

  static Route<bool> toRight(
      Widget currentPage, Widget nextPage, Duration duration) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => currentPage,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondAnimation, child) =>
            _to(1, 0, -1, 0, animation, currentPage, nextPage));
  }

  static Route<bool> toBottom(
      Widget currentPage, Widget nextPage, Duration duration) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => currentPage,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondAnimation, child) =>
            _to(0, 1, 0, -1, animation, currentPage, nextPage));
  }
}

enum RouterAnimationType {
  fadeIn,
  scaleIn,
  fromLeft,
  fromRight,
  fromBottom,
  fromTop,
  toLeft,
  toTop,
  toRight,
  toBottom
}
