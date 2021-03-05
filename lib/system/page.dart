import 'package:flutter/cupertino.dart';

abstract class Controller<T extends StatefulWidget> extends State<T> {

  void refresh(Function refresh) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      refresh();
    });
  }

  // This widget is the root of your application.
  // This method is rerun every time setState is called, for instance as done
  // by the _incrementCounter method above.
  //
  // The Flutter framework has been optimized to make rerunning build methods
  // fast, so that you can just rebuild anything that needs updating rather
  // than having to individually change instances of widgets.
  @protected
  Widget build(BuildContext context);
}

abstract class View<T extends Controller> extends StatelessWidget {
  final T prop;
  View(this.prop);

  ViewExtends<View> getChildView(ViewExtends<View> child) => child;

  // This widget is the root of your application.
  // This method is rerun every time setState is called, for instance as done
  // by the _incrementCounter method above.
  //
  // The Flutter framework has been optimized to make rerunning build methods
  // fast, so that you can just rebuild anything that needs updating rather
  // than having to individually change instances of widgets.
  @protected
  Widget build(BuildContext context);
}

abstract class ViewExtends<T extends View> extends StatelessWidget {
  final T prop;
  ViewExtends(this.prop);

  // This widget is the root of your application.
  // This method is rerun every time setState is called, for instance as done
  // by the _incrementCounter method above.
  //
  // The Flutter framework has been optimized to make rerunning build methods
  // fast, so that you can just rebuild anything that needs updating rather
  // than having to individually change instances of widgets.
  @protected
  Widget build(BuildContext context);
}